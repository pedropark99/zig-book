{
  description = "Dev shell for zig-book (HTML only) with Quarto, R, and user's Zig";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    flake-utils.url = "github:numtide/flake-utils";
    zig.url = "github:mitchellh/zig-overlay";
  };

  outputs = { self, nixpkgs, flake-utils, zig, ... } @ inputs:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        # R packages needed by the book (from dependencies.R)
        # and common ones for Quarto R execution.
        rPkgsList = with pkgs.rPackages; [
          quarto   # The R package 'quarto'
          bslib
          downlit
          xml2     # Needs libxml2
          gistr    # Might need curl
          knitr    # Usually needed for R chunks in Quarto
          rmarkdown # Often a dependency for knitr/Quarto R features
          # Add other R packages if the book's R code uses more:
          # e.g., readr, stringr, dplyr, fs, jsonlite, hms
          readr
          stringr
          dplyr
          fs
          jsonlite
          hms
        ];

        # R environment with the specified packages
        R_env = pkgs.rWrapper.override {
          packages = rPkgsList;
        };

        # Native libraries that might be runtime dependencies for R packages
        # or tools used by Quarto (excluding PDF-specific ones).
        nativeDeps = with pkgs; [
          libxml2 # For rPackages.xml2
          curl    # For rPackages.gistr or other http functionality
        ];

        # REMOVED: localeDefinitions = pkgs.glibcLocalesUtf8;
        # C.UTF-8 is generally available without needing full glibcLocales.

      in {
        devShells.default = pkgs.mkShell {
          # Packages made available in the shell environment
          buildInputs = [
            R_env       # Provides R and Rscript
            pkgs.quarto # The Quarto CLI
            zig.packages.${system}.master-2025-11-22
            # REMOVED: localeDefinitions
          ] ++ nativeDeps;

          shellHook = ''
            # QUARTO_R: Point Quarto to the Rscript from our Nix-provided R environment
            unset QUARTO_R # Clear any pre-existing value
            export QUARTO_R=$(which Rscript)

            # --- GENERAL LOCALE SETUP ---
            # Set a universally available, UTF-8 compatible locale.
            # This prevents locale errors and ensures basic Unicode handling
            # without imposing a specific language or requiring extra locale packages.
            export LANG="C.UTF-8"
            export LC_ALL="C.UTF-8"


            echo "--- Nix Shell Environment (HTML Only) ---"
            echo "Locale set to C.UTF-8 for broad compatibility." # Added this line for clarity
            echo "Zig is assumed to be available via \$PATH: $(which zig || echo 'Not found zig in PATH')"
            echo "R environment configured."
            echo "  To check R's library paths: R -e '.libPaths()'"
            echo "  To list R packages: R -e 'installed.packages()[,1]'"
            echo "R environment is set to: $R_env"
            echo "Rscript is at: $(which Rscript || echo 'Not found Rscript')"
            echo "QUARTO_R set to: $QUARTO_R"
            # REMOVED: echo "LOCALE_ARCHIVE set to: $LOCALE_ARCHIVE"
            echo ""
            echo "To build HTML: quarto render"
            echo "-----------------------------------------"
          '';
        };
    });
}
