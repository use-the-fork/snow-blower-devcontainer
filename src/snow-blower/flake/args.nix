{inputs, ...}: {
  perSystem = {
    config,
    system,
    ...
  }: {
    legacyPackages = import inputs.nixpkgs {
      inherit system;
      overlays = [];
      config = {
        allowUnfree = true;
        allowUnsupportedSystem = true;
      };
    };
  };

  flake = {
    snow-blower = {
      username = "code";
    };
  };
}
