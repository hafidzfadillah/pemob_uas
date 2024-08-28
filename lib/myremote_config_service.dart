import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfigService {
  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  Future<void> initialize() async {
    try {
      print('config setting');
      await _remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: const Duration(seconds: 30),
      ));
      print('fetch and activate');
      await _remoteConfig.fetchAndActivate();
      print('remote config done');
    } catch (e, s) {
      print('Error initializing remote config: $e');
      print(s);
    }
  }

  String getString(String key) {
    return _remoteConfig.getString(key);
  }

  int getInt(String key) {
    return _remoteConfig.getInt(key);
  }

  bool getBool(String key) {
    return _remoteConfig.getBool(key);
  }

  double getDouble(String key) {
    return _remoteConfig.getDouble(key);
  }
}
