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
        nvimHtmlLab = pkgs.fetchFromGitHub {
          name = "nvim-html-config";
          owner = "mononosis";
          repo = "nvim-html-config";
          rev = "main";
          sha256 = "";
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
                && export PROJECT_NVIM_CONFIG=$HOME/Lab/LuaLab/${nvimHtmlLab.repo} \
                && export XDG_CONFIG_HOME=/home/nixos/.config/home-manager \
                || export PROJECT_NVIM_CONFIG=${nvimHtmlLab}
          '';
        };
      });
}
