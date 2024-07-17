# Introduction to Zig

<a href=""><img src="Cover/cover-artv2.1.png" width="250" height="366" class="cover" align="right"/></a>

Hey! This is the official repository for the book "Introduction to Zig: a project-based book", written by Pedro Duarte Faria.
This book is still under active development, and, as a result, it's content might change drastically in the near future.

The book is built using the publishing system [Quarto](https://quarto.org)
in conjunction with a little bit of R code (`zig_engine.R`), that is responsible for calling
the Zig compiler to compile and run the Zig code examples.


## How to build the book

This book depends on the three main pieces of software:

1. The [Zig compiler](https://ziglang.org/download/), which is responsible for compiling most of the code examples exposed in the book.
2. The [R programming language](https://cran.r-project.org/), which provides some useful tools to collect the code examples exposed across the book, and send them to the zig compiler to be compiled and executed, and also, collect the results back to include them in the book.
3. The [Quarto publishing system](https://quarto.org), which provides the useful tools to compile the book, creating internal links, references, a chapters structure, the HTML content of the book, etc.

So, you first need to install these three pieces of software in your current machine.
After that, you should run the `dependencies.R` R script, to install
some R packages that are used across the book. Just run
the command below in your terminal, and you should be fine.

```bash
Rscript dependencies.R
```

After that, you should be able to build the book by simply executing
the following command in the terminal.

```bash
quarto render
```


## License

Copyright © 2024 Pedro Duarte Faria. This book is licensed by the CC-BY 4.0 Creative Commons Attribution 4.0 International Public License.

<a rel="license" href="http://creativecommons.org/licenses/by/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by/4.0/88x31.png" /></a>


