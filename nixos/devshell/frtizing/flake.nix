{
  description = "Fritzing via Nix Flake (FIX GLX via nixGL)";

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
    packages.${system}.default = pkgs.fritzing;

    devShells.${system}.default = pkgs.mkShell {
      buildInputs = [
        pkgs.fritzing
        
        # Wrapper grafis nixGL
        pkgs.nixgl.auto.nixGLDefault
        
        # Modul GTK & Locale
        pkgs.libcanberra-gtk3
        pkgs.glibcLocales
      ];

      shellHook = ''
        # Set Locale
        export LANG=en_US.UTF-8
        export LC_ALL=en_US.UTF-8
        export LOCALE_ARCHIVE=${pkgs.glibcLocales}/lib/locale/locale-archive
        
        # Set Qt & GTK
        export QT_QPA_PLATFORM=xcb
        export GTK_PATH=${pkgs.libcanberra-gtk3}/lib/gtk-3.0/modules

        # Alias untuk menjalankan aplikasi lewat nixGL
        alias fritzing-run="nixGL Fritzing"

        echo "Fritzing devShell ready 🚀 (GLX Fixed via nixGL)"
        echo "👉 Ketik 'fritzing-run' untuk menjalankan aplikasi."
      '';
    };
  };
}
