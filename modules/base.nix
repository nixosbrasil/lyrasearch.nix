{ lib, ... }:
let
  inherit (lib) types mkOption;
in
{
  options = {
    evaluated-module-systems = mkOption {
      description = "Module systems by flake URI";
      type = types.attrsOf types.anything;
    };
    target = mkOption {
      internal = true;
      description = "Results";
      type = types.attrsOf types.anything;
    };
  };
}
