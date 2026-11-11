import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// The line icons drawn for the 39 HTML screens (24 x 24, 1.75 stroke), stored
/// in `assets/icons`. Directional icons are drawn for left-to-right and mirror
/// in Arabic; universal ones (search, cart, camera...) never mirror
/// (FR-LOC-01).
enum BBIcons {
  arrowLeft('arrow_left', directional: true),
  arrowRight('arrow_right', directional: true),
  chevronLeft('chevron_left', directional: true),
  chevronRight('chevron_right', directional: true),
  chevronDown('chevron_down'),
  bag('bag'),
  bell('bell'),
  cake('cake'),
  calendar('calendar'),
  camera('camera'),
  card('card'),
  cash('cash'),
  check('check'),
  clock('clock'),
  close('close'),
  coffee('coffee'),
  copy('copy'),
  cube('cube'),
  edit('edit'),
  eye('eye'),
  filter('filter'),
  flower('flower'),
  gift('gift'),
  globe('globe'),
  grid('grid'),
  heart('heart'),
  home('home'),
  info('info'),
  instagram('instagram'),
  layers('layers'),
  leaf('leaf'),
  locate('locate'),
  lock('lock'),
  logout('logout', directional: true),
  minus('minus'),
  phone('phone'),
  pin('pin'),
  plus('plus'),
  receipt('receipt'),
  refresh('refresh'),
  search('search'),
  settings('settings'),
  share('share'),
  shieldCheck('shield_check'),
  sparkle('sparkle'),
  star('star'),
  store('store'),
  trash('trash'),
  truck('truck'),
  undo('undo', directional: true),
  upload('upload'),
  user('user'),
  wallet('wallet'),
  warning('warning'),
  whatsapp('whatsapp'),
  wifiOff('wifi_off');

  new(this.file, {this.directional = false});

  final String file;
  final bool directional;

  /// "Back" in the reading direction: a left arrow in English, right in Arabic.
  static const BBIcons back = arrowLeft;

  /// "Next" in the reading direction (the screens' primary CTAs).
  static const BBIcons forward = arrowRight;

  String get asset => 'assets/icons/$file.svg';
}

class BBIcon extends StatelessWidget {
  const new(
    this.icon, {
    super.key,
    this.size = 20,
    this.color,
    this.semanticLabel,
  });

  final BBIcons icon;
  final double size;

  /// Defaults to the surrounding [IconTheme] color, like Material icons.
  final Color? color;

  /// Leave null for decorative icons next to a text label.
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final resolved =
        color ?? IconTheme.of(context).color ?? const Color(0xFF2C2422);
    Widget svg = SvgPicture.asset(
      icon.asset,
      width: size,
      height: size,
      theme: SvgTheme(currentColor: resolved),
      excludeFromSemantics: true,
    );
    if (icon.directional && Directionality.of(context) == TextDirection.rtl) {
      svg = Transform.flip(flipX: true, child: svg);
    }
    if (semanticLabel == null) return ExcludeSemantics(child: svg);
    return Semantics(label: semanticLabel, image: true, child: svg);
  }
}
