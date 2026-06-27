class UserProfile {
  final String id;
  final String? fullName;
  final String? username;
  final String? nim;
  final int semester;
  final double ipk;
  final int sks;
  final String jurusan;
  final int angkatan;
  final String? avatarUrl;

  UserProfile({
    required this.id,
    this.fullName,
    this.username,
    this.nim,
    this.semester = 1,
    this.ipk = 0.00,
    this.sks = 0,
    this.jurusan = 'Teknik Informatika',
    this.angkatan = 2024,
    this.avatarUrl,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] ?? '',
      fullName: json['full_name'],
      username: json['username'],
      nim: json['nim'],
      semester: json['semester'] ?? 1,
      ipk: (json['ipk'] ?? 0.00).toDouble(),
      sks: json['sks'] ?? 0,
      jurusan: json['jurusan'] ?? 'Teknik Informatika',
      angkatan: json['angkatan'] ?? 2024,
      avatarUrl: json['avatar_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'full_name': fullName,
      'username': username,
      'nim': nim,
      'semester': semester,
      'ipk': ipk,
      'sks': sks,
      'jurusan': jurusan,
      'angkatan': angkatan,
      'avatar_url': avatarUrl,
    };
  }

  UserProfile copyWith({
    String? fullName,
    String? username,
    String? nim,
    int? semester,
    double? ipk,
    int? sks,
    String? jurusan,
    int? angkatan,
    String? avatarUrl,
  }) {
    return UserProfile(
      id: id,
      fullName: fullName ?? this.fullName,
      username: username ?? this.username,
      nim: nim ?? this.nim,
      semester: semester ?? this.semester,
      ipk: ipk ?? this.ipk,
      sks: sks ?? this.sks,
      jurusan: jurusan ?? this.jurusan,
      angkatan: angkatan ?? this.angkatan,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }
}