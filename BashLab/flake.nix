{
  description = "Bash projects";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        nvimBashLab = pkgs.fetchFromGitHub {
          name = "nvim-bash-config";
          owner = "mononosis";
          repo = "nvim-bash-config";
          rev = "main";
          sha256 = "sha256-ImT2co33efuRXUaLGh72Oh8oaLWv1ghm8512wT7NTXI=";
        };
      in
      {
        devShell = pkgs.mkShell {
          buildInputs = [
            #pkgs.nodejs_20
            pkgs.nodePackages.bash-language-server
            pkgs.shfmt
            pkgs.shellcheck
            #pkgs.awk-language-server
          ];
          shellHook = ''
            export NVIM_PLUGIN_PATHS=""
            [[ ! -z $NIX_DEV_MODE ]] \
                && echo "We are in dev mode" \
                && export PROJECT_NVIM_CONFIG=$HOME/Lab/LuaLab/${nvimBashLab.repo} \
                && export XDG_CONFIG_HOME=/home/nixos/.config/home-manager \
                || export PROJECT_NVIM_CONFIG=${nvimBashLab}
          '';
        };
      });
}
