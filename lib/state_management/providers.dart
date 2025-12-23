import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_app/Firebase/auth_services.dart';

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final authServicesProvider = Provider<AuthServices>((ref) {
  final auth = ref.watch(firebaseAuthProvider);
  return AuthServices(auth);
});
