class UserModel {
  String id;
  String name;
  String? token;

  UserModel({required this.id, required this.name, this.token});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'token': token,
    };
  }
}
