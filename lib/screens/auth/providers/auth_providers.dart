import "package:android_dev/screens/auth/services/auth_services.dart";
import "package:android_dev/screens/home_screen/models/user_model.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:supabase_flutter/supabase_flutter.dart";

final authServicesProvider = Provider<AuthServices>((ref) {
  return AuthServices();
});

final authStateProvider = StreamProvider<AuthState>((ref) {
  return ref.watch(authServicesProvider).authStateChanges;
});

final currentUserProvider = FutureProvider<UserModel?>((ref) async {
  final state = await ref.watch(authStateProvider.future);
  if (state.session == null) return null;
  return ref.watch(authServicesProvider).fetchCurrentUser();
});
