import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:chiragar_spacex_explore/core/usecases/usecase.dart';
import 'package:chiragar_spacex_explore/core/utils/either.dart';
import 'package:chiragar_spacex_explore/core/utils/failure.dart';
import 'package:chiragar_spacex_explore/domain/entities/launch.dart';
import 'package:chiragar_spacex_explore/data/repositories/spacex_repository.dart';

@lazySingleton
class GetLaunchDetailsUseCase implements UseCase<Launch, GetLaunchDetailsParams> {
  final SpaceXRepository repository;

  GetLaunchDetailsUseCase(this.repository);

  @override
  Future<Either<Failure, Launch>> call(GetLaunchDetailsParams params) async {
    return await repository.getLaunchDetails(params.id);
  }
}

class GetLaunchDetailsParams extends Equatable {
  final String id;

  const GetLaunchDetailsParams({required this.id});

  @override
  List<Object?> get props => [id];
}
