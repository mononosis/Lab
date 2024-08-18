{
  description = "Rust Development";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }@inputs:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        nvimProjectLab = pkgs.fetchFromGitHub {
          name = "nvim-rust-config";
          owner = "mononosis";
          repo = "nvim-rust-config";
          rev = "main"; 
          sha256 = "sha256-8tQaFkTtrc/yRKbx1GctEHt5Aie0oS72T4EZODS46qE="; 
        };
      in
      {
        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [
            #cargo
            pkg-config
            glib
            gtk3
            webkitgtk_4_1
            webkitgtk
            gtk3
            gtk-layer-shell
            rustup
            libsoup
            # Add any additional Python packages or Rust tools here, e.g., python3Packages.numpy for Python, or cargo for Rust
          ];
          #PKG_CONFIG_PATH = "${pkgs.webkitgtk_4_1.dev}/lib/pkgconfig:${pkgs.libsoup.dev}/lib/pkgconfig:${pkgs.gtk3.dev}/lib/pkgconfig:${pkgs.glib.dev}/lib/pkgconfig";
          #PKG_CONFIG_PATH_FOR_TARGET = "${pkgs.webkitgtk_4_1.dev}/lib/pkgconfig:${pkgs.libsoup.dev}/lib/pkgconfig:${pkgs.gtk3.dev}/lib/pkgconfig:${pkgs.glib.dev}/lib/pkgconfig";
          shellHook = ''
            #export NVIM_PLUGIN_PATHS=""
            [[ ! -z $NIX_DEV_MODE ]] \
                && echo "We are in dev mode" \
                && export PROJECT_NVIM_CONFIG=$HOME/Lab/LuaLab/${nvimProjectLab.repo} \
                || export PROJECT_NVIM_CONFIG=
          '';

        };
      });
}

