import 'dart:convert';

class WorkHour {
  int? id;
  String? day;
  String? hoursFrom;
  String? hoursTo;

  WorkHour({this.id, this.day, this.hoursFrom, this.hoursTo});

  factory WorkHour.fromMap(Map<String, dynamic> data) => WorkHour(
        id: data['id'] as int?,
        day: data['day'] as String?,
        hoursFrom: data['hours_from'] as String?,
        hoursTo: data['hours_to'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'day': day,
        'hours_from': hoursFrom,
        'hours_to': hoursTo,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [WorkHour].
  factory WorkHour.fromJson(String data) {
    return WorkHour.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [WorkHour] to a JSON string.
  String toJson() => json.encode(toMap());
}
