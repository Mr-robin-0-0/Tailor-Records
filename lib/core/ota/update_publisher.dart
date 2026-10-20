/// Shown in update dialogs instead of raw GitHub release notes.
class UpdatePublisher {
  static const name = 'SilyCo';
  static const email = 'sillyco2025@gmail.com';

  static String availableMessage(String versionName) {
    return 'Version $versionName is available.\n\n$name\n$email';
  }
}
