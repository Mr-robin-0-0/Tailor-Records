import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/ota/update_controller.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/apple_ui.dart';
import '../../templates/presentation/template_list_screen.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(packageInfoProvider.future);
    });
  }

  String _statusLabel(UpdateUiState state) {
    switch (state.phase) {
      case UpdateFlowPhase.checking:
        return 'Checking…';
      case UpdateFlowPhase.upToDate:
        return 'Up to date';
      case UpdateFlowPhase.available:
        return 'Update ${state.available?.versionName ?? ''} available';
      case UpdateFlowPhase.downloading:
        final pct = ((state.progress ?? 0) * 100).round();
        return 'Downloading… $pct%';
      case UpdateFlowPhase.readyToInstall:
        return 'Opening installer…';
      case UpdateFlowPhase.error:
        return state.errorMessage ?? 'Update failed';
      case UpdateFlowPhase.idle:
        return 'Tap to check for updates';
    }
  }

  Future<void> _checkForUpdate() async {
    final info = await ref.read(updateControllerProvider.notifier).checkForUpdate();
    if (!mounted) return;

    final state = ref.read(updateControllerProvider);
    if (state.phase == UpdateFlowPhase.error) {
      showAppleSnackBar(context, state.errorMessage ?? 'Could not check for updates');
      return;
    }

    if (info == null) {
      final pkg = await ref.read(packageInfoProvider.future);
      await showCupertinoDialog<void>(
        context: context,
        builder: (dialogContext) => CupertinoAlertDialog(
          title: const Text('Up to date'),
          content: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'Tailor Records ${pkg.version} (${pkg.buildNumber}) is the latest release.',
            ),
          ),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    final download = await showAppleConfirmDialog(
      context,
      title: 'Update available',
      message: 'Version ${info.versionName} is available on GitHub.',
      cancel: 'Later',
      confirm: 'Download',
    );
    if (download == true && mounted) {
      await _downloadAndInstall();
    }
  }

  Future<void> _downloadAndInstall() async {
    await ref.read(updateControllerProvider.notifier).downloadAndInstall();
  }

  @override
  Widget build(BuildContext context) {
    final packageInfo = ref.watch(packageInfoProvider);
    final updateState = ref.watch(updateControllerProvider);
    final busy = updateState.phase == UpdateFlowPhase.checking ||
        updateState.phase == UpdateFlowPhase.downloading ||
        updateState.phase == UpdateFlowPhase.readyToInstall;

    final versionLabel = packageInfo.when(
      data: (info) => '${info.version} (${info.buildNumber})',
      loading: () => '…',
      error: (_, __) => 'Unknown',
    );

    final canInstall = updateState.phase == UpdateFlowPhase.available ||
        updateState.phase == UpdateFlowPhase.error;

    return Scaffold(
      backgroundColor: AppColors.groupedBackground(context),
      appBar: appleAppBar(
        context,
        title: 'Settings',
        leading: CupertinoNavigationBarBackButton(
          color: AppColors.systemBlue,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.only(top: 16),
        children: [
          const AppleSectionLabel('Workspace'),
          AppleInsetGroup(
            children: [
              AppleListRow(
                title: 'Measurement Templates',
                subtitle: 'Forms for shirts, suits, and more',
                leading: Icon(CupertinoIcons.square_list, color: AppColors.systemBlue),
                onTap: () {
                  Navigator.of(context).push(
                    appPageRoute((_) => const TemplateListScreen()),
                  );
                },
              ),
            ],
          ),
          const AppleSectionLabel('App'),
          AppleInsetGroup(
            children: [
              AppleListRow(
                title: 'Version',
                subtitle: versionLabel,
                leading: Icon(CupertinoIcons.info_circle, color: AppColors.systemBlue),
              ),
              AppleListRow(
                title: 'Check for update',
                subtitle: _statusLabel(updateState),
                leading: Icon(CupertinoIcons.arrow_down_circle, color: AppColors.systemBlue),
                onTap: busy ? null : _checkForUpdate,
              ),
              if (canInstall && updateState.available != null)
                AppleListRow(
                  title: 'Download & install',
                  subtitle: updateState.available!.versionName,
                  leading: Icon(CupertinoIcons.cloud_download, color: AppColors.systemBlue),
                  onTap: busy ? null : _downloadAndInstall,
                ),
            ],
          ),
        ],
      ),
    );
  }
}
