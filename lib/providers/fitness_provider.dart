import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../shared/services/hive_service.dart';

part 'fitness_provider.g.dart';

@riverpod
class FitnessNotifier extends _$FitnessNotifier {
  @override
  void build() {}

  List<Map<String, double>> getWeightHistory() {
    final logs = HiveService.dailyLogBox.values.toList();
    logs.sort((a, b) => a.date.compareTo(b.date));
    
    final now = DateTime.now();
    final eightWeeksAgo = now.subtract(const Duration(days: 56));
    
    return logs
        .where((l) => l.date.isAfter(eightWeeksAgo) && l.workout?.weight != null)
        .map((l) => {
              'daysAgo': now.difference(l.date).inDays.toDouble(),
              'weight': l.workout!.weight!,
              'waist': l.workout!.waist ?? 0.0,
            })
        .toList();
  }
}

@riverpod
List<double> weightHistory(WeightHistoryRef ref) {
  final logs = HiveService.dailyLogBox.values.toList();
  logs.sort((a, b) => a.date.compareTo(b.date));
  
  final now = DateTime.now();
  final eightWeeksAgo = now.subtract(const Duration(days: 56));
  
  final history = logs
      .where((l) => l.date.isAfter(eightWeeksAgo) && l.workout?.weight != null)
      .map((l) => l.workout!.weight!)
      .toList();
      
  return history;
}
