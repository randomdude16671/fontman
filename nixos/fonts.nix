{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkPackageOption
    mkEnableOption
    mkOption
    types
    ;
  cfg = config.fontman;

  mkFontOptions =
    {
      name,
      displayName,
      package,
    }:
    {
      package = mkPackageOption pkgs package { } // {
        description = "Package providing ${displayName} font";
      };

      name = mkOption {
        type = types.str;
        description = "Name of ${displayName} font";
        default = name;
      };
    };
in
{
  options.fontman = {
    enable = mkEnableOption "Enable font management through fontman";
    fonts = mkOption {
      description = "actual font settings";
      type = types.submodule {
        options = {
          serif = mkFontOptions {
            displayName = "Serif";
            name = "DejaVu Serif";
            package = "dejavu_fonts";
          };
          sansSerif = mkFontOptions {
            displayName = "Sans Serif";
            name = "Adwaita Sans";
            package = "adwaita-fonts";
          };
          monospace = mkFontOptions {
            displayName = "Monospace";
            name = "IosevkaTerm Nerd Font";
            package = "nerd-fonts.iosevka-term";
          };
          emoji = mkFontOptions {
            displayName = "Emoji";
            fontName = "Noto Color Emoji";
            package = "noto-fonts-color-emoji";
          };
        };
      };
    };
    extraPackages = mkOption {
      description = ''
        List of all the font packages that will be installed
      '';
      type = types.listOf types.package;
    };

  };

  config = lib.mkIf cfg.enable {
    fonts.packages =
      let
        inherit (cfg) extraPackages;
        inherit (cfg.fonts)
          monospace
          serif
          sansSerif
          emoji
          ;
      in
      [
        monospace.package
        serif.package
        sansSerif.package
        emoji.package
      ]
      ++ extraPackages;
    fonts.fontconfig = {
      enable = cfg.enable;
      defaultFonts = lib.getAttrs [
        "monospace"
        "serif"
        "sansSerif"
        "emoji"
      ] (family: [ cfg.fonts.${family}.name ]);
    };
  };
}
