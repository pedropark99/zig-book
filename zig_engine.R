library(knitr)
library(readr)

options(zig_exe_path = "/home/pedro-dev/Documents/_Programs/zig-linux-x86_64-0.11.0/zig")

find_zig_ <- function() {
  p <- Sys.which("zig")
  if (p == "") {
    p <- getOption("zig_exe_path")
  }

  return(p)
}

knitr::knit_engines$set(zig = function(options) {
  code <- paste(options$code, collapse = "\n")
  if (!options$eval) {
    return(NULL)
  }
  
  temp_file <- tempfile(fileext = ".zig")
  readr::write_file(code, temp_file)
  zig_cmd_path <- find_zig_()
  out  <- system2(
    zig_cmd_path,
    c('run', shQuote(temp_file)),
    stdout = TRUE
  )

  knitr::engine_output(options, code, out)
})



teste_zig <- function(code) {
  code <- paste(code, collapse = "\n")
  temp_file <- tempfile(fileext = ".zig")
  readr::write_file(code, temp_file)
  zig_cmd_path <- find_zig_()
  out  <- system2(
    zig_cmd_path,
    c('run', shQuote(temp_file)),
    stdout = TRUE
  )
  
  out
}

code <- '
const std = @import("std");

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    try stdout.print("Hello, {s}!\\n", .{"world"});
}
'

# teste_zig(code)
