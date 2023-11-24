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
          sha256 = "sha256-M2X3zPdH5Em+BiBo9b+U8icexXgCo5K6WdUsUn8X/yg=";
        };
        guihuaPlugin = pkgs.fetchFromGitHub {
          owner = "ray-x";
          repo = "guihua.lua";
          rev = "master";
          sha256 = "sha256-2eXvIqPJP76kJwnLtgTLCsti0R0Kzpp1w7ov2xZc2D0=";
        };
        # Fetch the Lua configuration file directly from GitHub
        goNvimConfig = pkgs.fetchFromGitHub {
          owner = "mononosis";
          repo = "nvim-go-config";
          rev = "main"; # Use the appropriate commit or tag
          sha256 = "sha256-Gy8aFfh5DtMt9wAvFCuFrq7mpKHgdCTAJ4oTz+PwobU="; # Replace with the correct hash
        };
      in
      {
        devShell = pkgs.mkShell {
          buildInputs = [
            pkgs.gccgo13
            pkgs.gopls
            pkgs.gofumpt
            pkgs.golines
          ];
          shellHook = ''
            export GOPATH="${pkgs.gccgo13}/bin"
            export PATH=$PATH:$GOPATH
            export NVIM_PLUGIN_PATHS="${guihuaPlugin}:${goVimPlugin}"
            export PROJECT_NVIM_CONFIG=${goNvimConfig}
          '';
        };
      });
}
