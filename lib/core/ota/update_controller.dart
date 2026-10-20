import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'app_updater.dart';
import 'github_release_updater.dart';

final appUpdaterProvider = Provider<AppUpdater>((ref) {
  return GitHubReleaseUpdater();
});

final packageInfoProvider = FutureProvider<PackageInfo>((ref) {
  return PackageInfo.fromPlatform();
});

enum UpdateFlowPhase {
  idle,
  checking,
  upToDate,
  available,
  downloading,
  readyToInstall,
  error,
}

class UpdateUiState {
  const UpdateUiState({
    this.phase = UpdateFlowPhase.idle,
    this.available,
    this.progress,
    this.downloadedApk,
    this.errorMessage,
  });

  final UpdateFlowPhase phase;
  final UpdateInfo? available;
  final double? progress;
  final File? downloadedApk;
  final String? errorMessage;

  UpdateUiState copyWith({
    UpdateFlowPhase? phase,
    UpdateInfo? available,
    double? progress,
    File? downloadedApk,
    String? errorMessage,
    bool clearError = false,
    bool clearApk = false,
  }) {
    return UpdateUiState(
      phase: phase ?? this.phase,
      available: available ?? this.available,
      progress: progress ?? this.progress,
      downloadedApk: clearApk ? null : (downloadedApk ?? this.downloadedApk),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

class UpdateController extends StateNotifier<UpdateUiState> {
  UpdateController(this._updater) : super(const UpdateUiState());

  final AppUpdater _updater;

  Future<UpdateInfo?> checkForUpdate() async {
    state = state.copyWith(phase: UpdateFlowPhase.checking, clearError: true);
    try {
      final result = await _updater.check();
      switch (result) {
        case UpdateNone():
          state = state.copyWith(phase: UpdateFlowPhase.upToDate, clearApk: true);
          return null;
        case UpdateAvailable(:final info):
          state = state.copyWith(
            phase: UpdateFlowPhase.available,
            available: info,
            clearApk: true,
          );
          return info;
      }
    } catch (e) {
      state = state.copyWith(
        phase: UpdateFlowPhase.error,
        errorMessage: e.toString(),
      );
      return null;
    }
  }

  Future<void> downloadAndInstall() async {
    final info = state.available;
    if (info == null) return;

    state = state.copyWith(
      phase: UpdateFlowPhase.downloading,
      progress: 0,
      clearError: true,
    );

    try {
      final file = await _updater.download(
        info,
        onProgress: (received, total) {
          if (total != null && total > 0) {
            state = state.copyWith(progress: received / total);
          }
        },
      );
      state = state.copyWith(
        phase: UpdateFlowPhase.readyToInstall,
        downloadedApk: file,
        progress: 1,
      );
      await _updater.install(file);
    } on InstallPermissionRequiredException {
      state = state.copyWith(
        phase: UpdateFlowPhase.error,
        errorMessage: 'Allow installs from this app in Settings, then try again.',
      );
    } catch (e) {
      state = state.copyWith(
        phase: UpdateFlowPhase.error,
        errorMessage: e.toString(),
      );
    }
  }
}

final updateControllerProvider =
    StateNotifierProvider<UpdateController, UpdateUiState>((ref) {
  return UpdateController(ref.watch(appUpdaterProvider));
});
