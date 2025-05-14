part of 'rockets_list_bloc.dart';

abstract class RocketsListEvent extends Equatable {
  const RocketsListEvent();
  @override
  List<Object?> get props => [];
}

class FetchAllRockets extends RocketsListEvent {}