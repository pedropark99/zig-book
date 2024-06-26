library(tidyverse)
library(magick)

bridge <- "Cover/new-york-bridge.png"
bridge <- png::readPNG(bridge)
g <- grid::rasterGrob(bridge, interpolate=TRUE)
