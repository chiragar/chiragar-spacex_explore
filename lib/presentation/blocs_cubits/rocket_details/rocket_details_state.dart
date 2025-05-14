part of 'rocket_details_bloc.dart';

abstract class RocketDetailsState extends Equatable {
  const RocketDetailsState();
  @override
  List<Object> get props => [];
}

class RocketDetailsInitial extends RocketDetailsState {}

class RocketDetailsLoading extends RocketDetailsState {}

class RocketDetailsLoaded extends RocketDetailsState {
  final Rocket rocket;
  const RocketDetailsLoaded(this.rocket);
  @override
  List<Object> get props => [rocket];
}

class RocketDetailsError extends RocketDetailsState {
  final String message;
  const RocketDetailsError(this.message);
  @override
  List<Object> get props => [message];
}