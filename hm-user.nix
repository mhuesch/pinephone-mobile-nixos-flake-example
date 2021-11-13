{ config, pkgs, ... }:

let

  configured-pkgs = [
    ./home/direnv.nix
    ./home/git.nix
    ./home/gpg.nix
    ./home/ssh.nix
    ./home/zoxide.nix
  ];

  configured-services = [
    ./home/lorri.nix
  ];

in

{
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    asciidoctor
    asciinema
    bat
    bottom
    entr
    exa
    fd
    fortune
    neo-cowsay
    neofetch
    ripgrep
    unzip
  ];

  imports = configured-pkgs ++ configured-services;

  home.file = {
    ".ghci".text = builtins.readFile ./home/ghc/ghci;
  };
}
}
