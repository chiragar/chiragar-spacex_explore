import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:chiragar_spacex_explore/core/usecases/usecase.dart';
import 'package:chiragar_spacex_explore/core/utils/either.dart';
import 'package:chiragar_spacex_explore/core/utils/failure.dart';
import 'package:chiragar_spacex_explore/domain/entities/rocket.dart';
import 'package:chiragar_spacex_explore/data/repositories/spacex_repository.dart';

@lazySingleton
class GetRocketDetailsUseCase implements UseCase<Rocket, GetRocketDetailsParams> {
  final SpaceXRepository repository;

  GetRocketDetailsUseCase(this.repository);

  @override
  Future<Either<Failure, Rocket>> call(GetRocketDetailsParams params) async {
    return await repository.getRocketDetails(params.id);
  }
}

class GetRocketDetailsParams extends Equatable {
  final String id;

  const GetRocketDetailsParams({required this.id});

  @override
  List<Object?> get props => [id];
}