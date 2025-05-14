part of 'launches_list_bloc.dart';

abstract class LaunchesListEvent extends Equatable {
  const LaunchesListEvent();
  @override
  List<Object?> get props => [];
}

class FetchLaunches extends LaunchesListEvent {
  final bool isRefresh;
  const FetchLaunches({this.isRefresh = false});
  @override
  List<Object?> get props => [isRefresh];
}

class FetchMoreLaunches extends LaunchesListEvent {}

class ApplyLaunchFilters extends LaunchesListEvent {
  final String? year;
  final bool? success;
  final String? rocketName;

  const ApplyLaunchFilters({this.year, this.success, this.rocketName});

  @override
  List<Object?> get props => [year, success, rocketName];
}

class SearchLaunches extends LaunchesListEvent {
  final String query;
  const SearchLaunches(this.query);
  @override
  List<Object?> get props => [query];
}
