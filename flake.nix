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
  };

  outputs = inputs @ { nixpkgs, nixpkgs-unstable, home-manager, mobile-nixos, ... }:
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
              (import ./configuration.nix { inherit defaultUserName inputs; })
              home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users.${defaultUserName} = import ./hm-user.nix;
              }
            ];
          };

      };

    pinephone-disk-image =
      (import "${mobile-nixos}/lib/eval-with-configuration.nix" {
        configuration = [ (import ./configuration.nix { inherit defaultUserName inputs; }) ];
        device = "pine64-pinephone";
        pkgs = nixpkgs.legacyPackages.${system};
      }).outputs.disk-image;
  };
}
