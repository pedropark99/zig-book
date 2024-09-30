# Introduction to Zig

<a href=""><img src="Cover/cover-artv2.1.png" width="250" height="366" class="cover" align="right"/></a>

Hey! This is the official repository for the book "Introduction to Zig: a project-based book", written by Pedro Duarte Faria.
This book is still under active development, and, as a result, it's content might change drastically in the near future.
You can read the current version of the book in your web browser: <https://pedropark99.github.io/zig-book/>.

The book is built using the publishing system [Quarto](https://quarto.org)
in conjunction with a little bit of R code (`zig_engine.R`), that is responsible for calling
the Zig compiler to compile and run the Zig code examples.


## How to build the book

This book depends on the three main pieces of software:

1. The [Zig compiler](https://ziglang.org/download/), which is responsible for compiling most of the code examples exposed in the book.
2. The [R programming language](https://cran.r-project.org/), which provides some useful tools to collect the code examples exposed across the book, and send them to the zig compiler to be compiled and executed, and also, collect the results back to include them in the book.
3. The [Quarto publishing system](https://quarto.org/docs/get-started/), which provides the useful tools to compile the book, creating internal links, references, a chapters structure, the HTML content of the book, etc.

So, you first need to install these three pieces of software in your current machine.
You can find instructions on how to install these pieces of software by clicking in the above hyperlinks.

### Install R packages

After you installed the three pieces of software listed above, you should run the `dependencies.R` R script, to install
some R packages that are used across the book. Just run the command below in your terminal, and you should be fine.

OBS: If you are on Linux or MacOS, this command will probably take some time to run, because every single dependency get's built from source.
In Windows, this usually doesn't take that long because pre-built binaries are usually available.

```bash
Rscript dependencies.R
```

### Render the book

If you installed Quarto correctly in your computer
, you should be able to build the book by simply executing
the following command in the terminal.

```bash
quarto render
```

### How the Zig compiler is found

Some R code (`zig_engine.R`) is used to collect the Zig code examples
found across the book, and send them to the Zig compiler, so that they
can be compiled and executed.

But in order to do that, this R code needs to find the Zig compiler installed
in your machine. This search process is done in two stages.
First, it uses the [`Sys.which()` function](https://www.rdocumentation.org/packages/base/versions/3.6.2/topics/Sys.which)
to find the path to the Zig compiler in your computer, which is just a R interface to the `which` command line tool.

This is a fast and easy approach, but, it doesn't work in all situations, specially if
your Zig compiler is not installed in a "standard location" in your computer. That is
why, a second strategy is applied, which is to search through the PATH environment variable.

It gets the value of your PATH environment variable, and iterates through the directories listed
in this variable, trying to find the Zig compiler in one of them. This approach is much
slower than the first one, but is more garanteed to work.



## License

Copyright © 2024 Pedro Duarte Faria. This book is licensed by the CC-BY 4.0 Creative Commons Attribution 4.0 International Public License.

<a rel="license" href="http://creativecommons.org/licenses/by/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by/4.0/88x31.png" /></a>


