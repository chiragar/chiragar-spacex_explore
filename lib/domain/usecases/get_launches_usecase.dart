import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:chiragar_spacex_explore/core/usecases/usecase.dart';
import 'package:chiragar_spacex_explore/core/utils/either.dart';
import 'package:chiragar_spacex_explore/core/utils/failure.dart';
import 'package:chiragar_spacex_explore/domain/entities/launch.dart';
import 'package:chiragar_spacex_explore/data/repositories/spacex_repository.dart';

@lazySingleton
class GetPastLaunchesUseCase implements UseCase<List<Launch>, GetPastLaunchesParams> {
  final SpaceXRepository repository;

  GetPastLaunchesUseCase(this.repository);

  @override
  Future<Either<Failure, List<Launch>>> call(GetPastLaunchesParams params) async {
    return await repository.getPastLaunches(
      limit: params.limit,
      offset: params.offset,
      year: params.year,
      launchSuccess: params.launchSuccess,
      rocketName: params.rocketName,
    );
  }
}

class GetPastLaunchesParams extends Equatable {
  final int limit;
  final int offset;
  final String? year;
  final bool? launchSuccess;
  final String? rocketName;

  const GetPastLaunchesParams({
    required this.limit,
    required this.offset,
    this.year,
    this.launchSuccess,
    this.rocketName,
  });

  @override
  List<Object?> get props => [limit, offset, year, launchSuccess, rocketName];
}