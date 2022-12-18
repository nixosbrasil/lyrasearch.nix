{ lib
, writeShellScript
, pkgs
, callPackage
, stdenvNoCC
}:
config:
let
  inherit (lib) types;
  module = lib.evalModules {
    modules = [
      config
      ./modules
    ];
    specialArgs = {
      inherit pkgs;
    };
  };
  out = stdenvNoCC.mkDerivation {
    name = "out";
    dontUnpack = true;
    jsonFile = builtins.toFile "dataset.json" (builtins.toJSON module.config.target.full);
    installPhase = "cp $jsonFile $out";
  };
in out.overrideAttrs (_: {
  passthru = {
    inherit module;
    # inherit (module) config options;
    # inherit module;
    # docs = callPackage ./docs {};
  };
})
