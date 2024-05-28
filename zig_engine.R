library(knitr)
library(readr)
library(stringr)

options(zig_exe_path = "/home/pedro-dev/Documents/_Programs/zig-linux-x86_64-0.11.0/zig")
options(width = 50)

find_zig_ <- function() {
  p <- Sys.which("zig")
  if (p == "") {
    p <- getOption("zig_exe_path")
  }

  return(p)
}

str_split_lines <- function(text, options) {
  output_width <- getOption("width")
  if (length(text) == 0) {
    return(text)
  }
  if (length(text) > 1) {
    text <- str_flatten(text, collapse = "")
  }
  
  n_chars <- str_length(text)
  if (n_chars <= output_width) {
    return(text)
  }

  if (!is.null(options$truncate) && options$truncate == TRUE) {
    return(str_trunc(text, output_width))
  }
  
  n_breaks <- as.integer(floor(n_chars / output_width))
  lines <- vector("character", n_breaks + 1L)
  idx <- 1L
  last_str_index <- 1L
  while (TRUE) {
    if (idx * output_width >= n_chars) {
      lines[idx] <- str_sub(text, last_str_index, n_chars)
      break
    }
    substr <- str_sub(text, last_str_index, idx * output_width)
    lines[idx] <- paste0(substr, "\n  ")
    last_str_index <- as.integer(idx * output_width)
    idx <- idx + 1L
  }
  
  return(str_flatten(lines))
}



knitr::knit_engines$set(zig = function(options) {
  code <- paste(options$code, collapse = "\n")
  if (!options$eval) {
    return(knitr::engine_output(options, code, NULL))
  }

  temp_file <- tempfile(fileext = ".zig")
  readr::write_file(code, temp_file)
  zig_cmd_path <- find_zig_()
  out <- system2(
    zig_cmd_path,
    c("run", shQuote(temp_file)),
    stdout = TRUE
  )
  
  out <- str_split_lines(out, options)
  knitr::engine_output(options, code, out)
})



teste_zig <- function(code) {
  code <- paste(code, collapse = "\n")
  temp_file <- tempfile(fileext = ".zig")
  readr::write_file(code, temp_file)
  zig_cmd_path <- find_zig_()
  out <- system2(
    zig_cmd_path,
    c("run", shQuote(temp_file)),
    stdout = TRUE
  )

  out
}

test_code <- '
const std = @import("std");

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    try stdout.print("Hello, {s}!\\n", .{"world"});
}
'

# teste_zig(test_code)
