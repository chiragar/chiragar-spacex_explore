import 'package:equatable/equatable.dart';

class Rocket extends Equatable {
  final String id;
  final String name;
  final String type;
  final bool active;
  final int stages;
  final int costPerLaunch;
  final int successRatePct;
  final String firstFlight; // Could be DateTime if you parse it
  final String country;
  final String company;
  final String description;
  final List<String> flickrImages;
  final RocketDimension? height;
  final RocketDimension? diameter;
  final RocketMass? mass;
  // Potentially add more specific details like engines, payload capacities etc.

  const Rocket({
    required this.id,
    required this.name,
    required this.type,
    required this.active,
    required this.stages,
    required this.costPerLaunch,
    required this.successRatePct,
    required this.firstFlight,
    required this.country,
    required this.company,
    required this.description,
    this.flickrImages = const [],
    this.height,
    this.diameter,
    this.mass,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    type,
    active,
    stages,
    costPerLaunch,
    successRatePct,
    firstFlight,
    country,
    company,
    description,
    flickrImages,
    height,
    diameter,
    mass,
  ];
}

class RocketDimension extends Equatable {
  final double? meters;
  final double? feet;

  const RocketDimension({this.meters, this.feet});

  factory RocketDimension.fromJson(Map<String, dynamic> json) {
    return RocketDimension(
      meters: (json['meters'] as num?)?.toDouble(),
      feet: (json['feet'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    'meters': meters,
    'feet': feet,
  };


  @override
  List<Object?> get props => [meters, feet];
}

class RocketMass extends Equatable {
  final int? kg;
  final int? lb;

  const RocketMass({this.kg, this.lb});

  factory RocketMass.fromJson(Map<String, dynamic> json) {
    return RocketMass(
      kg: json['kg'] as int?,
      lb: json['lb'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
    'kg': kg,
    'lb': lb,
  };

  @override
  List<Object?> get props => [kg, lb];
}