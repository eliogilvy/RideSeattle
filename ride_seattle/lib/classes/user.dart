class User {
  int? userId;
  String? firstName;
  String? lastName;
  String? email;
  List<String>? favoriteRoutes;

  User({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.favoriteRoutes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': userId,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'favoriteRoutes': favoriteRoutes
    };
  }

  User.fromMap(Map<dynamic, dynamic> map) {
    userId = map['id'];
    firstName = map['firstName'];
    lastName = map['lastName'];
    email = map['email'];
    favoriteRoutes = map['favoriteRoutes'];
  }
}
