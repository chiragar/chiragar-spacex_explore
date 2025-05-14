// For functional error handling (optional but good practice with use cases)
import 'package:equatable/equatable.dart';
import 'failure.dart';

abstract class Either<L, R> extends Equatable {
  const Either();

  B fold<B>(B Function(L l) ifLeft, B Function(R r) ifRight);

  @override
  List<Object?> get props => [];
}

class Left<L, R> extends Either<L, R> {
  final L _l;
  const Left(this._l);

  @override
  B fold<B>(B Function(L l) ifLeft, B Function(R r) ifRight) => ifLeft(_l);

  @override
  List<Object?> get props => [_l];
}

class Right<L, R> extends Either<L, R> {
  final R _r;
  const Right(this._r);

  @override
  B fold<B>(B Function(L l) ifLeft, B Function(R r) ifRight) => ifRight(_r);

  @override
  List<Object?> get props => [_r];
}