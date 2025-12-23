import 'package:flutter_riverpod/legacy.dart';

final loginPasswordVisibilityProvider = StateProvider<bool>((ref) {
  return false; // Initially password is hidden (showing dots)
});

final registerPasswordVisiblilityProvider = StateProvider<bool>((ref) {
  return false;
});
final registerConfirmPasswordVisiblilityProvider = StateProvider<bool>((ref) {
  return false;
});
