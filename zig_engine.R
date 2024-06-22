library(knitr)
library(readr)
library(stringr)


sys_info <- Sys.info()
if (sys_info["sysname"] == "Linux" & str_detect(sys_info["release"], "WSL")) {
  # Running on WSL
  p <- "/mnt/c/Users/pedro/Documents/_Programs/zig-linux/zig"
} else if (sys_info["sysname"] == "Linux") {
  # Running on Ubuntu
  p <- "/home/pedro-dev/Documents/_Programs/zig-linux/zig"
}


options(zig_exe_path = p)
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

extract_delim_type <- function(lines) {
  regex <- "^// (={4,}) ?([a-zA-Z]+)"
  group_name <- str_extract(lines, regex, group = 2)
  group_name <- group_name[!is.na(group_name)]
  return(str_to_lower(group_name))
}

extract_delim_lines <- function(lines) {
  regex <- "^// (={4,}) ?([a-zA-Z]+)"
  line_index <- str_which(lines, regex)
  return(line_index)
}

split_functions_from_var <- function(code) {
  regex <- "^// (={4,})"
  lines <- unlist(str_split(code, "\n"))
  group_name <- extract_delim_type(lines)
  delim_lines <- extract_delim_lines(lines)
  results <- list(
    vars = "",
    structs = "",
    funs = ""
  )
  if (length(delim_lines) == 0) {
    results$vars <- code
    return(results)
  }

  if (length(group_name) != length(delim_lines)) {
    stop("Problem when generating auto main! Length of grouping names is different than the length of grouping indexes.")
  }

  last_index <- length(lines)
  for (i in rev(seq_along(group_name))) {
    type <- group_name[i]
    index <- delim_lines[i]
    lines_to_separate <- lines[index:last_index]
    last_index <- index - 1L
    if (str_detect(type, "struct")) {
      results$structs <- str_c(lines_to_separate, collapse = "\n")
    }
    if (str_detect(type, "function")) {
      results$funs <- str_c(lines_to_separate, collapse = "\n")
    }
    if (str_detect(type, "variable")) {
      results$vars <- str_c(lines_to_separate, collapse = "\n")
    }
  }

  return(results)
}




generate_main <- function(code_without_main) {
  code_without_main <- split_functions_from_var(
    code_without_main
  )
  main_fmt <- c(
    "const std = @import(\"std\");\n",
    "pub fn main() !void {\n",
    "%s",
    "\n}\n",
    "\n%s\n",
    "\n%s\n"
  )
  main_fmt <- paste(main_fmt, sep = "", collapse = "\n")
  code_with_main <- sprintf(
    main_fmt,
    code_without_main$vars,
    code_without_main$structs,
    code_without_main$funs
  )
  # cat(code_with_main, file = stderr())
  return(code_with_main)
}


remove_delim_lines <- function(code) {
  regex <- "^// (={4,})"
  lines <- unlist(str_split(code, "\n"))
  delim_lines <- str_which(lines, regex)
  lines[delim_lines] <- ""
  code_fixed <- str_c(lines, collapse = "\n")
  return(str_trim(code_fixed))
}


get_auto_main <- function(options) {
  if (length(options$auto_main) == 0L) {
    return(FALSE)
  }

  return(options$auto_main)
}




knitr::knit_engines$set(zig = function(options) {
  code <- paste(options$code, collapse = "\n")
  if (!options$eval) {
    return(knitr::engine_output(options, code, NULL))
  }
  auto_main <- get_auto_main(options)
  if (auto_main) {
    code_to_execute <- generate_main(code)
  } else {
    code_to_execute <- code
  }

  temp_file <- tempfile(fileext = ".zig")
  readr::write_file(code_to_execute, temp_file)
  zig_cmd_path <- find_zig_()
  out <- system2(
    zig_cmd_path,
    c("run", shQuote(temp_file)),
    stdout = TRUE
  )
  if (exit_status_code(out) != 0L) {
    code_report <- c(
      "\n====== CODE EXECUTED ======",
      "%s",
      "===========================\n"
    )
    code_report <- str_c(code_report, collapse = "\n")
    code_report <- sprintf(code_report, code_to_execute)
    cat(code_report, file = stderr())
  }
  out <- str_split_lines(out, options)
  code <- remove_delim_lines(code)
  knitr::engine_output(options, code, out)
})


exit_status_code <- function(output) {
  status <- attr(output, "status")
  if (length(status) == 0L || is.null(status)) {
    return(0L)
  }

  return(status)
}


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
