import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

/// Local storage service for application settings using JSON files.
class SettingsStorage {
  static const String _fileName = 'settings.json';

  Future<File> _getFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/$_fileName');
  }

  /// Read raw settings map.
  Future<Map<String, dynamic>> readSettings() async {
    try {
      final file = await _getFile();
      if (!await file.exists()) {
        return {'mode': 'production'};
      }
      final contents = await file.readAsString();
      return json.decode(contents) as Map<String, dynamic>;
    } catch (_) {
      return {'mode': 'production'};
    }
  }

  /// Save raw settings map.
  Future<void> saveSettings(Map<String, dynamic> settings) async {
    try {
      final file = await _getFile();
      await file.writeAsString(json.encode(settings));
    } catch (_) {}
  }

  /// Get the active mode ('demo' or 'production').
  Future<String> getMode() async {
    final settings = await readSettings();
    return settings['mode'] ?? 'production';
  }

  /// Set the active mode ('demo' or 'production').
  Future<void> setMode(String mode) async {
    final settings = await readSettings();
    settings['mode'] = mode;
    await saveSettings(settings);
  }
}
