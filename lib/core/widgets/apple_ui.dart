import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Platform-appropriate push route. Android uses [MaterialPageRoute] so the OS
/// back gesture is not duplicated by Cupertino's edge-swipe pop.
Route<T> appPageRoute<T>(WidgetBuilder builder, {RouteSettings? settings}) {
  if (defaultTargetPlatform == TargetPlatform.android) {
    return MaterialPageRoute<T>(builder: builder, settings: settings);
  }
  return CupertinoPageRoute<T>(builder: builder, settings: settings);
}

const double kAppleGroupRadius = 12;
const double kAppleHorizontalInset = 16;

/// iOS-style gray fill while the finger is down (independent of Material splash theme).
class ApplePressable extends StatefulWidget {
  const ApplePressable({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.enabled = true,
  });

  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool enabled;

  @override
  State<ApplePressable> createState() => _ApplePressableState();
}

class _ApplePressableState extends State<ApplePressable> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed == value) return;
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled || (widget.onTap == null && widget.onLongPress == null)) {
      return widget.child;
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => _setPressed(true),
      onTapUp: (_) => _setPressed(false),
      onTapCancel: () => _setPressed(false),
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 80),
        curve: Curves.easeOut,
        color: _pressed ? AppColors.pressHighlight(context) : Colors.transparent,
        child: widget.child,
      ),
    );
  }
}

TextStyle appleLargeTitle(BuildContext context) => TextStyle(
      fontSize: 34,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.37,
      height: 1.1,
      color: AppColors.label(context),
    );

TextStyle appleSectionHeader(BuildContext context) => TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w400,
      letterSpacing: -0.08,
      color: AppColors.secondaryLabel(context),
    );

TextStyle appleRowTitle(BuildContext context) => TextStyle(
      fontSize: 17,
      fontWeight: FontWeight.w400,
      letterSpacing: -0.41,
      color: AppColors.label(context),
    );

TextStyle appleRowSubtitle(BuildContext context) => TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w400,
      color: AppColors.secondaryLabel(context),
    );

void showAppleSnackBar(BuildContext context, String message) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final background = isDark ? const Color(0xFF2C2C2E) : const Color(0xFF1C1C1E);

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w500,
          letterSpacing: -0.24,
        ),
      ),
      backgroundColor: background,
      elevation: 6,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      duration: const Duration(seconds: 2),
    ),
  );
}

/// Returns `true` if the user chose to discard unsaved changes.
Future<bool?> showDiscardUnsavedDialog(BuildContext context) {
  return showAppleConfirmDialog(
    context,
    title: 'Discard Changes?',
    message: 'You have unsaved changes that will be lost.',
    cancel: 'Keep Editing',
    confirm: 'Discard',
    destructive: true,
  );
}

Future<bool?> showAppleConfirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  String cancel = 'Cancel',
  String confirm = 'OK',
  bool destructive = false,
}) {
  return showCupertinoDialog<bool>(
    context: context,
    builder: (context) => CupertinoAlertDialog(
      title: Text(title),
      content: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Text(message),
      ),
      actions: [
        CupertinoDialogAction(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(cancel),
        ),
        CupertinoDialogAction(
          isDestructiveAction: destructive,
          isDefaultAction: !destructive,
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(confirm),
        ),
      ],
    ),
  );
}

Future<T?> showAppleActionSheet<T>(
  BuildContext context, {
  String? title,
  required List<({String label, T value, bool destructive})> options,
}) {
  return showCupertinoModalPopup<T>(
    context: context,
    builder: (context) => CupertinoActionSheet(
      title: title != null ? Text(title) : null,
      actions: options
          .map(
            (o) => CupertinoActionSheetAction(
              isDestructiveAction: o.destructive,
              onPressed: () => Navigator.of(context).pop(o.value),
              child: Text(o.label),
            ),
          )
          .toList(),
      cancelButton: CupertinoActionSheetAction(
        onPressed: () => Navigator.of(context).pop(),
        child: const Text('Cancel'),
      ),
    ),
  );
}

class AppleSearchField extends StatelessWidget {
  const AppleSearchField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.onChanged,
    this.onClear,
    this.padding = const EdgeInsets.fromLTRB(kAppleHorizontalInset, 0, kAppleHorizontalInset, 12),
  });

  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String> onChanged;
  final VoidCallback? onClear;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: CupertinoSearchTextField(
        controller: controller,
        placeholder: hintText,
        onChanged: onChanged,
        onSuffixTap: onClear,
        style: appleRowTitle(context),
        backgroundColor: AppColors.tertiaryFill(context),
      ),
    );
  }
}

class AppleSectionLabel extends StatelessWidget {
  const AppleSectionLabel(this.text, {super.key, this.isFirstSection = false});

  final String text;
  final bool isFirstSection;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        kAppleHorizontalInset + 4,
        isFirstSection ? 4 : 20,
        kAppleHorizontalInset,
        8,
      ),
      child: Text(text.toUpperCase(), style: appleSectionHeader(context)),
    );
  }
}

class AppleInsetGroup extends StatelessWidget {
  const AppleInsetGroup({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) return const SizedBox.shrink();

    final items = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      items.add(children[i]);
      if (i < children.length - 1) {
        items.add(Divider(
          height: 0.5,
          thickness: 0.5,
          indent: 16,
          color: AppColors.separator(context),
        ));
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kAppleHorizontalInset),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.secondaryGrouped(context),
          borderRadius: BorderRadius.circular(kAppleGroupRadius),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(kAppleGroupRadius),
          child: Column(mainAxisSize: MainAxisSize.min, children: items),
        ),
      ),
    );
  }
}

class AppleListRow extends StatelessWidget {
  const AppleListRow({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.showChevron = true,
  });

  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool showChevron;

  @override
  Widget build(BuildContext context) {
    return ApplePressable(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            if (leading != null) ...[
              leading!,
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: appleRowTitle(context)),
                  if (subtitle != null && subtitle!.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(subtitle!, style: appleRowSubtitle(context)),
                  ],
                ],
              ),
            ),
            if (trailing != null) trailing!,
            if (showChevron && onTap != null)
              Icon(Icons.chevron_right, size: 22, color: AppColors.secondaryLabel(context)),
          ],
        ),
      ),
    );
  }
}

class AppleAvatar extends StatelessWidget {
  const AppleAvatar({super.key, required this.name, this.radius = 22});

  final String name;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';
    return CircleAvatar(
      radius: radius,
      backgroundColor: AppColors.systemBlue.withValues(alpha: 0.15),
      child: Text(
        initial,
        style: TextStyle(
          color: AppColors.systemBlue,
          fontWeight: FontWeight.w600,
          fontSize: radius * 0.85,
        ),
      ),
    );
  }
}

class AppleEmptyState extends StatelessWidget {
  const AppleEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 56, color: AppColors.secondaryLabel(context)),
            const SizedBox(height: 16),
            Text(title, style: appleLargeTitle(context).copyWith(fontSize: 22)),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: appleRowSubtitle(context),
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 24),
              CupertinoButton.filled(
                onPressed: onAction,
                borderRadius: BorderRadius.circular(12),
                child: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class AppleNavBackButton extends StatelessWidget {
  const AppleNavBackButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.arrow_back_ios_new, size: 18, color: AppColors.systemBlue),
          Text('Back', style: TextStyle(color: AppColors.systemBlue, fontSize: 17)),
        ],
      ),
    );
  }
}

PreferredSizeWidget appleAppBar(
  BuildContext context, {
  String? title,
  Widget? leading,
  List<Widget>? actions,
}) {
  return AppBar(
    backgroundColor: AppColors.groupedBackground(context),
    surfaceTintColor: Colors.transparent,
    elevation: 0,
    scrolledUnderElevation: 0,
    centerTitle: true,
    title: title != null
        ? Text(
            title,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600, letterSpacing: -0.41),
          )
        : null,
    leading: leading,
    actions: actions,
    iconTheme: IconThemeData(color: AppColors.systemBlue),
  );
}
