import 'package:flutter/material.dart';

/// iOS-style semantic colors (light / dark).
abstract final class AppColors {
  static const Color systemBlue = Color(0xFF007AFF);
  static const Color systemRed = Color(0xFFFF3B30);
  static const Color systemGreen = Color(0xFF34C759);

  static const Color groupedBackgroundLight = Color(0xFFF2F2F7);
  static const Color secondaryGroupedLight = Color(0xFFFFFFFF);
  static const Color tertiaryFillLight = Color(0xFFE5E5EA);
  static const Color separatorLight = Color(0xFFC6C6C8);
  static const Color labelLight = Color(0xFF000000);
  static const Color secondaryLabelLight = Color(0x993C3C43);

  static const Color groupedBackgroundDark = Color(0xFF000000);
  static const Color secondaryGroupedDark = Color(0xFF1C1C1E);
  static const Color tertiaryFillDark = Color(0xFF2C2C2E);
  static const Color separatorDark = Color(0xFF38383A);
  static const Color labelDark = Color(0xFFFFFFFF);
  static const Color secondaryLabelDark = Color(0x99EBEBF5);

  static Color groupedBackground(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? groupedBackgroundDark : groupedBackgroundLight;

  static Color secondaryGrouped(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? secondaryGroupedDark : secondaryGroupedLight;

  static Color tertiaryFill(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? tertiaryFillDark : tertiaryFillLight;

  static Color separator(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? separatorDark : separatorLight;

  static Color label(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? labelDark : labelLight;

  static Color secondaryLabel(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? secondaryLabelDark : secondaryLabelLight;

  static bool _isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  /// UITableView-style row highlight while pressed.
  static Color pressHighlight(BuildContext context) => pressHighlightFor(_isDark(context));

  static Color pressHighlightFor(bool isDark) =>
      isDark ? Colors.white.withValues(alpha: 0.12) : Colors.black.withValues(alpha: 0.06);

  static Color pressOverlayFor(bool isDark) =>
      isDark ? Colors.white.withValues(alpha: 0.14) : Colors.black.withValues(alpha: 0.08);
}
