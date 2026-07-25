{
  description = "Development environment for building the Zig book";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    flake-utils.url = "github:numtide/flake-utils";

    zig = {
      url = "github:mitchellh/zig-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      flake-utils,
      zig,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        r = pkgs.rWrapper.override {
          packages = with pkgs.rPackages; [
            fs
            knitr
            readr
            rmarkdown
            stringr
          ];
        };

        quartoVersion = "1.9.37";
        quartoSources = {
          aarch64-darwin = {
            platform = "macos";
            hash = "sha256-IX9WEFh0s4WKQlAdhMFdVaiFND2j9oUEYEbRtkWkH4Y=";
          };
          aarch64-linux = {
            platform = "linux-arm64";
            hash = "sha256-uz+PCIePXZF6JNB25e84uKgcLW/PQuSpAl3HdKCB7kQ=";
          };
          x86_64-darwin = {
            platform = "macos";
            hash = "sha256-IX9WEFh0s4WKQlAdhMFdVaiFND2j9oUEYEbRtkWkH4Y=";
          };
          x86_64-linux = {
            platform = "linux-amd64";
            hash = "sha256-ePzZDpg+Pn2+Pw0ZIcwQJTweynuSwg3UvCo8G8oKmvU=";
          };
        };
        quartoSource = quartoSources.${system};

        # Use Quarto's bundled toolchain so its Pandoc, Deno, and other
        # dependencies always match the pinned Quarto release.
        quarto = pkgs.stdenvNoCC.mkDerivation {
          pname = "quarto";
          version = quartoVersion;

          src = pkgs.fetchurl {
            url = "https://github.com/quarto-dev/quarto-cli/releases/download/v${quartoVersion}/quarto-${quartoVersion}-${quartoSource.platform}.tar.gz";
            inherit (quartoSource) hash;
          };

          nativeBuildInputs = pkgs.lib.optionals pkgs.stdenv.hostPlatform.isLinux [
            pkgs.autoPatchelfHook
          ];
          buildInputs = pkgs.lib.optionals pkgs.stdenv.hostPlatform.isLinux [
            pkgs.openssl
            pkgs.stdenv.cc.cc.lib
            pkgs.zlib
          ];

          installPhase = ''
            runHook preInstall
            mkdir -p "$out"
            cp -R . "$out"
            runHook postInstall
          '';

          meta.mainProgram = "quarto";
        };
      in
      {
        devShells.default = pkgs.mkShell {
          packages = [
            quarto
            r
            zig.packages.${system}.master-2026-06-28
          ];

          LANG = "C.UTF-8";
          LC_ALL = "C.UTF-8";

          # Quarto expects the R executable, not Rscript.
          QUARTO_R = "${r}/bin/R";
        };
      }
    );
}
