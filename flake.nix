{
  description = "Zig Development Environment";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    zig-overlay.url = "github:mitchellh/zig-overlay";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    ...
  } @ inputs:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
      zigpkgs = inputs.zig-overlay.packages.${system};
    in {
      devShell = pkgs.mkShell {
        packages =
          (with pkgs; [
            zigpkgs.master
            wasmtime
            R
            quarto
          ])
          ++ (with pkgs.rPackages; [
            readr
            knitr
            rmarkdown
            stringr
            gt
            tibble
          ]);
        buildInputs = with pkgs; [
          openssl
        ];
        shellHook = ''
          zig version
        '';
      };
    });
}
