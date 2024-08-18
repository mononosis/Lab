{
  description = "Java projects";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        #neovimLab = pkgs.fetchFromGitHub {
          #owner = "mononosis";
          #repo = "nvim-java-config";
          #rev = "main"; 
          #sha256 = ""; 
        #};
      in
      {
        devShell = pkgs.mkShell {
          buildInputs = [
            #pkgs.openjdk11-bootstrap
            pkgs.openjdk8-bootstrap
            pkgs.maven
          ];
        };
      });
}
