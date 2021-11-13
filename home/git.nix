{ config, lib, pkgs, ... }:

{
  programs.git = {
    enable = true;
    aliases = {
      lol = "log --graph --decorate --pretty=oneline --abbrev-commit";
    };
    extraConfig = {
      fetch.prune = true;
      pull.rebase = true;
      init.defaultBranch = "main";
    };
  };
}
