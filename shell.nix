{
  pkgs ?
    import <nixpkgs> {
    },
}: let
  lib = import <nixpkgs/lib>;
in
  pkgs.mkShellNoCC {
    packages =
      (with pkgs; [
        librsvg
        texliveFull
        R
        quarto
        zig
      ])
      ++ (with pkgs.rPackages; [
        readr
        rsvg
        knitr
        rmarkdown
        stringr
        gt
        tibble
      ]);
    shellHook = ''

    '';
  }
