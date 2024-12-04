library(knitr)
library(readr)
library(stringr)

#' Find path to the Zig compiler in the current machine.
#'
#' This function is used to find the full path to the Zig compiler
#' installed in the current machine that is trying to build the book.
#'
#' A search process is performed in two stages over the current machine
#' to find the Zig compiler. First, the function tries to find the compiler
#' by using the R inferface to the command-line `which` command.
#'
#' If the compiler is not found in the first stage, then, the function
#' tries a new strategy in the second stage. In this stage, the function
#' iterates through the directories listed in the `PATH` environment
#' variable, and tries to find the Zig compiler in one of these directories.
#' This strategy is much slower, but it is more garanteed to work.
#'
#' If the compiler is found, the function returns a string with the full path to the compiler.
#' If the function does not find the Zig compiler in any of the two stages,
#' an runtime error is raised by the R process.
#'
#' @return A string with the full path to the compiler installed in the current machine.
find_zig_ <- function() {
  possible_paths <- c(
    "/mnt/c/Users/pedro/Documents/_Programs/zig-linux/zig",
    "/home/pedro-dev/Documents/_Programs/zig-linux/zig",
    Sys.which("zig")
  )

  for (path in possible_paths) {
    if (file.exists(path)) {
      return(path)
    }
  }

  path <- find_in_path_()
  if (is.null(path)) {
    stop("[ERROR]: Unable to find the zig compiler in your computer!")
  }
  return(path)
}


find_in_path_ <- function() {
  cat("[INFO]: Zig not found through `which`. Trying to find it through PATH...\n", file = stderr())
  path <- Sys.getenv("PATH")
  path_dirs <- str_split_1(path, ":")
  for (dir in path_dirs) {
    execs <- fs::dir_ls(dir, type = "file")
    zig_found <- str_detect(execs, "/zig$")
    if (any(zig_found)) {
      message <- sprintf("Zig found at %s\n", execs[zig_found])
      cat(message, file = stderr())
      return(as.character(execs[zig_found]))
    }
  }

  return(NULL)
}


# The full path to the Zig compiler is registered in the R process
# inside the global option `zig_exe_path`. And you can retrieve the
# value registered in this option with `getOption("zig_exe_path")`.
options(zig_exe_path = find_zig_())
options(width = 50)




#' Format Zig output.
#'
#' This function is used to format the output produced by the Zig
#' code that was compiled and executed by the Zig compiler. More
#' specifically, this function is used specially when the output
#' is very long.
#'
#' If the output is very long, this can be cubersome and hard to
#' follow/read in the book. Good strategies to deal with this problem
#' are: 1) to split the output into multiple lines if it is too long;
#' 2) or to truncate the output until a certain limit.
#'
#' This function performs one of these strategies depending on the
#' width of the output, and the options that were setted/configured
#' in the current code block.
#'
#' @param text The output to be formatted.
#' @param options The list of code block options.
#'
#' @return A string containing the formatted output.
format_output <- function(text, options) {
  if (length(text) == 0) {
    return(text)
  }
  if (length(text) > 1) {
    text <- str_flatten(text, collapse = "")
  }

  output_width <- getOption("width")
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



#' Auto generate main function.
#'
#' You provide some Zig code as input, and this function
#' auto-generates a `main()` Zig function that encapsulates
#' the input Zig code.
#'
#' This function is used when a code block in the book source code
#' is marked with the `auto_main: true` option.
#'
#' @param code_without_main A string containing some Zig code to be
#'     encapsulated inside a `main()` function.
#' @return A string containing a `main()` function that encapsulates the
#'     input Zig code.
generate_main <- function(code_without_main) {
  code_without_main <- increase_indentation__(code_without_main)
  main_fmt <- c(
    "const std = @import(\"std\");\n",
    "const stdout = std.io.getStdOut().writer();\n",
    "pub fn main() !void {\n",
    "%s",
    "\n}\n"
  )
  main_fmt <- str_flatten(main_fmt, collapse = "\n")
  code_with_main <- sprintf(
    main_fmt,
    code_without_main
  )
  return(code_with_main)
}

increase_indentation__ <- function(code_without_main) {
  lines <- unlist(str_split(code_without_main, "\n"))
  for (i in seq_along(lines)) {
    lines[i] <- str_flatten(c("    ", lines[i]))
  }

  return(str_c(lines, collapse = "\n", sep = ""))
}


#' Get `auto_main` option.
#'
#' This function is used to get the value of the `auto_main` code block option.
#' The `auto_main` code block option is used to specify if the Zig code written
#' in the current code block should (or should not) be encapsulated inside a
#' `main()` function, before it get's sent to the Zig compiler to be compiled.
#'
#' If the user did not configured/setted this
#' specific option in the current code block that is being analyzed,
#' then, this function will automatically return `FALSE` by default.
#' However, if the user did setted this option in the current code block,
#' then, the function returns the value that the user provided in this option.
#'
#' @param options The list of code block options.
#'
#' @return A boolean value, indicating if the Zig code in the current code block
#'     should (or should not) be encapsulated inside a `main()` function.
get_auto_main <- function(options) {
  if (length(options$auto_main) == 0 || is.null(options$auto_main)) {
    return(FALSE)
  }

  return(options$auto_main)
}



#' Get `build_type` option.
#'
#' This function is used to get the value of the `build_type` code block option.
#' The `build_type` code block option is used to specify which command from the
#' Zig compiler should be used to compile the Zig code that is written in the current
#' code block.
#'
#' Possible values for this option are:
#' - `"run"`: use `zig run` to compile and execute the Zig code.
#' - `"lib"`: use `zig build-lib` to compile the Zig code.
#' - `"test"`: use `zig test` to compile and execute the Zig code.
#' - `"ast"`: use `zig ast-check` to check for syntax errors.
#'
#' If the user did not configured/setted this
#' specific option in the current code block that is being analyzed,
#' then, this function will automatically return `"run"` by default.
#' However, if the user did setted this option in the current code block,
#' then, the function returns the value that the user provided in this option.
#'
#' @param options The list of code block options.
#'
#' @return A string value, indicating which command from the Zig compiler should be
#'     used to compile the Zig code that is written in the current code block.
get_build_type <- function(options) {
  if (length(options$build_type) == 0 || is.null(options$build_type)) {
    return("run")
  }

  return(options$build_type)
}



#' Zig knitr engine.
#'
#' This function is the engine responsible for processing, compiling and executing
#' every single Zig code written in a code block across the book.
#'
#' @param options The list of code block options.
#'
#' @return The knitr engine output, which contains the output of the Zig code
#'     (i.e. the output of the executable compiled from this Zig code).
zig_engine <- function(options) {
  code <- str_flatten(options$code, "\n")
  if (!options$eval) {
    return(knitr::engine_output(options, code, NULL))
  }

  build_type <- get_build_type(options)
  if (build_type == "test") {
    output <- zig_test(code, options)
  } else if (build_type == "lib") {
    output <- zig_build_lib(code, options)
  } else if (build_type == "run") {
    output <- zig_run(code, options)
  } else if (build_type == "ast") {
    zig_ast_check(code, options)
    output <- NULL
  } else {
    msg <- sprintf("[ERROR]: Unsuported build type %s!", build_type)
    stop(msg)
  }

  output <- format_output(output, options)
  return(knitr::engine_output(options, code, output))
}



#' Write a Zig file.
#'
#' This function is used to save/write some Zig source code
#' into a Zig file (`*.zig`). More specifically, the input Zig source code
#' is written into a temporary file into the operating system.
#' In Windows for example, a temporary file is usually a file written
#' inside the `AppData` system folder.
#'
#' When you restart the system all temporary files are automatically
#' erased. This is why they are "temporary".
#'
#' @param zig_code The Zig source code to be written into the Zig file.
#'
#' @return A string with the full path to the temporary Zig file.
write_zig <- function(zig_code) {
  temp_file <- tempfile(fileext = ".zig")
  readr::write_file(zig_code, temp_file)
  return(temp_file)
}



#' Compile and execute Zig code.
#'
#' This function is used only if the code block option `build_type` is equal to `"run"`.
#' This function receives some Zig source code as input, and then, it writes this source code to
#' a Zig file (`*.zig`), then, it compiles and executes this Zig file using the
#' `zig run` command from the Zig compiler.
#'
#' @param zig_code The zig source code to be compiled.
#' @param options The list of code block options.
#'
#' @return The knitr engine output, which contains the output of the Zig code
#'     (i.e. the output of the executable compiled from this Zig code).
zig_run <- function(zig_code, options) {
  if (get_auto_main(options)) {
    zig_code <- generate_main(zig_code)
  }

  file_path <- write_zig(zig_code)
  output <- zig_compile_file(file_path, "run")
  fs::file_delete(file_path)
  return(output)
}


#' Compile Zig code as a static library.
#'
#' This function is used only if the code block option `build_type` is equal to `"lib"`.
#' This function receives some Zig source code as input, and then, it writes this source code to
#' a Zig file (`*.zig`), then, it compiles this Zig file using the
#' `zig build-lib` command from the Zig compiler.
#'
#' @param zig_code The zig source code to be compiled.
#' @param options The list of code block options.
#'
#' @return The knitr engine output. This engine output usually does not contain any sort
#'     of output from the input Zig code per se, because the Zig code was compiled as a static library.
#'     To really execute the code from this static library, we would need to create an executable
#'     that links to this static library.
zig_build_lib <- function(zig_code, options) {
  if (get_auto_main(options)) {
    zig_code <- generate_main(zig_code)
  }

  file_path <- write_zig(zig_code)
  output <- zig_compile_file(file_path, "build-lib")
  clean_lib_files()
  fs::file_delete(file_path)
  return(output)
}


#' Compile Zig code as a tests executable.
#'
#' This function is used only if the code block option `build_type` is equal to `"test"`.
#' This function receives some Zig source code as input, and then, it writes this source code to
#' a Zig file (`*.zig`), then, it compiles this Zig file using the
#' `zig test` command from the Zig compiler.
#'
#' @param zig_code The zig source code to be compiled.
#' @param options The list of code block options.
#'
#' @return The knitr engine output, which contains the output of the Zig code
#'     (i.e. the output of the executable compiled from this Zig code).
zig_test <- function(zig_code, options) {
  file_path <- write_zig(zig_code)
  output <- zig_compile_file(file_path, "test")
  fs::file_delete(file_path)
  return(output)
}



#' Check syntax of Zig code with ast-check.
#'
#' This function is normally used only on code blocks that are not evaluated
#' (i.e. `eval: false`). This function receives some Zig source code as input,
#' and then, it writes this source code to a Zig file (`*.zig`), then, it checks
#' if the syntax of the source code in this file is correct, by using the
#' `zig ast-check` command
#'
#' @param zig_code The zig source code to be checked.
#' @param options The list of code block options.
#'
#' @return The knitr engine output, which contains the output of the Zig code
#'     (i.e. the output of the executable compiled from this Zig code).
zig_ast_check <- function(zig_code, options) {
  if (get_auto_main(options)) {
    zig_code <- generate_main(zig_code)
  }

  file_path <- write_zig(zig_code)
  output <- zig_compile_file(file_path, "ast-check")
  fs::file_delete(file_path)
  return(output)
}



#' Compile a Zig file with the Zig compiler.
#'
#' This function is used to compile a Zig file, using the Zig compiler.
#' In other words, this function takes a path to a Zig file (`*.zig`) as input,
#' then, it runs a command from the Zig compiler to compile this Zig file.
#'
#' If this command from the Zig compiler runs succesfully, the function takes
#' the result of this operation, and returns it to the caller. But, if this
#' command does not run succesfully, then, the function stops the R process
#' with an error report, that describes the Zig code that the Zig compiler
#' attempted to compile, and also, the error message that was returned by the
#' Zig compiler.
#'
#' @param file_path The full path to the Zig file to be compiled.
#' @param zig_command The command from the Zig compiler to be used to
#'     compile the Zig code in the current code block.
#'
#' @return A string with the output of the Zig compiler operation.
zig_compile_file <- function(file_path, zig_command) {
  zig_cmd_path <- getOption("zig_exe_path")
  output <- system2(
    zig_cmd_path,
    c(zig_command, shQuote(file_path)),
    stdout = TRUE,
    stderr = TRUE
  )
  if (get_exit_status_code(output) != 0L) {
    generate_error_report(file_path, output)
  }

  return(output)
}



#' Get Zig compiler command.
#'
#' This function gets a build type as input, and returns the
#' Zig compiler command that corresponds to this particular build type.
#'
#' @param build_type The build type, see `get_build_type()`.
#'
#' @return A string with the Zig compiler command.
get_zig_compiler_command <- function(build_type) {
  if (build_type == "lib") {
    return("build-lib")
  }

  return(build_type)
}



#' Generate an error report.
#'
#' This function is used to generate a report with detailed information about
#' a compilation error that was issued by the Zig compiler.
#'
#' @param file_path The full path to the Zig file to be compiled.
#' @param output The output from the Zig compiler process.
generate_error_report <- function(file_path, output) {
  zig_code <- readr::read_file(file_path)
  msg <- c(
    "[ERROR]: An error was issued by the Zig compiler while trying ",
    "to compile the Zig code block at ",
    current_input(), ":", opts_current$get("label"), ".\n",
    "[ERROR]: The Zig compiler returned the following error message: ",
    output, "\n",
    "[ERROR] The error was generated while trying to compile the ",
    "following snippet of Zig code:\n"
  )
  msg <- str_flatten(msg)

  code_report <- c(
    "====== CODE COMPILED ============",
    zig_code,
    "=================================\n",
    "[ERROR]: The output below is the backtrace from the R process:\n"
  )
  code_report <- str_c(
    code_report,
    collapse = "\n"
  )

  code_report <- str_c(msg, code_report, collapse = "")
  stop(code_report)
}



#' Delete library files.
#'
#' If the Zig code was compiled as a library, using the
#' `zig build-lib` command, then, some library files were generated
#' during the compilation process, like library (`*.a`) and object files (`*.o`).
#'
#' However, these types of files are useless to the book context, and to the
#' job we are performing here. Therefore, these files are automatically erased/deleted
#' by the Zig knitr engine after the Zig code got compiled by the Zig compiler.
clean_lib_files <- function() {
  obj_files <- fs::dir_ls(glob = "*.a")
  lib_files <- fs::dir_ls(glob = "*.o")
  files <- c(obj_files, lib_files)
  fs::file_delete(files)
}


#' Get exit status code from the Zig compiler process.
#'
#' This function is used to get the exit status code that was
#' issued by the Zig compiler process. This exit status code
#' is a "bash exit status code" like from any other bash command.
#'
#' Normally, an exit status code equal to zero means "success",
#' while status codes different than zero means some sort of "error".
get_exit_status_code <- function(output) {
  status <- attr(output, "status")
  if (length(status) == 0L || is.null(status)) {
    return(0L)
  }

  return(status)
}



# Registering the Zig engine in the current `knitr` process.
knitr::knit_engines$set(zig = zig_engine)
