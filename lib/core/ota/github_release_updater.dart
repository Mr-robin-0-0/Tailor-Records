import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';

import 'apk_installer.dart';
import 'app_updater.dart';

class GitHubReleaseUpdater implements AppUpdater {
  GitHubReleaseUpdater({
    this.repoOwner = 'Mr-robin-0-0',
    this.repoName = 'Tailor-Records',
    http.Client? client,
  }) : _client = client ?? http.Client();

  final String repoOwner;
  final String repoName;
  final http.Client _client;

  static const _otaAssetName = 'ota.json';
  static const _apkAssetName = 'TailorRecords.apk';

  Uri get _latestReleaseUri => Uri.parse(
        'https://api.github.com/repos/$repoOwner/$repoName/releases/latest',
      );

  @override
  Future<UpdateCheck> check() async {
    final packageInfo = await PackageInfo.fromPlatform();
    final currentCode = int.tryParse(packageInfo.buildNumber) ?? 0;

    final response = await _client.get(
      _latestReleaseUri,
      headers: const {'Accept': 'application/vnd.github+json'},
    );
    if (response.statusCode == 404) {
      return const UpdateNone();
    }
    if (response.statusCode != 200) {
      throw Exception('Update check failed (${response.statusCode})');
    }

    final release = jsonDecode(response.body) as Map<String, dynamic>;
    final assets = (release['assets'] as List<dynamic>? ?? [])
        .cast<Map<String, dynamic>>();

    final otaAsset = assets.where((a) => a['name'] == _otaAssetName).firstOrNull;
    final apkAsset = assets.where((a) => a['name'] == _apkAssetName).firstOrNull;

    UpdateInfo? info;
    if (otaAsset != null) {
      final otaUrl = otaAsset['browser_download_url'] as String?;
      if (otaUrl != null) {
        final otaResponse = await _client.get(Uri.parse(otaUrl));
        if (otaResponse.statusCode == 200) {
          final ota = jsonDecode(otaResponse.body) as Map<String, dynamic>;
          final apkName = ota['apk'] as String? ?? _apkAssetName;
          final apkUrl = apkAsset?['browser_download_url'] as String? ??
              assets
                  .where((a) => a['name'] == apkName)
                  .map((a) => a['browser_download_url'] as String?)
                  .firstWhere((u) => u != null, orElse: () => null);
          if (apkUrl != null) {
            info = UpdateInfo(
              versionName: ota['versionName'] as String? ?? 'unknown',
              versionCode: (ota['versionCode'] as num?)?.toInt() ?? 0,
              notes: ota['notes'] as String? ?? '',
              apkUrl: apkUrl,
            );
          }
        }
      }
    }

    if (info == null) {
      return const UpdateNone();
    }

    if (info.versionCode <= currentCode) {
      return const UpdateNone();
    }

    return UpdateAvailable(info);
  }

  @override
  Future<File> download(
    UpdateInfo info, {
    DownloadProgress? onProgress,
  }) async {
    final request = http.Request('GET', Uri.parse(info.apkUrl));
    final response = await _client.send(request);
    if (response.statusCode != 200) {
      throw Exception('Download failed (${response.statusCode})');
    }

    final dir = await _otaDirectory();
    final file = File('${dir.path}/$_apkAssetName');
    if (await file.exists()) {
      await file.delete();
    }

    final sink = file.openWrite();
    var received = 0;
    final total = response.contentLength;

    await for (final chunk in response.stream) {
      received += chunk.length;
      sink.add(chunk);
      onProgress?.call(received, total);
    }
    await sink.close();
    return file;
  }

  @override
  Future<void> install(File apk) async {
    if (!await ApkInstaller.canRequestPackageInstalls()) {
      await ApkInstaller.openUnknownSourcesSettings();
      throw const InstallPermissionRequiredException();
    }
    await ApkInstaller.installApk(apk.path);
  }

  Future<Directory> _otaDirectory() async {
    final base = await getApplicationSupportDirectory();
    final dir = Directory('${base.path}/ota');
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }
}

class InstallPermissionRequiredException implements Exception {
  const InstallPermissionRequiredException();
}

extension _FirstOrNull<E> on Iterable<E> {
  E? get firstOrNull {
    final iterator = this.iterator;
    if (!iterator.moveNext()) return null;
    return iterator.current;
  }
}
