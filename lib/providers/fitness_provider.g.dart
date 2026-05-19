// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fitness_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$weightHistoryHash() => r'10cd115cf7467ca50e29bc34a9b9ab03b5ce4d73';

/// See also [weightHistory].
@ProviderFor(weightHistory)
final weightHistoryProvider = AutoDisposeProvider<List<double>>.internal(
  weightHistory,
  name: r'weightHistoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$weightHistoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef WeightHistoryRef = AutoDisposeProviderRef<List<double>>;
String _$fitnessNotifierHash() => r'2e880f523ed31873175cd30549a599d7647206b2';

/// See also [FitnessNotifier].
@ProviderFor(FitnessNotifier)
final fitnessNotifierProvider =
    AutoDisposeNotifierProvider<FitnessNotifier, void>.internal(
  FitnessNotifier.new,
  name: r'fitnessNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$fitnessNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$FitnessNotifier = AutoDisposeNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
