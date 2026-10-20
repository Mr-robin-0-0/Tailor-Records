import 'package:flutter/cupertino.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/apple_ui.dart';
import 'update_controller.dart';
import 'update_publisher.dart';

bool updateLaunchPromptShownThisSession = false;

Future<void> maybeShowUpdateLaunchPrompt(BuildContext context, WidgetRef ref) async {
  if (updateLaunchPromptShownThisSession) return;
  updateLaunchPromptShownThisSession = true;

  final info = await ref.read(updateControllerProvider.notifier).checkForUpdate();
  if (!context.mounted || info == null) return;

  final message = UpdatePublisher.availableMessage(info.versionName);

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
