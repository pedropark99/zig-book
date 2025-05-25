# Introduction to Zig

<a href=""><img src="Cover/cover-artv3.png" width="250" height="366" class="cover" align="right"/></a>

Hey! This is the official repository for the book "Introduction to Zig: a project-based book", written by Pedro Duarte Faria.
To know more about the book, checkout the [About this book](#about-this-book) section below.
You can read the current version of the book in your web browser: <https://pedropark99.github.io/zig-book/>.

This book is crafted using a modern, reproducible publishing stack, leveraging the power of:

<p align="center">
  <a href="https://ziglang.org/" target="_blank"><img src="https://img.shields.io/badge/Zig-%23F7A41D.svg?style=flat&logo=zig&logoColor=black" alt="Zig"></a>
  &nbsp;
  <a href="https://quarto.org/" target="_blank"><img src="https://img.shields.io/badge/Quarto-%234D5891.svg?style=flat&logo=quarto&logoColor=white" alt="Quarto"></a>
  &nbsp;
  <a href="https://www.r-project.org/" target="_blank"><img src="https://img.shields.io/badge/R-%23276DC3.svg?style=flat&logo=r&logoColor=white" alt="R"></a>
  &nbsp;
  <a href="https://yihui.org/knitr/" target="_blank"><img src="https://img.shields.io/badge/Knitr-%23007ACC.svg?style=flat&logoColor=white&labelColor=555555&logo=data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij48cGF0aCBmaWxsPSJ3aGl0ZSIgZD0iTTE4IDZjLTMuMzEgMC02IDIuNjktNiA2czIuNjkgNiA2IDZoMy4yOGwtNC4yNC01LjA5TDIxLjM0IDZIMTh6TTMgMTJoMy4yOEwzIDE3LjA5VjE0Yy4wMS0xLjA5LS4zMy0yLjE0LS45OS0zSDN2MW0zLTZjMy4zMSAwIDYgMi42OSA2IDZzLTIuNjkgNi02IDZIMi43Mkw2LjU3IDZjMCAwIDAtMyAwLTN6Ii8+PC9zdmc+" alt="Knitr"></a>
  &nbsp;
  <a href="https://pandoc.org/" target="_blank"><img src="https://img.shields.io/badge/Pandoc-%2323B5AF.svg?style=flat&logoColor=white&labelColor=555555&logo=data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij48cGF0aCBmaWxsPSJ3aGl0ZSIgZD0iTTEzLjEgNC42bDQuNSA5LjJoLTNsLTEuNS0zLjFoLTNsLTEuNSA0LjFoLTNMMTAuMSA0LjZoM1ptLTYuMyAwaDMuM2wzLjYgNy41aC0zLjNsLTMuNi03LjV6TTkgMTUuNGgxMy4ybC0yLjEgNC4yaC05bC0yLjEtNC4yWiIvPjwvc3ZnPg==" alt="Pandoc"></a>
  &nbsp;
  <a href="https://nixos.org/nix/" target="_blank"><img src="https://img.shields.io/badge/Nix-%235277C3.svg?style=flat&logo=nixos&logoColor=white" alt="Nix"></a>
</p>

The core book content is built using the [Quarto](https://quarto.org) publishing system
in conjunction with a little bit of R code (`zig_engine.R`), that is responsible for calling
the Zig compiler to compile and run the Zig code examples.


## Support the project!

If you like this project, and you want to support it, you can buy a PDF, eBook or a physical copy
of the book, either at Amazon, or at Leanpub:

- Amazon: <https://www.amazon.com/dp/B0DJYMDRLP>
- Leanpub: <https://leanpub.com/introductiontozigaproject-basedbook>

### Sending donations directly

You can also donate some amount directly to the author of the project via:

- PayPal Donation.
- Revolut.

These are good ways to support directly the author of the project, which helps to foster
more contents like this, and it makes possible for the author to keep writing helpful tools and
materials for the community.



### PayPal

[![PayPal](https://img.shields.io/badge/PayPal-003087?logo=paypal&logoColor=fff)](https://www.paypal.com/donate/?business=D58J5LFEERC3N&no_recurring=0&item_name=These+donations+make+it+possible+for+me+to+continue+writing+new+and+useful+content+for+our+community%F0%9F%98%89+Thank+you%21%E2%9D%A4%EF%B8%8F%F0%9F%A5%B3&currency_code=USD)


### Revolut

You can send money via Swift Payment with the following bank and Swift details:

```
Recipient: Pedro Duarte Faria
BIC/SWIFT Code: REVOSGS2
Account number: 6124512226
Name and address of the bank: Revolut Technologies Singapore Pte. Ltd, 6 Battery Road, Floor 6-01, 049909, Singapore, Singapore
Corresponding BIC: CHASGB2L
```

If you do have a Revolut account, you can scan the following QR code:

<http://revolut.me/pedroduartefaria>




## About this book

This is an open (i.e., open-source), technical and introductory book for the [Zig programming language](https://ziglang.org/),
which is a new general purpose, and low-level programming language for building optimal and robust software.

Official repository of the book: <https://github.com/pedropark99/zig-book>.

This book is designed for both beginners and experienced developers. It explores the exciting world of Zig through small
and simple projects (in a similar style to the famous "Python Crash Course" book from Eric Matthes).
Some of these projects are: a Base64 encoder/decoder, a HTTP Server and an image filter.

As you work through the book, you will learn:

- The syntax of the language, and how it compares to C, C++ and Rust.
- Data structures, memory allocators, filesystem and I/O.
- Optionals as a new paradigm to handle nullability.
- How to test and debug a Zig application.
- Errors as values, and how to handle them.
- How to build C and Zig code with the build system that is embedded into the language.
- Zig interoperability with C.
- Parallelism with threads and SIMD.
- And more.



## How to build the book

First of all, you need to care about the dependencies of the project. This book is built using the following pieces of software:

1. The [Zig compiler](https://ziglang.org/download/), which is responsible for compiling most of the code examples exposed in the book.
2. The [R programming language](https://cran.r-project.org/), which provides some useful tools, specially `knitr` and `rmarkdown`, which are responsible for collecting the code examples exposed across the book, and sending them to the zig compiler to be compiled and executed, and also, collecting the results back to include them in the book.
3. The [Quarto publishing system](https://quarto.org/docs/get-started/), which is responsible for compiling the book, creating internal links, references, a chapters structure, the HTML content of the book. It does all of that by using the amazing [Pandoc](https://pandoc.org/) with some extra features implemented by Quarto.

So, installing these three pieces of software (Zig, R, Quarto) in your current machine is the first step to build the book.
There are two strategies that you can take here:

1. You can install these three pieces of software manually (you can find instructions on how to install each piece by clicking in the above hyperlinks).
2. Or, you can use the Nix Flake declared in the `flake.nix` file to create a reproducible environment that already comes with these pieces installed.


### Building the book manually

If you decide to install the dependencies of the book manually, then, follow the "install instructions" that are present in the above hyperlinks,
and, after you installed the three pieces (Zig, R and Quarto), follow the next instructions specified here.

#### Install R packages

After you installed the three pieces of software listed above, you should run the `dependencies.R` R script, to install
some R packages that are used across the book. Just run the command below in your terminal, and you should be fine.

OBS: If you are on Linux or MacOS, this command will probably take some time to run, because every single dependency gets built from source.
In Windows, this usually doesn't take that long because pre-built binaries are usually available.

```bash
Rscript dependencies.R
```

#### Render the book

If you installed Quarto correctly in your computer
, you should be able to build the book by simply executing
the following command in the terminal.

```bash
quarto render
```



### Building the book with Nix Flake

If you choose to use the Nix Flake to create an environment that comes with the necessary dependencies, then, you need
to open a terminal, and run the `nix develop` command on the root of the project:

```bash
nix develop
```

With this command, Onix will download the necessary packages and libraries, and then create a new bash session that points
to a new environment that contains these packages and libraries in it. Then, inside this new bash session that is created
by Nix, all you need to do is to run the `quarto render` command, which will kickstart Quarto, and make it build the book
for you:

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
