//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class LiteTimeBucketAssetResponseDto {
  /// Returns a new [LiteTimeBucketAssetResponseDto] instance.
  LiteTimeBucketAssetResponseDto({
    required this.height,
    required this.id,
    required this.isArchived,
    required this.isFavorite,
    required this.isTrashed,
    required this.localDateTime,
    this.thumbhash,
    required this.width,
  });

  int height;

  String id;

  bool isArchived;

  bool isFavorite;

  bool isTrashed;

  DateTime localDateTime;

  String? thumbhash;

  int width;

  @override
  bool operator ==(Object other) => identical(this, other) || other is LiteTimeBucketAssetResponseDto &&
    other.height == height &&
    other.id == id &&
    other.isArchived == isArchived &&
    other.isFavorite == isFavorite &&
    other.isTrashed == isTrashed &&
    other.localDateTime == localDateTime &&
    other.thumbhash == thumbhash &&
    other.width == width;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (height.hashCode) +
    (id.hashCode) +
    (isArchived.hashCode) +
    (isFavorite.hashCode) +
    (isTrashed.hashCode) +
    (localDateTime.hashCode) +
    (thumbhash == null ? 0 : thumbhash!.hashCode) +
    (width.hashCode);

  @override
  String toString() => 'LiteTimeBucketAssetResponseDto[height=$height, id=$id, isArchived=$isArchived, isFavorite=$isFavorite, isTrashed=$isTrashed, localDateTime=$localDateTime, thumbhash=$thumbhash, width=$width]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'height'] = this.height;
      json[r'id'] = this.id;
      json[r'isArchived'] = this.isArchived;
      json[r'isFavorite'] = this.isFavorite;
      json[r'isTrashed'] = this.isTrashed;
      json[r'localDateTime'] = this.localDateTime.toUtc().toIso8601String();
    if (this.thumbhash != null) {
      json[r'thumbhash'] = this.thumbhash;
    } else {
    //  json[r'thumbhash'] = null;
    }
      json[r'width'] = this.width;
    return json;
  }

  /// Returns a new [LiteTimeBucketAssetResponseDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static LiteTimeBucketAssetResponseDto? fromJson(dynamic value) {
    upgradeDto(value, "LiteTimeBucketAssetResponseDto");
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      return LiteTimeBucketAssetResponseDto(
        height: mapValueOfType<int>(json, r'height')!,
        id: mapValueOfType<String>(json, r'id')!,
        isArchived: mapValueOfType<bool>(json, r'isArchived')!,
        isFavorite: mapValueOfType<bool>(json, r'isFavorite')!,
        isTrashed: mapValueOfType<bool>(json, r'isTrashed')!,
        localDateTime: mapDateTime(json, r'localDateTime', r'')!,
        thumbhash: mapValueOfType<String>(json, r'thumbhash'),
        width: mapValueOfType<int>(json, r'width')!,
      );
    }
    return null;
  }

  static List<LiteTimeBucketAssetResponseDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <LiteTimeBucketAssetResponseDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = LiteTimeBucketAssetResponseDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, LiteTimeBucketAssetResponseDto> mapFromJson(dynamic json) {
    final map = <String, LiteTimeBucketAssetResponseDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = LiteTimeBucketAssetResponseDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of LiteTimeBucketAssetResponseDto-objects as value to a dart map
  static Map<String, List<LiteTimeBucketAssetResponseDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<LiteTimeBucketAssetResponseDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = LiteTimeBucketAssetResponseDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'height',
    'id',
    'isArchived',
    'isFavorite',
    'isTrashed',
    'localDateTime',
    'width',
  };
}

