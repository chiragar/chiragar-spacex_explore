import 'package:equatable/equatable.dart';

class CompanyInfo extends Equatable {
  final String name;
  final String founder;
  final int foundedYear;
  final int employees;
  final int vehicles;
  final int launchSites;
  final int testSites;
  final String ceo;
  final String cto;
  final String coo;
  final String ctoPropulsion;
  final int valuation;
  final CompanyHeadquarters headquarters;
  final String summary;

  const CompanyInfo({
    required this.name,
    required this.founder,
    required this.foundedYear,
    required this.employees,
    required this.vehicles,
    required this.launchSites,
    required this.testSites,
    required this.ceo,
    required this.cto,
    required this.coo,
    required this.ctoPropulsion,
    required this.valuation,
    required this.headquarters,
    required this.summary,
  });

  @override
  List<Object?> get props => [
    name, founder, foundedYear, employees, vehicles, launchSites,
    testSites, ceo, cto, coo, ctoPropulsion, valuation, headquarters, summary
  ];
}

class CompanyHeadquarters extends Equatable {
  final String address;
  final String city;
  final String state;

  const CompanyHeadquarters({
    required this.address,
    required this.city,
    required this.state,
  });

  @override
  List<Object?> get props => [address, city, state];

  @override
  String toString() => '$address, $city, $state';
}