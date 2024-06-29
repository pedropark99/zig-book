# https://www.tylerxhobbs.com/works/untitled-cityscape
library(tidyverse)
pallete <- c(
  "white",
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


canvas_width <- 250
canvas_height <- 180
n_stars <- 800
canvas_limits <- coord_cartesian(
  xlim = c(0, canvas_width),
  ylim = c(0, canvas_height),
  expand = FALSE
)



distance <- function(x1, y1, x2, y2) {
  s1 <- (x2 - x1) ^ 2
  s2 <- (y2 - y1) ^ 2
  return(sqrt(s1 + s2))
}

compare <- function(x, y, xs, ys, treshold = 3) {
  ds <- distance(x, y, xs, ys)
  return(any( ds <= treshold & ds > 0.0000001 ))
}

overlap <- function(x, y) {
  map2_lgl(x, y, compare, xs = x, ys = y)
}




set.seed(10)
stars <- tibble(
  star_id = seq_len(n_stars),
  x = runif(n_stars, min = 0, max = canvas_width),
  y = runif(n_stars, min = 0, max = canvas_height),
)

stars <- stars %>% 
  mutate(
    pcolor = sample(pallete, n_stars, replace = TRUE),
    overlap = overlap(x, y)
  ) %>% 
  filter(overlap == FALSE)

stars %>% 
  ggplot() +
  geom_point(
    aes(x, y, color = pcolor)
  ) +
  scale_color_identity() +
  canvas_limits +
  theme_void() +
  theme(
    plot.background = element_rect(fill = "#2144B6")
  )





factor <- 0.25
star_poly_x <- c(0, 0.25, 1, 0.35, 0.65, 0, -0.65, -0.35, -1, -0.25, 0) * factor
star_poly_y <- c(1, 0, 0, -0.65, -1.8, -1, -1.8, -0.65, 0, 0, 1) * factor

stars <- stars %>% 
  mutate(
    x_poly = map(star_id, \(x) star_poly_x),
    y_poly = map(star_id, \(y) star_poly_y),
  ) %>% 
  unnest_longer(col = c(x_poly, y_poly)) %>% 
  mutate(
    x_poly = x + x_poly,
    y_poly = y + y_poly,
  )



plot <- stars %>% 
  ggplot() +
  geom_polygon(
    aes(x = x_poly, y = y_poly, group = star_id, fill = pcolor, color = pcolor)
  ) +
  scale_color_identity() +
  scale_fill_identity() +
  canvas_limits +
  theme_void()


proj <- "/home/pedro-dev/Documents/Projetos/Livros/zig-book/"
ragg::agg_png(
  paste0(proj, "Cover/stars_art.png"),
  width = 2200,
  height = 1400,
  res = 700,
  background = NULL
)
print(plot)
dev.off()

