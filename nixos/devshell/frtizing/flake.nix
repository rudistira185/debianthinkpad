{
  description = "Fritzing via Nix Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
  };

  outputs = { self, nixpkgs }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; };
  in
  {
    packages.${system}.default = pkgs.fritzing;

    apps.${system}.default = {
      type = "app";
      program = "${pkgs.fritzing}/bin/Fritzing";
    };

    devShells.${system}.default = pkgs.mkShell {
      buildInputs = [
        pkgs.fritzing
      ];
    };
  };
}
