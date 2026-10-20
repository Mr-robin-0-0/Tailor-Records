import 'dart:io';

sealed class UpdateCheck {
  const UpdateCheck();
}

class UpdateNone extends UpdateCheck {
  const UpdateNone();
}

class UpdateAvailable extends UpdateCheck {
  const UpdateAvailable(this.info);

  final UpdateInfo info;
}

class UpdateInfo {
  const UpdateInfo({
    required this.versionName,
    required this.versionCode,
    required this.notes,
    required this.apkUrl,
  });

  final String versionName;
  final int versionCode;
  final String notes;
  final String apkUrl;
}

typedef DownloadProgress = void Function(int received, int? total);

abstract class AppUpdater {
  Future<UpdateCheck> check();

  Future<File> download(
    UpdateInfo info, {
    DownloadProgress? onProgress,
  });

  Future<void> install(File apk);
}
