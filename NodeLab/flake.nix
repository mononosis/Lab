{
  description = "Javascript and its ecosystem projects";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        nvimProjectLab = pkgs.fetchFromGitHub {
          name = "nvim-groovy-config";
          owner = "mononosis";
          repo = "nvim-groovy-config";
          rev = "main"; 
          sha256 = "sha256-XtrlLOvSP8Kt6JblA1JaV6ngDd8l1vwKWC55ESHu0FM="; 
        };
      in
      {
        devShell = pkgs.mkShell {
          buildInputs = [
            pkgs.nodejs_18
            pkgs.nodePackages.typescript-language-server
            pkgs.nodePackages.typescript
            pkgs.nodePackages.pnpm
            pkgs.yarn
            pkgs.openssl
          ];
          shellHook = ''
            npm set prefix ~/.npm-global
            export PATH=$PATH:~/.npm-global/bin
            export NVIM_PLUGIN_PATHS=""
            [[ ! -z $NIX_DEV_MODE ]] \
                && echo "We are in dev mode" \
                && export PROJECT_NVIM_CONFIG=$HOME/Lab/LuaLab/${nvimProjectLab.repo} \
                || export PROJECT_NVIM_CONFIG=${nvimProjectLab}
          '';
        };
      });
}
