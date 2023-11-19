{
  description = "Terraform projects";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    home-manager.url = "github:nix-community/home-manager/release-23.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, home-manager, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        nerdtree = pkgs.fetchFromGitHub {
          owner = "preservim";
          repo = "nerdtree";
          rev = "7.0.0";  
          sha256 = "sha256-ozrxaHNG5j0+Zn68AOiGfarwooFw1czUf8POcDxeaZA=";
        };
        # Fetch the Lua configuration file directly from GitHub
        terraformNvimConfig = pkgs.fetchFromGitHub {
          owner = "mononosis";
          repo = "neovim-terraform-lab";
          rev = "main"; # Use the appropriate commit or tag
          sha256 = "sha256-VhLTlwKKg0BiQ3nP0ZTecuZG959mxHANQCSyU4+m9kE="; # Replace with the correct hash
        };
      in
      {
        devShell = pkgs.mkShell {
          buildInputs = [
            pkgs.terraform
            pkgs.google-cloud-sdk
            #(nixpkgs.legacyPackages.x86_64-linux.neovim.override {
            #  # Use the custom configuration for Terraform
            #  configure = {
            #    customRC = builtins.readFile (terraformNvimConfig + "/terraform-nvim-config.lua");
            #  };
            #})
          ];
          shellHook = ''
            export PROJECT_NVIM_CONFIG=${terraformNvimConfig}/terraform-nvim-config.lua
          '';
          postShellHook = ''
            if [ -n "$IN_NIX_SHELL" ]; then
              echo fklsdjlfjsdlkfjsdlkjflsjldfjlskdjflksjflksdjlkfjsdlkfjlskdjflksdjflksjdlkfjsldkfjlsdjf
              ln -s ${nerdtree} /home/nixos/jfkldsjlkfjs/nerdtree
            fi
          '';
        };
      });
}
