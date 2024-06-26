# https://www.tylerxhobbs.com/works/untitled-cityscape
library(tidyverse)
pallete <- c(
  "white",
  "#2144B6",
  "#F76C49",
  "#6F9283"
)


canvas_width <- 1000
canvas_height <- 700
min_bwidth <- 50
max_bwidth <- 100
min_bheight <- 200
max_bheight <- 700
n_builds <- 10



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



builds %>% 
  ggplot() +
  geom_rect(
    aes(ymin = 0, ymax = y, xmax = xend, xmin = xstart)
  ) +
  coord_cartesian(
    xlim = c(0, canvas_width),
    ylim = c(0, canvas_height),
    expand = FALSE
  )
