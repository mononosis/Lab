{
  description = "Python and its ecosystem projects";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        pythonNeovimLab = pkgs.fetchFromGitHub {
          owner = "mononosis";
          repo = "nvim-python-config";
          rev = "main"; # Use the appropriate commit or tag
          sha256 = "sha256-DypgPqX3wXaDlAX5bK9E6kYdP/G5WaMQOiOglskmxUA="; # Replace with the correct hash
        };
      in
      {
        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [
            #pkgs.conda
            hello
            python311
            nodePackages.pyright
            python311Packages.black
            python311Packages.flake8
            python311Packages.setuptools
            python311Packages.wheel
            python311Packages.dbus-python
            python311Packages.pygobject3
            python311Packages.pygobject-stubs
            python311Packages.transformers
            python311Packages.pytorch
            python311Packages.tensorboard
            python311Packages.pip
            python311Packages.matplotlib
            python311Packages.torchvision

          ];
          shellHook = ''
            export NVIM_PLUGIN_PATHS=""
            [[ ! -z $NIX_DEV_MODE ]] \
                && echo "We are in dev mode" \
                && export PROJECT_NVIM_CONFIG=$HOME/Lab/LuaLab/${pythonNeovimLab.repo} \
                || export PROJECT_NVIM_CONFIG=${pythonNeovimLab}
          '';
        };
      });
}
