# https://www.tylerxhobbs.com/works/untitled-cityscape
library(tidyverse)
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


set.seed(10)
builds <- tibble(
  build_id = seq_len(n_builds),
  space_between = ((rnorm(n_builds) + 1) * 5) |> abs(),
  build_height = runif(n_builds, min = min_bheight, max = max_bheight),
  build_width = runif(n_builds, min = min_bwidth, max = max_bwidth)
)  %>% 
  mutate(
    xend = cumsum(build_width + space_between),
    xstart = xend - build_width,
    y = build_height
  )


get_building <- function(grid, builds) {
  builds_vec <- vector("list", nrow(canvas))
  for (i in seq_len(nrow(builds))) {
    build_as_list <- builds[i, ] |> as.list()
    test <- (
      grid$col >= build_as_list$xstart
      & grid$col <= build_as_list$xend
      & grid$row <= build_as_list$build_height
    )
    builds_to_add <- map(seq_len(sum(test)), \(x) build_as_list)
    builds_vec[test] <- builds_to_add
  }
  grid$build <- builds_vec
  grid$have_build <- map_lgl(grid$build, function(x) !is.null(x))
  return(grid)
}


canvas <- tibble(
  col = rep(seq_len(canvas_width), each = canvas_height),
  row = rep(seq_len(canvas_height), times = canvas_width),
)
canvas <- get_building(canvas, builds)


calc_gradient_probs <- function(yp, probs) {
  n <- length(probs)
  invert_pos <- if (floor(yp * n) > 0) floor(yp * n) else 1L
  factors <- vector("integer", length = n)
  count <- 2L
  for (i in seq_len(n)) {
    if (i >= invert_pos) {
      factors[i] <- i - count
      count <- count + 2L
      next
    }
    factors[i] <- i
  }
  
  factors <- rev(factors) ^ 2
  factors <- factors / max(factors)
  return(probs * factors)
}


sample_color <- function(x, y, build) {
  if (is.null(build)) {
    return("white")
  }
  
  xp <- (x - build$xstart) / (build$xend - build$xstart)
  yp <- y / build$build_height
  cumprobs <- gradient |> seq_along() |> cumsum()
  cumprobs <- cumprobs ^ 3
  probs <- cumprobs * (1 / (cumprobs |> sum()))
  if (yp >= 0.85) {
    probs <- calc_gradient_probs(yp, probs)
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
    pcolor = pmap_chr(list(col, row, build), sample_color)
  )



canvas %>% 
  ggplot() +
  geom_point(
    aes(x = col, y = row, color = pcolor)
  ) +
  scale_color_identity() +
  canvas_limits







