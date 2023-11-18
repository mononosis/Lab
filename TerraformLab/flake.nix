{
  description = "Terraform projects";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";  
    flake-utils.url = "github:numtide/flake-utils";
    terraform-config.url = "github:mononosis/neovim-terraform-lab/main";
  };

  outputs = { self, nixpkgs, flake-utils, terraform-config, ... }: 
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
      in
      {
        devShell = pkgs.mkShell {
          buildInputs = [ 
            pkgs.terraform 
            pkgs.google-cloud-sdk 
            pkgs.neovim
            (nixpkgs.legacyPackages.x86_64-linux.neovim.override {
              # Use the custom configuration for Terraform
              configure = {
                customRC = builtins.readFile (terraform-config + "/terraform-nvim-config.lua");
              };
            })

          ];
        };
      });
}
