
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:chiragar_chiragar_spacex_explore/domain/entities/launch.dart';
import 'package:chiragar_chiragar_spacex_explore/domain/usecases/get_launches_usecase.dart';
import 'package:stream_transform/stream_transform.dart'; // For debounce

part 'launches_list_event.dart';
part 'launches_list_state.dart';

const _pageSize = 20;
const _debounceDuration = Duration(milliseconds: 500);

EventTransformer<E> debounce<E>(Duration duration) {
  return (events, mapper) {
    return events.debounce(duration).switchMap(mapper);
  };
}

@injectable
class LaunchesListBloc extends Bloc<LaunchesListEvent, LaunchesListState> {
  final GetPastLaunchesUseCase getPastLaunchesUseCase;

  String? _currentSearchQuery;
  String? _currentFilterYear;
  bool? _currentFilterSuccess;
  String? _currentFilterRocketName;

  LaunchesListBloc(this.getPastLaunchesUseCase) : super(LaunchesListInitial()) {
    on<FetchLaunches>(_onFetchLaunches);
    on<FetchMoreLaunches>(_onFetchMoreLaunches, transformer: debounce(_debounceDuration));
    on<ApplyLaunchFilters>(_onApplyLaunchFilters);
    on<SearchLaunches>(_onSearchLaunches, transformer: debounce(const Duration(milliseconds: 700)));
  }

  Future<void> _onFetchLaunches(
      FetchLaunches event,
      Emitter<LaunchesListState> emit,
      ) async {
    emit(LaunchesListLoading());
    await _fetchAndEmitLaunches(emit, offset: 0, isRefresh: event.isRefresh);
  }

  Future<void> _onFetchMoreLaunches(
      FetchMoreLaunches event,
      Emitter<LaunchesListState> emit,
      ) async {
    if (state is LaunchesListLoaded) {
      final currentState = state as LaunchesListLoaded;
      if (currentState.hasReachedMax) return;
      await _fetchAndEmitLaunches(emit, offset: currentState.launches.length);
    }
  }

  Future<void> _onApplyLaunchFilters(
      ApplyLaunchFilters event,
      Emitter<LaunchesListState> emit,
      ) async {
    _currentFilterYear = event.year;
    _currentFilterSuccess = event.success;
    _currentFilterRocketName = event.rocketName;
    // Reset search query when applying filters, or decide how they interact
    _currentSearchQuery = null;
    emit(LaunchesListLoading());
    await _fetchAndEmitLaunches(emit, offset: 0, isRefresh: true);
  }

  Future<void> _onSearchLaunches(
      SearchLaunches event,
      Emitter<LaunchesListState> emit,
      ) async {
    _currentSearchQuery = event.query.isEmpty ? null : event.query;
    // Reset filters when searching, or decide how they interact
    // _currentFilterYear = null;
    // _currentFilterSuccess = null;
    // _currentFilterRocketName = null;
    emit(LaunchesListLoading());
    await _fetchAndEmitLaunches(emit, offset: 0, isRefresh: true);
  }


  Future<void> _fetchAndEmitLaunches(Emitter<LaunchesListState> emit, {required int offset, bool isRefresh = false}) async {
    final params = GetPastLaunchesParams(
      limit: _pageSize,
      offset: offset,
      year: _currentFilterYear,
      launchSuccess: _currentFilterSuccess,
      rocketName: _currentFilterRocketName,
    );

    final result = await getPastLaunchesUseCase(params);

    result.fold(
          (failure) => emit(LaunchesListError(failure.message)),
          (newLaunches) {
        List<Launch> allLaunches;
        if (isRefresh || offset == 0) {
          allLaunches = newLaunches;
        } else if (state is LaunchesListLoaded) {
          allLaunches = List.of((state as LaunchesListLoaded).launches)..addAll(newLaunches);
        } else {
          allLaunches = newLaunches; // Should not happen if logic is correct
        }

        // Apply client-side search if API doesn't support mission_name directly in 'find'
        // The SpaceX API 'find' object is somewhat limited.
        // If _currentSearchQuery is not null, filter 'allLaunches' here.
        List<Launch> filteredLaunches = allLaunches;
        if (_currentSearchQuery != null && _currentSearchQuery!.isNotEmpty) {
          filteredLaunches = allLaunches
              .where((launch) =>
          launch.missionName.toLowerCase().contains(_currentSearchQuery!.toLowerCase()) ||
              (launch.rocketName.toLowerCase().contains(_currentSearchQuery!.toLowerCase()))
          )
              .toList();
        }


        emit(LaunchesListLoaded(
          launches: filteredLaunches,
          hasReachedMax: newLaunches.isEmpty || newLaunches.length < _pageSize,
          currentQuery: _currentSearchQuery,
          filterYear: _currentFilterYear,
          filterSuccess: _currentFilterSuccess,
          filterRocketName: _currentFilterRocketName,
        ));
      },
    );
  }
}