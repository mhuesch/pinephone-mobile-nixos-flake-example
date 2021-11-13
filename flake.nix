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
  {
    nixosConfigurations =
      {
        ########################################################################
        pinephone =
        ########################################################################
          let
            defaultUserName = "dev";
          in
          nixpkgs.lib.nixosSystem {
            system = "aarch64-linux";
            modules = [
              (import ./configuration.nix defaultUserName)
              home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users.${defaultUserName} = import ./hm-user.nix;
              }
            ];
            specialArgs = { inherit inputs; };
          };

      };
  };
}
