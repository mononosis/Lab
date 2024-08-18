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
          sha256 = "sha256-I9HvQAzDR0SfeihK0Dwpz4pjNS7UVsI+5WLHDut/0K0="; # Replace with the correct hash
        };
      in
      {
        devShell = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [
            wrapGAppsHook
          ];
          buildInputs = with pkgs; [
            #pkgs.conda
            hello
            qt5Full
            qtcreator
            python311
            gobject-introspection
            gtk3
            gtk-layer-shell
            webkitgtk
            glib-networking
            pango
            nodePackages.pyright
            python311Packages.black
            wlroots
            python311Packages.fairscale
            python311Packages.tiktoken
            python311Packages.pywayland
            python311Packages.beautifulsoup4
            python311Packages.fire
            python311Packages.pygithub
            python311Packages.pywlroots
            python311Packages.pynvim
            python311Packages.tabulate
            python311Packages.flake8
            python311Packages.pandas
            python311Packages.mplfinance
            python311Packages.graphviz
            python311Packages.seaborn
            python311Packages.plotly
            python311Packages.setuptools
            python311Packages.wheel
            python311Packages.flask
            python311Packages.scikit-learn
            python311Packages.dbus-python

            python311Packages.pyqt5
            python311Packages.qtpy
            python311Packages.pytz
            python311Packages.pyqtwebengine
            python311Packages.pywebview
            #python311Packages.pywebview[qt]

            python311Packages.debugpy
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
            #export GI_TYPELIB_PATH=${pkgs.gobject-introspection}/lib/girepository-1.0:${pkgs.gtk3}/lib/girepository-1.0:${pkgs.pango}/lib/girepository-1.0
            #export GIO_EXTRA_MODULES=${pkgs.glib-networking}/modules/

            export NVIM_PLUGIN_PATHS=""
            [[ ! -z $NIX_DEV_MODE ]] \
                && echo "We are in dev mode" \
                && export PROJECT_NVIM_CONFIG=$HOME/Lab/LuaLab/${pythonNeovimLab.repo} \
                || export PROJECT_NVIM_CONFIG=${pythonNeovimLab}

          '';
        };
      });
}
