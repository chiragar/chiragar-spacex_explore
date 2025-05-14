part of 'launches_list_bloc.dart';


abstract class LaunchesListState extends Equatable {
  const LaunchesListState();
  @override
  List<Object?> get props => [];
}

class LaunchesListInitial extends LaunchesListState {}

class LaunchesListLoading extends LaunchesListState {}

class LaunchesListLoaded extends LaunchesListState {
  final List<Launch> launches;
  final bool hasReachedMax;
  final String? currentQuery; // For search persistence
  final String? filterYear;
  final bool? filterSuccess;
  final String? filterRocketName;


  const LaunchesListLoaded({
    required this.launches,
    this.hasReachedMax = false,
    this.currentQuery,
    this.filterYear,
    this.filterSuccess,
    this.filterRocketName,
  });

  LaunchesListLoaded copyWith({
    List<Launch>? launches,
    bool? hasReachedMax,
    String? currentQuery,
    String? filterYear,
    bool? filterSuccess,
    String? filterRocketName,

  }) {
    return LaunchesListLoaded(
      launches: launches ?? this.launches,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentQuery: currentQuery ?? this.currentQuery,
      filterYear: filterYear ?? this.filterYear,
      filterSuccess: filterSuccess ?? this.filterSuccess,
      filterRocketName: filterRocketName ?? this.filterRocketName,
    );
  }

  @override
  List<Object?> get props => [launches, hasReachedMax, currentQuery, filterYear, filterSuccess, filterRocketName];
}

class LaunchesListError extends LaunchesListState {
  final String message;
  const LaunchesListError(this.message);
  @override
  List<Object?> get props => [message];
}
