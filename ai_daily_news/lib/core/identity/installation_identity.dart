import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class InstallationIdentity {
  static const storageKey = 'anonymous_installation_id';

  static const _secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  static Future<String> ensure({SharedPreferences? prefs}) async {
    try {
      final existing = await _secureStorage.read(key: storageKey);
      if (existing != null && existing.isNotEmpty) {
        return existing;
      }
    } catch (error, stackTrace) {
      debugPrint('Secure storage read failed: $error\n$stackTrace');
    }

    final fallbackPrefs = prefs ?? await SharedPreferences.getInstance();
    final fallback = fallbackPrefs.getString(storageKey);
    if (fallback != null && fallback.isNotEmpty) {
      return fallback;
    }

    final id = const Uuid().v4();
    try {
      await _secureStorage.write(key: storageKey, value: id);
    } catch (error, stackTrace) {
      debugPrint('Secure storage write failed: $error\n$stackTrace');
      await fallbackPrefs.setString(storageKey, id);
    }
    return id;
  }
}
