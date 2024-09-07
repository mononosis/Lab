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
          sha256 = "sha256-3uNBF4c0a9sg7PxCfemoWSvu3Gk3HS2KzNCEd7sdNjQ=";
        };
        pluginWebTools = (pkgs.vimUtils.buildVimPlugin {
          name = "web-tools.nvim ";
          src = pkgs.fetchFromGitHub {
            owner = "ray-x";
            repo = "web-tools.nvim";
            rev = "master";
            sha256 = "sha256-m4ipLVYeul+WFzdy2IWkvTWcR04/XhMSllY8d9wwixg=";
          };
        });
        pluginTSAutotag = (pkgs.vimUtils.buildVimPlugin {
          name = "nvim-ts-autotag";
          src = pkgs.fetchFromGitHub {
            owner = "windwp";
            repo = "nvim-ts-autotag";
            rev = "main";
            sha256 = "sha256-V6uJG/tUL1lFc+yOKzL+AmdG3QqLllk/uYogxwxiaXQ=";
          };
        });
      in
      {
        devShell = pkgs.mkShell {
          buildInputs = [
            pkgs.nodejs_18
            #pkgs.vscode-langservers-extracted
            pkgs.nodePackages.typescript
            pkgs.nodePackages.typescript-language-server
            pkgs.yarn
            pkgs.yo
            #pkgs.nodePackages.vscode-html-languageserver-bin
            pkgs.nodePackages.browser-sync
            pkgs.hurl
            pkgs.nodePackages.webpack
            pkgs.nodePackages.pnpm
            pkgs.htmlhint
            pkgs.caddy
          ];
          shellHook = ''
            export NVIM_PLUGIN_PATHS="${pluginTSAutotag}:${pluginWebTools}"
            export PATH=$PATH:~/.npm-global/bin
            [[ ! -z $NIX_DEV_MODE ]] \
                && echo "We are in dev mode" \
                && export PROJECT_NVIM_CONFIG=$HOME/Lab/LuaLab/${nvimHtmlLab.repo} \
                && export XDG_CONFIG_HOME=/home/nixos/.config/home-manager \
                || export PROJECT_NVIM_CONFIG=${nvimHtmlLab}
          '';
        };
      });
}
