import 'package:chiragar_chiragar_spacex_explore/domain/entities/rocket.dart';

class RocketModel extends Rocket {
  const RocketModel({
    required super.id,
    required super.name,
    required super.type,
    required super.active,
    required super.stages,
    required super.costPerLaunch,
    required super.successRatePct,
    required super.firstFlight,
    required super.country,
    required super.company,
    required super.description,
    super.flickrImages,
    super.height,
    super.diameter,
    super.mass,
  });

  factory RocketModel.fromJson(Map<String, dynamic> json) {
    return RocketModel(
      id: json['id'] ?? 'unknown_rocket_id',
      name: json['name'] ?? 'N/A',
      type: json['type'] ?? 'N/A',
      active: json['active'] ?? false,
      stages: json['stages'] ?? 0,
      costPerLaunch: json['cost_per_launch'] ?? 0,
      successRatePct: json['success_rate_pct'] ?? 0,
      firstFlight: json['first_flight'] ?? 'N/A',
      country: json['country'] ?? 'N/A',
      company: json['company'] ?? 'N/A',
      description: json['description'] ?? 'No description available.',
      flickrImages: List<String>.from(json['flickr_images']?.map((x) => x) ?? []), // This line should already be there and correct
      height: json['height'] != null ? RocketDimension.fromJson(json['height']) : null,
      diameter: json['diameter'] != null ? RocketDimension.fromJson(json['diameter']) : null,
      mass: json['mass'] != null ? RocketMass.fromJson(json['mass']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'active': active,
      'stages': stages,
      'cost_per_launch': costPerLaunch,
      'success_rate_pct': successRatePct,
      'first_flight': firstFlight,
      'country': country,
      'company': company,
      'description': description,
      'flickr_images': flickrImages,
      'height': (height as RocketDimension?)?.toJson(),
      'diameter': (diameter as RocketDimension?)?.toJson(),
      'mass': (mass as RocketMass?)?.toJson(),
    };
  }
}