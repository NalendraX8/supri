/// Application-wide constants
class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'Supri';
  static const String appVersion = '1.0.0';

  // API
  static const int apiTimeoutSeconds = 30;

  // Pagination
  static const int defaultPageSize = 20;

  // Animation Durations (milliseconds)
  static const int shortAnimationDuration = 200;
  static const int mediumAnimationDuration = 400;
  static const int longAnimationDuration = 600;

  // Cache
  static const int cacheValidityHours = 24;

  // Assets
  static const String logoBlack = 'assets/images/supri_logo_black.jpeg';
  static const String logoBlackLandscape = 'assets/images/supri_logo_black_landscape.jpeg';
  static const String logoWhite = 'assets/images/supri_logo_white.jpeg';
  static const String logoWhiteTall = 'assets/images/supri_logo_white_tall.jpeg';
}
