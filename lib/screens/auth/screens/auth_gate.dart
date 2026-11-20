import "package:android_dev/screens/auth/providers/auth_providers.dart";
import "package:android_dev/screens/auth/screens/login_screen.dart";
import "package:android_dev/screens/main_screen.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:material_ui/material_ui.dart";

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authStateProvider);

    return auth.when(
      loading: () => const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Could not start the app"),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => ref.invalidate(authStateProvider),
                child: const Text("Retry"),
              ),
            ],
          ),
        ),
      ),
      data: (state) {
        if (state.session == null) return const LoginScreen();
        return const MainScreen();
      },
    );
  }
}
