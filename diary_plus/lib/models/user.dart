class AppUser {
  late String userName;
  late String emailAddress;

  AppUser({required this.userName, required this.emailAddress});

  Map<String, dynamic> toMap() {
    return {
      'name': userName,
      'email': emailAddress,
    };
  }

  AppUser.fromMap(Map<String, dynamic> userMap)
      : userName = userMap["name"],
        emailAddress = userMap["email"];
}
