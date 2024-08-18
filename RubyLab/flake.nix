{
  description = "Groovy projects";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        nvimProjectLab = pkgs.fetchFromGitHub {
          name = "nvim-ruby-config";
          owner = "mononosis";
          repo = "nvim-ruby-config";
          rev = "main"; 
          sha256 = "sha256-UXsXx420lMcRT39ggPMUs6vkSzRFgbVNxu54eZQrWmA="; 
        };
      in
      {
        devShell = pkgs.mkShell {
          buildInputs = [
            pkgs.bundler
            pkgs.ruby

            pkgs.rubyPackages.solargraph
            pkgs.rubyPackages.rubocop
          ];
          shellHook = ''
            export NVIM_PLUGIN_PATHS=""
            [[ ! -z $NIX_DEV_MODE ]] \
                && echo "We are in dev mode" \
                && export PROJECT_NVIM_CONFIG=$HOME/Lab/LuaLab/${nvimProjectLab.repo} \
                || export PROJECT_NVIM_CONFIG=${nvimProjectLab}
          '';
        };
      });
}
