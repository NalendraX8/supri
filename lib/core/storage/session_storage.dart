import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

/// Data class representing cashier session details.
class SessionData {
  final String? siteName;
  final String? sessionId;
  final String? email;
  final String? fullName;
  final bool isLoggedIn;

  SessionData({
    this.siteName,
    this.sessionId,
    this.email,
    this.fullName,
    this.isLoggedIn = false,
  });

  factory SessionData.fromJson(Map<String, dynamic> json) {
    return SessionData(
      siteName: json['site_name'] as String?,
      sessionId: json['session_id'] as String?,
      email: json['email'] as String?,
      fullName: json['full_name'] as String?,
      isLoggedIn: json['is_logged_in'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'site_name': siteName,
      'session_id': sessionId,
      'email': email,
      'full_name': fullName,
      'is_logged_in': isLoggedIn,
    };
  }
}

/// Dynamic session management utilizing asynchronous JSON File I/O.
class SessionStorage {
  Future<File> _getLocalFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/session.json');
  }

  /// Load current active session.
  Future<SessionData> getSession() async {
    try {
      final file = await _getLocalFile();
      if (!await file.exists()) {
        return SessionData();
      }
      final contents = await file.readAsString();
      final Map<String, dynamic> jsonMap = json.decode(contents);
      return SessionData.fromJson(jsonMap);
    } catch (_) {
      return SessionData();
    }
  }

  /// Write session parameters to local storage.
  Future<void> saveSession(SessionData data) async {
    try {
      final file = await _getLocalFile();
      await file.writeAsString(json.encode(data.toJson()));
    } catch (_) {
      // Ignored
    }
  }

  /// Wipe session parameters (Logout).
  Future<void> clearSession() async {
    try {
      final file = await _getLocalFile();
      if (await file.exists()) {
        await file.delete();
      }
    } catch (_) {
      // Ignored
    }
  }
}
