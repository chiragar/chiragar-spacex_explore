import 'package:chiragar_chiragar_spacex_explore/core/utils/either.dart';
import 'package:chiragar_chiragar_spacex_explore/core/utils/failure.dart';
import 'package:chiragar_chiragar_spacex_explore/domain/entities/launch.dart';
import 'package:chiragar_chiragar_spacex_explore/domain/entities/rocket.dart';

import '../../domain/entities/company_info.dart';
// Import other entities

abstract class SpaceXRepository {
  Future<Either<Failure, List<Launch>>> getPastLaunches({
    int limit = 10,
    int offset = 0,
    String? year,
    bool? launchSuccess,
    String? rocketName,
  });
  Future<Either<Failure, Launch>> getLaunchDetails(String id);
  Future<Either<Failure, List<Rocket>>> getAllRockets();
  Future<Either<Failure, Rocket>> getRocketDetails(String id);
Future<Either<Failure, CompanyInfo>> getCompanyInfo();
}