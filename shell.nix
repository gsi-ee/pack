{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = with pkgs; [
    root
    cmake
    git
    gcc
    qt6.qtbase
    qt6.qtwebengine
    ncurses
    freetype
  ];
}
