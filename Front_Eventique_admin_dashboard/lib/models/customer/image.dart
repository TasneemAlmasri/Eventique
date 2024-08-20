import 'dart:convert';

class Image {
  int? id;
  String? modelType;
  int? modelId;
  String? url;

  Image({this.id, this.modelType, this.modelId, this.url});

  factory Image.fromMap(Map<String, dynamic> data) => Image(
        id: data['id'] as int?,
        modelType: data['model_type'] as String?,
        modelId: data['model_id'] as int?,
        url: data['url'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'model_type': modelType,
        'model_id': modelId,
        'url': url,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Image].
  factory Image.fromJson(String data) {
    return Image.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Image] to a JSON string.
  String toJson() => json.encode(toMap());
}
