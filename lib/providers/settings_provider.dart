import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../shared/services/hive_service.dart';

part 'settings_provider.g.dart';

@riverpod
class SettingsNotifier extends _$SettingsNotifier {
  @override
  Map<String, dynamic> build() {
    return {
      'notificationsEnabled': HiveService.getSetting('notificationsEnabled', defaultValue: true),
      'vibrationEnabled': HiveService.getSetting('vibrationEnabled', defaultValue: true),
      'userName': HiveService.getSetting('userName', defaultValue: 'CSP'),
    };
  }

  Future<void> updateSetting(String key, dynamic value) async {
    await HiveService.saveSetting(key, value);
    state = {...state, key: value};
  }
}
