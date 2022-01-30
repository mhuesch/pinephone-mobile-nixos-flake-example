{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-21.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/master";

    # nixos-specific
    home-manager.url = "github:mhuesch/home-manager/release-21.05";
    mobile-nixos = {
      url = github:NixOS/mobile-nixos;
      flake = false;
    };
    mobile-nixos-ppp = {
      url = github:samueldr-wip/mobile-nixos-wip/wip/pinephone-pro;
      flake = false;
    };
  };

  outputs = inputs @ { nixpkgs, nixpkgs-unstable, home-manager, mobile-nixos, mobile-nixos-ppp, ... }:
  let
    system = "aarch64-linux";
    defaultUserName = "dev";
  in
  {
    nixosConfigurations =
      {
        ########################################################################
        pinephone =
        ########################################################################
          nixpkgs.lib.nixosSystem {
            inherit system;
            modules = [
              (import ./configuration-pinephone.nix defaultUserName)
              home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users.${defaultUserName} = import ./hm-user.nix;
              }
              (import "${mobile-nixos}/lib/configuration.nix" {
                device = "pine64-pinephone";
              })
            ];
          };

        ########################################################################
        pinephonepro =
        ########################################################################
          nixpkgs.lib.nixosSystem {
            inherit system;
            modules = [
              (import ./configuration-pinephonepro.nix defaultUserName)
              home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users.${defaultUserName} = import ./hm-user.nix;
              }
              (import "${mobile-nixos}/lib/configuration.nix" {
                device = "pine64-pinephone";
              })
            ];
          };

      };

    pinephone-disk-image =
      (import "${mobile-nixos}/lib/eval-with-configuration.nix" {
        configuration = [ (import ./configuration-pinephone.nix defaultUserName) ];
        device = "pine64-pinephone";
        pkgs = nixpkgs.legacyPackages.${system};
      }).outputs.disk-image;

    pinephonepro-disk-image =
      (import "${mobile-nixos-ppp}/lib/eval-with-configuration.nix" {
        configuration = [ (import ./configuration-pinephonepro.nix defaultUserName) ];
        device = "pine64-pinephonepro";
        pkgs = nixpkgs.legacyPackages.${system};
      }).outputs.disk-image;
  };
}
