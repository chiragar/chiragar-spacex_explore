import 'package:chiragar_spacex_explore/domain/entities/company_info.dart';

class CompanyInfoModel extends CompanyInfo {
  const CompanyInfoModel({
    required super.name,
    required super.founder,
    required super.foundedYear,
    required super.employees,
    required super.vehicles,
    required super.launchSites,
    required super.testSites,
    required super.ceo,
    required super.cto,
    required super.coo,
    required super.ctoPropulsion,
    required super.valuation,
    required super.headquarters,
    required super.summary,
  });

  factory CompanyInfoModel.fromJson(Map<String, dynamic> json) {
    return CompanyInfoModel(
      name: json['name'] ?? 'N/A',
      founder: json['founder'] ?? 'N/A',
      foundedYear: json['founded'] ?? 0,
      employees: json['employees'] ?? 0,
      vehicles: json['vehicles'] ?? 0,
      launchSites: json['launch_sites'] ?? 0,
      testSites: json['test_sites'] ?? 0,
      ceo: json['ceo'] ?? 'N/A',
      cto: json['cto'] ?? 'N/A',
      coo: json['coo'] ?? 'N/A',
      ctoPropulsion: json['cto_propulsion'] ?? 'N/A',
      valuation: json['valuation'] ?? 0,
      headquarters: CompanyHeadquartersModel.fromJson(json['headquarters'] ?? {}),
      summary: json['summary'] ?? 'No summary available.',
    );
  }
}

class CompanyHeadquartersModel extends CompanyHeadquarters {
  const CompanyHeadquartersModel({
    required super.address,
    required super.city,
    required super.state,
  });

  factory CompanyHeadquartersModel.fromJson(Map<String, dynamic> json) {
    return CompanyHeadquartersModel(
      address: json['address'] ?? 'N/A',
      city: json['city'] ?? 'N/A',
      state: json['state'] ?? 'N/A',
    );
  }
}