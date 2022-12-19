{ lib, ... }: {
  imports = [
    ./base.nix
    ./nixified.nix
    ./html-template
  ];
}
