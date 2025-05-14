part of 'rockets_list_bloc.dart';

abstract class RocketsListState extends Equatable {
  const RocketsListState();
  @override
  List<Object?> get props => [];
}

class RocketsListInitial extends RocketsListState {}

class RocketsListLoading extends RocketsListState {}

class RocketsListLoaded extends RocketsListState {
  final List<Rocket> rockets;
  const RocketsListLoaded(this.rockets);
  @override
  List<Object?> get props => [rockets];
}

class RocketsListError extends RocketsListState {
  final String message;
  const RocketsListError(this.message);
  @override
  List<Object?> get props => [message];
}