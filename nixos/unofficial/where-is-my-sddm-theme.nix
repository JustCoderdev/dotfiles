# This is an override for the default nix package since wims is
# broken in this version
# Source: <https://github.com/NixOS/nixpkgs/blob/e2dd4e18cc1c7314e24154331bae07df76eb582f/pkgs/by-name/wh/where-is-my-sddm-theme/package.nix>

{
  lib,
  formats,
  stdenvNoCC,
  fetchFromGitHub,
  qt6,
  libsForQt5,
  variants ? [ "qt6" ],
  themeConfig ? null,
}:

let
  user-cfg = (formats.ini { }).generate "theme.conf.user" themeConfig;
  validVariants = [
    "qt5"
    "qt6"
  ];
in

lib.checkListOfEnum "where-is-my-sddm-theme: variant" validVariants variants

stdenvNoCC.mkDerivation rec {
  pname = "where-is-my-sddm-theme";
  version = "1.11.0";

  src = fetchFromGitHub {
    owner = "stepanzubkov";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-EzO+MTz1PMmgeKyw65aasetmjUCpvilcvePt6HJZrpo=";
  };

  propagatedUserEnvPkgs =
    [ ]
    ++ lib.optional (lib.elem "qt5" variants) [ libsForQt5.qtgraphicaleffects ]
    ++ lib.optional (lib.elem "qt6" variants) [
      qt6.qt5compat
      qt6.qtsvg
    ];

  installPhase =
    ''
      mkdir -p $out/share/sddm/themes/
    ''
    + lib.optionalString (lib.elem "qt6" variants) (
      ''
        cp -r where_is_my_sddm_theme/ $out/share/sddm/themes/
      ''
      + lib.optionalString (lib.isAttrs themeConfig) ''
        ln -sf ${user-cfg} $out/share/sddm/themes/where_is_my_sddm_theme/theme.conf.user
      ''
    )
    + lib.optionalString (lib.elem "qt5" variants) (
      ''
        cp -r where_is_my_sddm_theme_qt5/ $out/share/sddm/themes/
      ''
      + lib.optionalString (lib.isAttrs themeConfig) ''
        ln -sf ${user-cfg} $out/share/sddm/themes/where_is_my_sddm_theme_qt5/theme.conf.user
      ''
    );

  meta = with lib; {
    description = "The most minimalistic SDDM theme among all themes";
    homepage = "https://github.com/stepanzubkov/where-is-my-sddm-theme";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ name-snrl ];
  };
}
