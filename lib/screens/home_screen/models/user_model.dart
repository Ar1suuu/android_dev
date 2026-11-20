class UserModel {
  final int id;
  final String username;
  final String displayName;
  final String avatarPath;
  final String bio;

  const UserModel({
    required this.id,
    required this.username,
    required this.displayName,
    required this.avatarPath,
    required this.bio,
  });
}
