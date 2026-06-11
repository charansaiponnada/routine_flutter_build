import 'package:flutter/material.dart';

enum HabitType { boolean, counter, duration }

class HabitDefinition {
  final String id;
  final String name;
  final IconData icon;
  final HabitType type;
  final String? unit;
  final double? step;

  const HabitDefinition({
    required this.id,
    required this.name,
    required this.icon,
    required this.type,
    this.unit,
    this.step,
  });
}

class HabitData {
  HabitData._();

  static const List<HabitDefinition> definitions = [
    HabitDefinition(
      id: 'wake_up',
      name: 'Woke by 4:00 AM',
      icon: Icons.wb_sunny_rounded,
      type: HabitType.boolean,
    ),
    HabitDefinition(
      id: 'meditation',
      name: 'Meditation done',
      icon: Icons.self_improvement_rounded,
      type: HabitType.boolean,
    ),
    HabitDefinition(
      id: 'workout',
      name: 'Workout completed',
      icon: Icons.fitness_center_rounded,
      type: HabitType.boolean,
    ),
    HabitDefinition(
      id: 'leetcode',
      name: 'LeetCode problems',
      icon: Icons.code_rounded,
      type: HabitType.counter,
      unit: 'probs',
    ),
    HabitDefinition(
      id: 'gate_hours',
      name: 'Study hours',
      icon: Icons.menu_book_rounded,
      type: HabitType.duration,
      unit: 'hrs',
      step: 0.5,
    ),
    HabitDefinition(
      id: 'water',
      name: 'Water intake',
      icon: Icons.water_drop_rounded,
      type: HabitType.counter,
      unit: 'glasses',
    ),
    HabitDefinition(
      id: 'no_social',
      name: 'No social scroll < 8 AM',
      icon: Icons.phonelink_erase_rounded,
      type: HabitType.boolean,
    ),
    HabitDefinition(
      id: 'discipline',
      name: 'Discipline maintained',
      icon: Icons.shield_rounded,
      type: HabitType.boolean,
    ),
  ];
}
