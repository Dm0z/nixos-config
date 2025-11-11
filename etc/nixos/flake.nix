{
  description = "NixOS config with Spicetify";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Add Spicetify-Nix
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
  };

  outputs = { self, nixpkgs, spicetify-nix, ... }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; config.allowUnfree = true; };
  in {
    nixosConfigurations = {
      # Replace this with your hostname
      nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./configuration.nix

          # Import Spicetify module for NixOS
          spicetify-nix.nixosModules.default

          # Inline Spicetify configuration
          {
            programs.spicetify =
              let
                spicePkgs = spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
              in
              {
                enable = true;
                theme = spicePkgs.themes.ziro;
                colorScheme = "gray-dark";
              
		# Optional extras (advanced example)
		enabledExtensions = with spicePkgs.extensions; [ adblock
hidePodcasts shuffle
                ];
              };
          }
        ];
      };
    };
  };
}
