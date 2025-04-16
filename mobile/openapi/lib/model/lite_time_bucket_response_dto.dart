//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class LiteTimeBucketResponseDto {
  /// Returns a new [LiteTimeBucketResponseDto] instance.
  LiteTimeBucketResponseDto({
    required this.hasNextPage,
    this.liteAssets = const [],
  });

  bool hasNextPage;

  List<LiteTimeBucketAssetResponseDto> liteAssets;

  @override
  bool operator ==(Object other) => identical(this, other) || other is LiteTimeBucketResponseDto &&
    other.hasNextPage == hasNextPage &&
    _deepEquality.equals(other.liteAssets, liteAssets);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (hasNextPage.hashCode) +
    (liteAssets.hashCode);

  @override
  String toString() => 'LiteTimeBucketResponseDto[hasNextPage=$hasNextPage, liteAssets=$liteAssets]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'hasNextPage'] = this.hasNextPage;
      json[r'liteAssets'] = this.liteAssets;
    return json;
  }

  /// Returns a new [LiteTimeBucketResponseDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static LiteTimeBucketResponseDto? fromJson(dynamic value) {
    upgradeDto(value, "LiteTimeBucketResponseDto");
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      return LiteTimeBucketResponseDto(
        hasNextPage: mapValueOfType<bool>(json, r'hasNextPage')!,
        liteAssets: LiteTimeBucketAssetResponseDto.listFromJson(json[r'liteAssets']),
      );
    }
    return null;
  }

  static List<LiteTimeBucketResponseDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <LiteTimeBucketResponseDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = LiteTimeBucketResponseDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, LiteTimeBucketResponseDto> mapFromJson(dynamic json) {
    final map = <String, LiteTimeBucketResponseDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = LiteTimeBucketResponseDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of LiteTimeBucketResponseDto-objects as value to a dart map
  static Map<String, List<LiteTimeBucketResponseDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<LiteTimeBucketResponseDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = LiteTimeBucketResponseDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'hasNextPage',
    'liteAssets',
  };
}

