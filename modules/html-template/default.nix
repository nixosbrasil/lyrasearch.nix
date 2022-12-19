{ pkgs, config, lib, ... }:
let
  inherit (lib) types mkOption;
  templateFinal = builtins.replaceStrings [
    "@json-data@"                               "@item-template@"
  ] [
    (builtins.toJSON config.target.lyraReady)   config.html.template.item-template
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
        <div>
          <h2><span>@flake@</span> @key@</h2>
          <p><b>Type:</b> @type@</p>
          <p><b>Example:</b> @example@</p>
          <p><b>Default:</b> @default@</p>
          <md-block>
          @description@
          </md-block>
        </div>
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
