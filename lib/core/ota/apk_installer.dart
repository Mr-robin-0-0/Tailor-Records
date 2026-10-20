import 'dart:io';

import 'package:flutter/services.dart';

class ApkInstaller {
  ApkInstaller._();

  static const _channel = MethodChannel('com.example.tailor_records/apk_installer');

  static Future<bool> canRequestPackageInstalls() async {
    if (!Platform.isAndroid) return false;
    final allowed = await _channel.invokeMethod<bool>('canRequestPackageInstalls');
    return allowed ?? false;
  }

  static Future<void> openUnknownSourcesSettings() async {
    if (!Platform.isAndroid) return;
    await _channel.invokeMethod<void>('openUnknownSourcesSettings');
  }

  static Future<void> installApk(String path) async {
    if (!Platform.isAndroid) {
      throw UnsupportedError('APK install is only supported on Android');
    }
    await _channel.invokeMethod<void>('installApk', {'path': path});
  }
}
