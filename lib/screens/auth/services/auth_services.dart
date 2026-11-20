import "package:android_dev/screens/home_screen/models/user_model.dart";
import "package:supabase_flutter/supabase_flutter.dart";

class AuthServices {
  SupabaseClient get _client => Supabase.instance.client;

  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;

  Future<UserModel?> fetchCurrentUser() async {
    final authUser = _client.auth.currentUser;
    if (authUser == null) return null;

    final row = await _client
        .from("users")
        .select("id, username, display_name, avatar_url, bio")
        .eq("auth_uid", authUser.id)
        .single();

    return UserModel(
      id: (row["id"] as num).toInt(),
      username: row["username"] as String? ?? "",
      displayName: row["display_name"] as String? ?? "",
      avatarPath: row["avatar_url"] as String? ?? "assets/images/post.jpg",
      bio: row["bio"] as String? ?? "",
    );
  }

  Future<bool> usernameExists(String username) async {
    final rows = await _client
        .from("users")
        .select("id")
        .eq("username", username)
        .limit(1);

    return rows.isNotEmpty;
  }

  Future<AuthResponse> signUp({
    required String username,
    required String displayName,
    required String email,
    required String password,
  }) {
    return _client.auth.signUp(
      email: email,
      password: password,
      data: {
        "username": username,
        "display_name": displayName,
      },
    );
  }

  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) {
    return _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() {
    return _client.auth.signOut();
  }
}
