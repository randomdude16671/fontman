{
  description = "Super minimal font management flake (NixOS only)";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs =
    { self, nixpkgs, ... }:
    {
      nixosModules = rec {
        fontman = ./nixos;
        default = fontman;
      };
    };
}
