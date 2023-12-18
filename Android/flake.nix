{
  description = "Lua projects";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      {
        devShell = pkgs.mkShell {
          buildInputs = [
            pkgs.scrpy
          ];
          shellHook = ''
            adb kill-server                
            sudo adb start-server
            sudo adb devices


            adb tcpip 5566
            device_ip=$(adb shell ip route | awk '{print $9}')
            adb connect $device_ip:5566

          '';
        };
      });
}
