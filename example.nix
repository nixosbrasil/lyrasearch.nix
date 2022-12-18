{ pkgs ? import <nixpkgs> {} }:
let
  docGen = pkgs.callPackage ./default.nix {};
in docGen {
  evaluated-module-systems = {
    "github:lucasew/nixcfg/whiterun" = (builtins.getFlake "github:lucasew/nixcfg").nixosConfigurations.whiterun;
    # "climod#example" = (import "${pkgs.fetchFromGitHub {
    #   owner = "nixosbrasil";
    #   repo = "climod";
    #   rev = "64f6c5495db03185803105d5babd2906a3fdcd99";
    #   sha256 = "sha256-BLvyAl+taQAd+bnkUYsAcEIB15pwtJ9zSZkg7od2RBA=";
    # }}/example.nix" { inherit pkgs; });
  };
}
