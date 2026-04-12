{
  description = "Telegram via Nix Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux"; # sesuaikan kalau beda
      pkgs = import nixpkgs { inherit system; };
    in
    {
      packages.${system}.telegram = pkgs.telegram-desktop;

      defaultPackage.${system} = pkgs.telegram-desktop;
    };
}
