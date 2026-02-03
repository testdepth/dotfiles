{
  description = "Personal dotfiles - Nix + devenv + home-manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    devenv = {
      url = "github:cachix/devenv";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs@{ flake-parts, nixpkgs, home-manager, devenv, ... }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = systems;

      perSystem = { config, pkgs, system, ... }: {
        # Development shell via devenv
        devShells.default = devenv.lib.mkShell {
          inherit inputs pkgs;
          modules = [ ./devenv.nix ];
        };

        # Formatter
        formatter = pkgs.nixfmt-rfc-style;
      };

      flake = {
        # Home Manager configurations
        homeConfigurations = {
          # macOS Apple Silicon (default)
          "macbook" = home-manager.lib.homeManagerConfiguration {
            pkgs = nixpkgs.legacyPackages.aarch64-darwin;
            modules = [ 
              ./home.nix 
              ./hosts/macbook
            ];
            extraSpecialArgs = { inherit inputs; };
          };

          # macOS Intel
          "macbook-intel" = home-manager.lib.homeManagerConfiguration {
            pkgs = nixpkgs.legacyPackages.x86_64-darwin;
            modules = [ 
              ./home.nix 
              ./hosts/macbook
            ];
            extraSpecialArgs = { inherit inputs; };
          };

          # Linux
          "linux" = home-manager.lib.homeManagerConfiguration {
            pkgs = nixpkgs.legacyPackages.x86_64-linux;
            modules = [ 
              ./home.nix 
            ];
            extraSpecialArgs = { inherit inputs; };
          };
        };
      };
    };
}
