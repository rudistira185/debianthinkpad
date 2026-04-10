{
  description = "Draw.io dengan Akselerasi GPU (nixGL + Electron Flags)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    nixgl.url = "github:nix-community/nixGL";
  };

  outputs = { self, nixpkgs, nixgl }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      overlays = [ nixgl.overlay ];
    };
  in
  {
    packages.${system}.default = pkgs.drawio;

    devShells.${system}.default = pkgs.mkShell {
      buildInputs = [
        pkgs.drawio
        
        # Wrapper grafis nixGL
        pkgs.nixgl.auto.nixGLDefault
        
        # Locale fix
        pkgs.glibcLocales
      ];

      shellHook = ''
        # Set Locale (Menghindari warning bash di Debian)
        export LANG=en_US.UTF-8
        export LC_ALL=en_US.UTF-8
        export LOCALE_ARCHIVE=${pkgs.glibcLocales}/lib/locale/locale-archive

        # 🔥 Alias sakti untuk Draw.io
        # nixGL akan menjembatani driver Debian, sementara flag di belakangnya
        # memaksa Electron (Chromium) untuk menyalakan hardware acceleration.
        alias drawio-run="nixGL drawio --ignore-gpu-blocklist --enable-gpu-rasterization --enable-zero-copy"

        echo "Draw.io devShell ready 🚀 (GPU Accelerated)"
        echo "👉 Ketik 'drawio-run' untuk mulai menggambar diagram."
      '';
    };
  };
}
