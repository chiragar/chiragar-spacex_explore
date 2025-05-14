import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:chiragar_spacex_explore/domain/entities/launch.dart';
import 'package:chiragar_spacex_explore/domain/usecases/get_launch_details_usecase.dart';

part 'launch_details_event.dart';
part 'launch_details_state.dart';

@injectable
class LaunchDetailsBloc extends Bloc<LaunchDetailsEvent, LaunchDetailsState> {
  final GetLaunchDetailsUseCase getLaunchDetailsUseCase;

  LaunchDetailsBloc(this.getLaunchDetailsUseCase) : super(LaunchDetailsInitial()) {
    on<FetchLaunchDetails>(_onFetchLaunchDetails);
  }

  Future<void> _onFetchLaunchDetails(
      FetchLaunchDetails event,
      Emitter<LaunchDetailsState> emit,
      ) async {
    emit(LaunchDetailsLoading());
    final result = await getLaunchDetailsUseCase(GetLaunchDetailsParams(id: event.launchId));
    result.fold(
          (failure) => emit(LaunchDetailsError(failure.message)),
          (launch) => emit(LaunchDetailsLoaded(launch)),
    );
  }
}