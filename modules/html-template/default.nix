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
          <h2>@key@ <span>@flake@</span></h2>
          <p>@description@</p>
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
