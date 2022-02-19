import 'package:flutter_riverpod/flutter_riverpod.dart';

final jobStartGuideOptionProvider = StateProvider<String>((ref) {
  return '';
});

final jobStartSavefileOptionProvider = StateProvider<String>((ref) {
  return '';
});

final jobStartGroupOptionProvider = StateProvider<String>((ref) {
  return '';
});

final beamPositionSetProvider = StateProvider<String>((ref) {
  return '0 0 0';
});

final setVariableProvider = StateProvider<int>((ref) {
  return 1;
});

final setVariableValueProvider = StateProvider<String>((ref) {
  return '0';
});

final getVariableProvider = StateProvider<int>((ref) {
  return 1;
});

final helpSpecialCommandProvider = StateProvider<String>((ref) {
  return 'No command';
});
