import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../shared/services/hive_service.dart';
import '../models/routine_block.dart';
import '../core/constants/routine_data.dart';

part 'settings_provider.g.dart';

@riverpod
class SettingsNotifier extends _$SettingsNotifier {
  @override
  Map<String, dynamic> build() {
    final customBlocks = HiveService.getRoutineBlocks();
    
    return {
      'notificationsEnabled': HiveService.getSetting('notificationsEnabled', defaultValue: true),
      'vibrationEnabled': HiveService.getSetting('vibrationEnabled', defaultValue: true),
      'userName': HiveService.getSetting('userName', defaultValue: 'CSP'),
      'routineBlocks': customBlocks.isEmpty ? RoutineData.defaultBlocks : customBlocks,
    };
  }

  Future<void> updateSetting(String key, dynamic value) async {
    await HiveService.saveSetting(key, value);
    state = {...state, key: value};
  }

  Future<void> updateRoutineBlock(RoutineBlock updatedBlock) async {
    final List<RoutineBlock> blocks = List.from(state['routineBlocks']);
    final index = blocks.indexWhere((b) => b.blockId == updatedBlock.blockId);
    
    if (index != -1) {
      blocks[index] = updatedBlock;
      await HiveService.saveRoutineBlocks(blocks);
      state = {...state, 'routineBlocks': blocks};
    }
  }
}
