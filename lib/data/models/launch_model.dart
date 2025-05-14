import 'rocket_model.dart';
import 'package:chiragar_chiragar_spacex_explore/domain/entities/launch.dart';

class LaunchModel extends Launch {
  const LaunchModel({
    required super.id,
    required super.missionName,
    required super.launchDateUtc,
    super.launchSuccess,
    super.details,
    super.missionPatchSmall,
    super.missionPatch,
    super.articleLink,
    super.videoLink,
    super.flickrImages,
    required super.rocketName,
    required super.rocketType,
    super.rocketDetails, // This Rocket entity will be from NestedRocketInfo
    super.launchSiteName,
  });

  factory LaunchModel.fromJson(Map<String, dynamic> json) {
    final rocketField = json['rocket']; // This is the LaunchRocket object
    final nestedRocketData = rocketField?['rocket']; // This is the nested Rocket data

    return LaunchModel(
      id: json['id'] ?? 'unknown_id',
      missionName: json['mission_name'] ?? 'N/A',
      launchDateUtc: DateTime.parse(json['launch_date_utc'] ?? DateTime.now().toIso8601String()),
      launchSuccess: json['launch_success'],
      details: json['details'],
      missionPatchSmall: json['links']?['mission_patch_small'],
      missionPatch: json['links']?['mission_patch'],
      articleLink: json['links']?['article_link'],
      videoLink: json['links']?['video_link'],
      flickrImages: List<String>.from(json['links']?['flickr_images']?.map((x) => x) ?? []),
      rocketName: rocketField?['rocket_name'] ?? 'N/A',
      rocketType: rocketField?['rocket_type'] ?? 'N/A',
      // The RocketModel.fromJson will parse the nestedRocketData.
      // Since NestedRocketInfo does not request flickr_images,
      // rocketDetails.flickrImages will be an empty list (the default).
      rocketDetails: nestedRocketData != null ? RocketModel.fromJson(nestedRocketData) : null,
      launchSiteName: json['launch_site']?['site_name_long'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mission_name': missionName,
      // ... other fields
      'rocket': {
        'rocket_name': rocketName,
        'rocket_type': rocketType,
        'rocket': (rocketDetails as RocketModel?)?.toJson(),
      },
      // ...
    };
  }
}