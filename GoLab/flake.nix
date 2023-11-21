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
          sha256 = "sha256-2eXvIqPJP76kJwnLtgTLCsti0R0Kzpp1w7ov2xZc2D0=";
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
          sha256 = "sha256-AmQiaRqiQ4+TxO9XY3Ks/TTszqtN1kz0K6zubq0SN30="; # Replace with the correct hash
        };
      in
      {
        devShell = pkgs.mkShell {
          buildInputs = [
            pkgs.gccgo13
          ];
          shellHook = ''
            export NVIM_PLUGIN_PATHS="${guihuaPlugin}:${goVimPlugin}"
            export PROJECT_NVIM_CONFIG=${goNvimConfig}
          '';
        };
      });
}
