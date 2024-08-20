class Vendor {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String companyName;
  final String location;
  final String city;
  final String country;
  final String description;
  final String? imageUrl;
  final List<WorkHour> workHours;

  Vendor({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.companyName,
    required this.location,
    required this.city,
    required this.country,
    required this.description,
    required this.imageUrl,
    required this.workHours,
  });
}

class WorkHour {
  final String day;
  final String hoursFrom;
  final String hoursTo;

  WorkHour({
    required this.day,
    required this.hoursFrom,
    required this.hoursTo,
  });
}
