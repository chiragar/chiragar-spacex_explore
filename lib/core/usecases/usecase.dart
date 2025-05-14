import 'package:equatable/equatable.dart';
import '../utils/either.dart';
import '../utils/failure.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

// For use cases that don't require parameters
abstract class UseCaseWithoutParams<Type> {
  Future<Either<Failure, Type>> call();
}

class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}