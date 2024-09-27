class User{
  final String email;
  final String name;
  final String? password;
  final String? imgPath;
  final String? photoUrl;
  final int totalCash;
  final Map<String, dynamic>? savingList;

  User({
    required this.email,
    required this.name,
    required this.totalCash,
    this.password,
    this.imgPath,
    this.savingList,
    this.photoUrl
});


}