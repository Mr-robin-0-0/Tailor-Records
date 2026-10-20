import 'package:flutter/cupertino.dart';

import '../widgets/apple_ui.dart';
import 'update_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

bool updateLaunchPromptShownThisSession = false;

Future<void> maybeShowUpdateLaunchPrompt(BuildContext context, WidgetRef ref) async {
  if (updateLaunchPromptShownThisSession) return;
  updateLaunchPromptShownThisSession = true;

  final info = await ref.read(updateControllerProvider.notifier).checkForUpdate();
  if (!context.mounted || info == null) return;

  final notes = info.notes.trim();
  final message = notes.isEmpty
      ? 'Version ${info.versionName} is available.'
      : 'Version ${info.versionName} is available.\n\n$notes';

  final updateNow = await showAppleConfirmDialog(
    context,
    title: 'Update available',
    message: message,
    cancel: 'Later',
    confirm: 'Update',
  );

  if (updateNow == true && context.mounted) {
    await ref.read(updateControllerProvider.notifier).downloadAndInstall();
  }
}
