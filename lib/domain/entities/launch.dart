import 'package:equatable/equatable.dart';
import 'rocket.dart'; // Create this as well

class Launch extends Equatable {
  final String id;
  final String missionName;
  final DateTime launchDateUtc;
  final bool? launchSuccess;
  final String? details;
  final String? missionPatchSmall;
  final String? missionPatch;
  final String? articleLink;
  final String? videoLink;
  final List<String> flickrImages;
  final String rocketName;
  final String rocketType;
  final Rocket? rocketDetails; // If you fetch full rocket details with launch
  final String? launchSiteName;

  const Launch({
    required this.id,
    required this.missionName,
    required this.launchDateUtc,
    this.launchSuccess,
    this.details,
    this.missionPatchSmall,
    this.missionPatch,
    this.articleLink,
    this.videoLink,
    this.flickrImages = const [],
    required this.rocketName,
    required this.rocketType,
    this.rocketDetails,
    this.launchSiteName,
  });

  @override
  List<Object?> get props => [
    id,
    missionName,
    launchDateUtc,
    launchSuccess,
    details,
    missionPatchSmall,
    missionPatch,
    articleLink,
    videoLink,
    flickrImages,
    rocketName,
    rocketType,
    rocketDetails,
    launchSiteName,
  ];
}