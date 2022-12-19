{ pkgs, config, lib, ... }:
let
  inherit (lib) types mkOption;
  item-template = builtins.replaceStrings [ "`" ] [ "@backtick@" ] config.html.template.item-template;
  templateFinal = builtins.replaceStrings [
    "@json-data@"                               "@item-template@"
  ] [
    (builtins.toJSON config.target.lyraReady)   item-template
  ] (builtins.readFile ./template.html);
in {
  options.html.template = {
    item-template = mkOption {
      description = ''
        How to represent each item in the HTML

        You can reference values in one option by using {propery} for example.

        You must supply a container item, that item will always have the `lyrasearch-item` class
      '';
      type = types.str;
      default = ''
        <md-block>
          # `@flake@` - `@key@`

          **Type**: @type@

          **Example**: `@example@`

          **Default**: `@default@`

          @description@
        </md-block>
      '';
    };
  };
  config.target.html = pkgs.stdenvNoCC.mkDerivation {
    name = "template.html";
    dontUnpack = true;
    installPhase = ''
      cp ${builtins.toFile "out.html" templateFinal} $out
    '';
  };
}
