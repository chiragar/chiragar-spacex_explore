import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:chiragar_chiragar_spacex_explore/data/graphql/queries.dart';
import '../../models/company_info_model.dart';
import '../../models/launch_model.dart';
import '../../models/rocket_model.dart';
// Import other models as needed

abstract class SpaceXRemoteDataSource {
  Future<List<LaunchModel>> getPastLaunches({
    int limit = 10,
    int offset = 0,
    String? year,
    bool? launchSuccess,
    String? rocketName,
  });
  Future<LaunchModel> getLaunchDetails(String id);
  Future<List<RocketModel>> getAllRockets();
  Future<RocketModel> getRocketDetails(String id);
Future<CompanyInfoModel> getCompanyInfo();
}

@LazySingleton(as: SpaceXRemoteDataSource)
class SpaceXGraphQLDataSourceImpl implements SpaceXRemoteDataSource {
  final GraphQLClient client;

  SpaceXGraphQLDataSourceImpl(this.client);

  @override
  Future<List<LaunchModel>> getPastLaunches({
    int limit = 10,
    int offset = 0,
    String? year,
    bool? launchSuccess,
    String? rocketName,
  }) async {
    final Map<String, dynamic> findCriteria = {};
    if (year != null && year.isNotEmpty) findCriteria['launch_year'] = year;
    if (launchSuccess != null) findCriteria['launch_success'] = launchSuccess;
    if (rocketName != null && rocketName.isNotEmpty) findCriteria['rocket_name'] = rocketName;


    final options = QueryOptions(
      document: gql(SpaceXQueries.getPastLaunches),
      variables: {
        'limit': limit,
        'offset': offset,
        if (findCriteria.isNotEmpty) 'find': findCriteria,
        'sort': 'launch_date_utc',
        'order': 'desc',
      },
    );
    final result = await client.query(options);

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }

    final List<dynamic> launchesJson = result.data?['launchesPast'] ?? [];
    return launchesJson.map((json) => LaunchModel.fromJson(json)).toList();
  }

  @override
  Future<LaunchModel> getLaunchDetails(String id) async {
    final options = QueryOptions(
      document: gql(SpaceXQueries.getLaunchDetails),
      variables: {'id': id},
    );
    final result = await client.query(options);

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }
    if (result.data?['launch'] == null) {
      throw Exception('Launch not found');
    }
    return LaunchModel.fromJson(result.data!['launch']);
  }

  @override
  Future<List<RocketModel>> getAllRockets() async {
    final options = QueryOptions(document: gql(SpaceXQueries.getAllRockets));
    final result = await client.query(options);

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }
    final List<dynamic> rocketsJson = result.data?['rockets'] ?? [];
    return rocketsJson.map((json) => RocketModel.fromJson(json)).toList();
  }

  @override
  Future<RocketModel> getRocketDetails(String id) async {
    final options = QueryOptions(
      document: gql(SpaceXQueries.getRocketDetails),
      variables: {'id': id},
    );
    final result = await client.query(options);

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }
    if (result.data?['rocket'] == null) {
      throw Exception('Rocket not found');
    }
    return RocketModel.fromJson(result.data!['rocket']);
  }



  @override
  Future<CompanyInfoModel> getCompanyInfo() async {
    final options = QueryOptions(document: gql(SpaceXQueries.getCompanyInfo));
    final result = await client.query(options);

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }
    if (result.data?['company'] == null) {
      throw Exception('Company info not found');
    }
    return CompanyInfoModel.fromJson(result.data!['company']);
  }
}