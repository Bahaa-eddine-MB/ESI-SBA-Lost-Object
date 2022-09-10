class User {
  final String imagPath;
  final String FamilyName;
  final String FirstName;
  final String Email;
  final String Phone;
  final String about;
  final bool isDarkMode;

  const User(
      {required this.Email,
      required this.FamilyName,
      required this.FirstName,
      required this.Phone,
      required this.about,
      required this.imagPath,
      required this.isDarkMode});
}
