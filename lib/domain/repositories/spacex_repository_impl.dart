import 'package:injectable/injectable.dart';
import 'package:chiragar_chiragar_spacex_explore/core/utils/either.dart';
import 'package:chiragar_chiragar_spacex_explore/core/utils/failure.dart';
import 'package:chiragar_chiragar_spacex_explore/data/datasources/remote/spacex_graphql_data_source.dart';
import 'package:chiragar_chiragar_spacex_explore/domain/entities/launch.dart';
import 'package:chiragar_chiragar_spacex_explore/domain/entities/rocket.dart';
import 'package:chiragar_chiragar_spacex_explore/data/repositories/spacex_repository.dart';

import '../entities/company_info.dart';
// Import other entities/models

@LazySingleton(as: SpaceXRepository)
class SpaceXRepositoryImpl implements SpaceXRepository {
  final SpaceXRemoteDataSource remoteDataSource;
  // final NetworkInfo networkInfo; // For checking connectivity before API call

  SpaceXRepositoryImpl(this.remoteDataSource /*, this.networkInfo*/);

  @override
  Future<Either<Failure, List<Launch>>> getPastLaunches({
    int limit = 10,
    int offset = 0,
    String? year,
    bool? launchSuccess,
    String? rocketName,
  }) async {
    // if (await networkInfo.isConnected) { // Example check
    try {
      final remoteLaunches = await remoteDataSource.getPastLaunches(
        limit: limit,
        offset: offset,
        year: year,
        launchSuccess: launchSuccess,
        rocketName: rocketName,
      );
      return Right(remoteLaunches);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
    // } else {
    //   return Left(NetworkFailure('No internet connection'));
    // }
  }

  @override
  Future<Either<Failure, Launch>> getLaunchDetails(String id) async {
    try {
      final remoteLaunch = await remoteDataSource.getLaunchDetails(id);
      return Right(remoteLaunch);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Rocket>>> getAllRockets() async {
    try {
      final remoteRockets = await remoteDataSource.getAllRockets();
      return Right(remoteRockets);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Rocket>> getRocketDetails(String id) async {
    try {
      final remoteRocket = await remoteDataSource.getRocketDetails(id);
      return Right(remoteRocket);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
// Implement other methods similarly

  @override
  Future<Either<Failure, CompanyInfo>> getCompanyInfo() async {
    try {
      final remoteInfo = await remoteDataSource.getCompanyInfo();
      return Right(remoteInfo);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}