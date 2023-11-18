{
  description = "Terraform projects";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";  
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }: 
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
      in
      {
        devShell = pkgs.mkShell {
          buildInputs = [ pkgs.terraform pkgs.neovim pkgs.google-cloud-sdk ];
        };
      });
}
