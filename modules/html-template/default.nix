{ pkgs, config, lib, ... }:
let
  inherit (lib) types mkOption;
  item-template = builtins.replaceStrings [ "`" ] [ "@backtick@" ] config.html.template.item-template;
  payload-template = builtins.replaceStrings [
    "@json-data@"                               "@item-template@"
  ] [
    (builtins.toJSON config.target.lyraReady)   item-template
  ] (builtins.readFile ./template.html);
  final-template = ''
${config.html.template.prelude}
${payload-template}
${config.html.template.poslude}
  '';
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
          # `@key@`

          `@flake@`

          **Type**: @type@

          **Example**: `@example@`

          **Default**: `@default@`

          **Declarations**: @declarations@

          @description@
        </md-block>
      '';
    };
    prelude = mkOption {
      description = ''
        HTML to put before the templated payload.

        This part should include the <!DOCTYPE html> part, head and the body opening.
      '';
      type = types.str;
      default = ''
        <!DOCTYPE html>
        <link rel="stylesheet" href="https://unpkg.com/sakura.css/css/sakura.css" type="text/css">
        <script type="module" src="https://md-block.verou.me/md-block.js"></script>
        <input id="lyrasearch-search-input" placeholder="Search through %n% options" />
        <div id="lyrasearch-container"></div>
        <md-span></md-span> <!-- just to warm up -->
        <style>
        input#lyrasearch-search-input {
          width: 100%;
        }
        </style>
      '';
    };
    poslude = mkOption {
      description = ''
        HTML to put after the templated payload.

        This part should include the body and html closing tag.
      '';
      type = types.str;
      default = ''
        <script>
        (function () {
          const ref = document.getElementById('lyrasearch-search-input')
          ref.placeholder = ref.placeholder.replaceAll('%n%', LYRASEARCH_DATA.length)
        })()
        </script>
      '';
    };
  };
  config.target.html = pkgs.stdenvNoCC.mkDerivation {
    name = "template.html";
    dontUnpack = true;
    installPhase = ''
      cp ${builtins.toFile "out.html" final-template} $out
    '';
  };
}
