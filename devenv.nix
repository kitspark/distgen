{ pkgs, ... }:

{
  packages = [ pkgs.zip ];

  enterShell = ''
    echo "Dev env ready. Use 'devenv task zip' to package stuff."
  '';
}
