import 'package:injectable/injectable.dart';
import 'package:chiragar_chiragar_spacex_explore/core/usecases/usecase.dart';
import 'package:chiragar_chiragar_spacex_explore/core/utils/either.dart';
import 'package:chiragar_chiragar_spacex_explore/core/utils/failure.dart';
import 'package:chiragar_chiragar_spacex_explore/domain/entities/rocket.dart';
import 'package:chiragar_chiragar_spacex_explore/data/repositories/spacex_repository.dart';

@lazySingleton
class GetAllRocketsUseCase implements UseCaseWithoutParams<List<Rocket>> {
  final SpaceXRepository repository;

  GetAllRocketsUseCase(this.repository);

  @override
  Future<Either<Failure, List<Rocket>>> call() async {
    return await repository.getAllRockets();
  }
}