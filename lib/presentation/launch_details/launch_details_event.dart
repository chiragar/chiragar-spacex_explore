part of 'launch_details_bloc.dart';

abstract class LaunchDetailsEvent extends Equatable {
  const LaunchDetailsEvent();
  @override
  List<Object> get props => [];
}

class FetchLaunchDetails extends LaunchDetailsEvent {
  final String launchId;
  const FetchLaunchDetails(this.launchId);
  @override
  List<Object> get props => [launchId];
}