class Company {
  final int? id;
  final String firstName;
  final String lastName;
  final int phoneNumber;
  final List<String>? images;
  final String email;
  final String companyName, loaction,country,city;
  

  Company({
    this.id,
    required this.companyName,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.city,
    required this.country,
    required this.email,
    required this.loaction,
    this.images,
  });
}