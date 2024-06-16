class UserModel {
  final String uid;
  final String name;
  final String platform;
  final String token;
  final String createdAt;

  const UserModel ({
    required this.uid,
    required this.name,
    required this.platform,
    required this.token,
    required this.createdAt,
});

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
      uid: json['uid'],
      name: json['name'],
      platform: json['platform'],
      token: json['token'],
      createdAt: json['createdAt']
  );

  Map<String, dynamic> toJson() => {
    'uid': uid,
    'name': name,
    'platform': platform,
    'token': token,
    'createdAt': createdAt

  };
}