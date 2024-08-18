{
  description = "Terraform projects";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        goVimPlugin = pkgs.fetchFromGitHub {
          owner = "ray-x";
          repo = "go.nvim";
          rev = "master";
          sha256 = "sha256-Dxi98g9ORQdtxjzca6KnAa5WSDfbYjFT3yc0sFUJyHM=";
        };
        guihuaPlugin = pkgs.fetchFromGitHub {
          owner = "ray-x";
          repo = "guihua.lua";
          rev = "master";
          sha256 = "sha256-2eXvIqPJP76kJwnLtgTLCsti0R0Kzpp1w7ov2xZc2D0=";
        };
        # Fetch the Lua configuration file directly from GitHub
        nvimConfig = pkgs.fetchFromGitHub {
          owner = "mononosis";
          repo = "nvim-go-config";
          rev = "main"; # Use the appropriate commit or tag
          sha256 = "sha256-Gy8aFfh5DtMt9wAvFCuFrq7mpKHgdCTAJ4oTz+PwobU="; # Replace with the correct hash
        };
      in
      {
        defaultPackage = pkgs.buildGoModule rec {
          pname = "your-application-name";
          version = "0.1.0";

          src = ./.; # Assuming your Go code is in the root of this flake

          # Replace with the actual hash you get from the 'go mod tidy' command
          vendorSha256 = "sha256-2eXvIqPJP76kJwnLtgTLCsti0R0Kzpp1w7ov2xZc2D0=";

          buildInputs = with pkgs; [ gtk3 webkitgtk ];

          # Setup CGO to find GTK and webkitgtk
          preBuild = ''
            export CGO_CFLAGS="-I${pkgs.gtk3.dev}/include/gtk-3.0 -I${pkgs.webkitgtk.dev}/include/webkitgtk-4.0"
            export CGO_LDFLAGS="-L${pkgs.gtk3}/lib -L${pkgs.webkitgtk}/lib"
            export PKG_CONFIG_PATH="${pkgs.gtk3.dev}/lib/pkgconfig:${pkgs.webkitgtk.dev}/lib/pkgconfig"
          '';
        };
        devShell = pkgs.mkShell {
          buildInputs = [
            pkgs.gccgo13
            pkgs.gopls
            pkgs.gofumpt
            pkgs.golines
            pkgs.gtk3
            pkgs.webkitgtk
          ];
          shellHook = ''
            #export GOPATH="${pkgs.gccgo13}/bin"
            export PATH=$PATH:$GOPATH
            export NVIM_PLUGIN_PATHS="${guihuaPlugin}:${goVimPlugin}"
            #export PROJECT_NVIM_CONFIG=${nvimConfig}
            #export NVIM_PLUGIN_PATHS=""
            [[ ! -z $NIX_DEV_MODE ]] \
                && echo "We are in dev mode" \
                && export PROJECT_NVIM_CONFIG=$HOME/Lab/LuaLab/${nvimConfig.repo} \
                || export PROJECT_NVIM_CONFIG=${nvimConfig}

          '';
          #'';
        };
      });
}
