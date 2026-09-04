{
  description = "philomagi homelab NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    iwaya = {
      url = "github:tooppoo/iwaya/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    herdr = {
      url = "github:herdrdev/herdr/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, iwaya, herdr, ... }:
    {
      nixosConfigurations.philomagi-homelab = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        modules = [
          ./hosts/philomagi-homelab/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.users.philomagi = import ./home.nix;
          }
          ({ pkgs, ... }: {
            environment.systemPackages = [
              iwaya.packages.${pkgs.system}.default
              herdr.packages.${pkgs.system}.default
            ];
          })
        ];
      };
    };
}
