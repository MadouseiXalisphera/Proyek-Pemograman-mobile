// Model user yang sedang login.
// Saat migrasi Supabase, field bisa ditambah (uid, photoUrl, dll).

class UserModel {
  final String username;
  final String role;        // 'user' | 'kitchen' | 'admin'
  final String? namaMeja;   // hanya terisi untuk role 'user'

  UserModel({
    required this.username,
    required this.role,
    this.namaMeja,
  });

  bool get isPelanggan => role == 'user';

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'role': role,
      'namaMeja': namaMeja,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      username: json['username'] as String,
      role: json['role'] as String,
      namaMeja: json['namaMeja'] as String?,
    );
  }
}
