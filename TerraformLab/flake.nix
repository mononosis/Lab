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
        vimTerraform = pkgs.fetchFromGitHub {
          owner = "hashivim";
          repo = "vim-terraform";
          rev = "master";
          sha256 = "sha256-UGpgRqvmxsAbGF0yAKWaW0wbdxwzETlns6Y1peTRYBg=";
        };
        # Fetch the Lua configuration file directly from GitHub
        terraformNvimConfig = pkgs.fetchFromGitHub {
          owner = "mononosis";
          repo = "nvim-terraform-config";
          rev = "main"; # Use the appropriate commit or tag
          sha256 = "sha256-l2UQL/s4jXpfi5Hb7gMzIe+QrT6/lu71yuc0A05l9uE="; # Replace with the correct hash
        };
      in
      {
        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [
            terraform
            postgresql
            terraform-ls
            tflint
            velero
            vault
            sops
            eksctl
            gnupg
            k9s
            kustomize
            fluxcd
            graphviz
            google-cloud-sdk
            kubectl
            awscli2
            kubernetes-helm
          ];
          shellHook = ''
            export NVIM_PLUGIN_PATHS="${vimTerraform}"
            export PROJECT_NVIM_CONFIG=${terraformNvimConfig}
          '';
        };
      });
}
