{ pkgs, lib, config, ... }:
let
  inherit (builtins) mapAttrs attrNames attrValues;
  inherit (lib) flatten;
  original =  mapAttrs (k: v: (pkgs.nixosOptionsDoc { inherit (v) options; }).optionsNix) config.evaluated-module-systems;
  lyraReady = let
    lyraifyModuleSystem = flakeURI: ms: map (msk: (let
        msv = ms.${msk};
      in msv // {
        key = msk;
        flake = flakeURI;
        description = if builtins.isAttrs msv.description then msv.description.text else msv.description;
      })) (attrNames ms);
  in flatten (attrValues (mapAttrs (lyraifyModuleSystem) original));
in
{
  target = {
    inherit original lyraReady;
  };
}
