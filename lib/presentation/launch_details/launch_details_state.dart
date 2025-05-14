part of 'launch_details_bloc.dart';

abstract class LaunchDetailsState extends Equatable {
  const LaunchDetailsState();
  @override
  List<Object> get props => [];
}

class LaunchDetailsInitial extends LaunchDetailsState {}

class LaunchDetailsLoading extends LaunchDetailsState {}

class LaunchDetailsLoaded extends LaunchDetailsState {
  final Launch launch;
  const LaunchDetailsLoaded(this.launch);
  @override
  List<Object> get props => [launch];
}

class LaunchDetailsError extends LaunchDetailsState {
  final String message;
  const LaunchDetailsError(this.message);
  @override
  List<Object> get props => [message];
}