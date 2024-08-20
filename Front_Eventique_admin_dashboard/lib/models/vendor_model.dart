class Vendor {
  final int id;
  final String logoUrl;
  final String companyName;
  final String email;
  final String phoneNumber;
  final String firstName;
  final String lastName;
  final String registrationNumber;
  final String location;
  final String city;
  final String country;
  final String description;
  final List<String> categoryIds;
  final List<String> eventTypeIds;
  final List<Map<String, String>> workHours;

  Vendor({
    required this.id,
    required this.logoUrl,
    required this.companyName,
    required this.email,
    required this.phoneNumber,
    required this.firstName,
    required this.lastName,
    required this.registrationNumber,
    required this.location,
    required this.city,
    required this.country,
    required this.description,
    required this.categoryIds,
    required this.eventTypeIds,
    required this.workHours,
  });
}
