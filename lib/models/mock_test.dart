import 'package:hive/hive.dart';

part 'mock_test.g.dart';

/// GATE Mock Test record.
/// Stored in a separate box (mock_tests) as it exists outside the daily routine.
@HiveType(typeId: 5)
class MockTest extends HiveObject {
  @HiveField(0)
  final DateTime date;

  @HiveField(1)
  final double score;

  @HiveField(2)
  final double totalMarks;

  @HiveField(3)
  final String subject; // General or specific

  @HiveField(4)
  final double? percentileEstimate;

  @HiveField(5)
  final String? notes;

  MockTest({
    required this.date,
    required this.score,
    required this.totalMarks,
    required this.subject,
    this.percentileEstimate,
    this.notes,
  });
}
