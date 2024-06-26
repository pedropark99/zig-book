library(tidyverse)
library(ggfx)
library(terra)
library(sf)


pallete <- c(
  "white",
  "#2144B6",
  "#F76C49",
  "#6F9283"
)

gradient <- c(
  "#E8EDEB",
  "#DCE5E1", "#D0DCD7", "#C5D3CD",
  "#B9CAC3", "#AEC2B9", "#A2B9AF",
  "#96B0A5", "#8BA79B", "#7F9F91", 
  "#6F9283", "#698C7D", "#608072",
  "#587468", "#4F695E", "#465D53", 
  "#3D5149", "#35463E", "#2C3A34",
  "#232F2A", "#1A231F", "#121715", 
  "#090C0A"
)


canvas_width <- 100
canvas_height <- 70
min_bwidth <- 5
max_bwidth <- 10
min_bheight <- 20
max_bheight <- 70
n_builds <- 10
canvas_limits <- coord_cartesian(
  xlim = c(0, canvas_width),
  ylim = c(0, canvas_height),
  expand = FALSE
)



proj <- "/home/pedro-dev/Documents/Projetos/Livros/zig-book/"
bridge_path <- paste0(proj, "Cover/new-york-bridge-cropped.png")
builds_path <- paste0(proj, "Cover/new-york-buildings.png")

builds <- rast(builds_path)
polyi <- as.polygons(builds, aggregate = TRUE)
polyi <- st_cast(st_as_sf(polyi[1]), "POLYGON")

bridge <- rast(bridge_path)
polyi <- as.polygons(bridge)
polyi <- st_cast(st_as_sf(polyi[1]), "POLYGON")

is_white <- function(pixel) {
  return(dplyr::near(sum(pixel), 4))
}


canvas <- tibble(
  x = rep(seq_len(canvas_width), each = canvas_height),
  y = rep(seq_len(canvas_height), times = canvas_width),
)


calc_gradient_probs <- function(yp, probs, extra = 1) {
  factors <- rev(seq_along(probs))
  factors <- (factors ^ extra) * yp
  factors <- factors / max(factors)
  return(probs * factors)
}



sample_color <- function(y, yp_threshold = 0.55, extra = 1) {
  yp <- y / canvas_height
  cumprobs <- gradient |> seq_along() |> cumsum()
  cumprobs <- cumprobs ^ 3
  probs <- cumprobs * (1 / (cumprobs |> sum()))
  if (yp >= yp_threshold) {
    probs <- calc_gradient_probs(yp, probs, extra)
  } else {
    probs[(length(probs) - 6):length(probs)] <- probs[(length(probs) - 6):length(probs)] * 6
  }

  return(sample(
    gradient,
    1L,
    prob = probs
  ))
}

canvas <- canvas %>% 
  mutate(
    pcolor = map_chr(y, sample_color)
  )


canvas %>% 
  ggplot() +
  geom_point(
    aes(x, y, color = pcolor)
  ) +
  scale_color_identity() +
  canvas_limits



flipped_polyi <- st_coordinates(polyi) %>% 
  as_tibble() %>% 
  mutate(
    y = (Y * -1) * (canvas_height / max(Y)),
    y = y + canvas_height + 15,
    x = X * (canvas_width / max(X)),
  )

mask <- ggplot() +
  as_reference(
    geom_polygon(
      aes(x, y),
      data = flipped_polyi
    ),
    id = 'buildings'
  ) +
  with_mask(
    geom_tile(
      aes(x, y, height = 1, width = 0.7,
          color = pcolor, fill = pcolor),
      data = canvas
    ),
    mask = ch_alpha('buildings')
  ) +
  scale_color_identity() +
  scale_fill_identity() +
  coord_equal() +
  theme_void()


ragg::agg_png(
  paste0(proj, "Cover/buildings_art.png"),
  width = 2200,
  height = 1400,
  res = 700,
  background = NULL
)
print(mask)
dev.off()




ragg::agg_png(
  paste0(proj, "Cover/canvas_background_art.png"),
  width = 2200,
  height = 1400,
  res = 700,
  background = NULL
)
canvas %>% 
  ggplot() +
  geom_tile(
    aes(x, y, height = 1, width = 0.7,
        color = pcolor, fill = pcolor),
    data = canvas
  ) +
  scale_color_identity() +
  scale_fill_identity() +
  canvas_limits +
  theme_void()
dev.off()




canvas <- tibble(
  x = rep(seq_len(canvas_width), each = canvas_height),
  y = rep(seq_len(canvas_height), times = canvas_width),
)

canvas <- canvas %>% 
  mutate(
    pcolor = map_chr(y, sample_color, yp_threshold = 0.30, extra = 4)
  )

canvas %>% 
  ggplot() +
  geom_point(
    aes(x, y, color = pcolor)
  ) +
  scale_color_identity() +
  canvas_limits




bridge <- png::readPNG(bridge_path)
g <- grid::rasterGrob(bridge)

mask <- ggplot() +
  as_reference(
    annotation_custom(g),
    id = "bridge"
  ) +
  with_mask(
    geom_tile(
      aes(x, y, height = 1, width = 0.7,
          color = pcolor, fill = pcolor),
      data = canvas
    ),
    mask = ch_alpha('bridge')
  ) +
  scale_color_identity() +
  scale_fill_identity() +
  coord_equal() +
  theme_void()


ragg::agg_png(
  paste0(proj, "Cover/bridge_art.png"),
  width = 2200,
  height = 1400,
  res = 700,
  background = NULL
)
print(mask)
dev.off()
