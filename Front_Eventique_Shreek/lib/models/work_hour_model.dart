class WorkHour {
  String? day;
  String? hoursFrom;
  String? hoursTo;

  WorkHour(
      {this.day,
      this.hoursFrom,
      this.hoursTo,
      String? openingTime,
      String? closingTime});

  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'hours_from': hoursFrom,
      'hours_to': hoursTo,
    };
  }
}
