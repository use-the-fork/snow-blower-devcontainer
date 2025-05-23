{
  description = "snow-blower-devcontainer";

  inputs = {
    # global, so they can be `.follow`ed
    systems.url = "github:nix-systems/default-linux";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    treefmt-nix.url = "github:numtide/treefmt-nix";

    # guess what this does
    # come on, try
    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} {
      # Systems for which attributes of perSystem will be built. As
      # a rule of thumb, only systems provided by available hosts
      # should go in this list. More systems will increase evaluation
      # duration.
      systems = import inputs.systems;

      imports = [
        ./flake # Parts of the flake that are used to construct the final flake.
      ];
    };
}
