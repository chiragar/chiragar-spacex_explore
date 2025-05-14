import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:chiragar_chiragar_spacex_explore/domain/entities/rocket.dart';
import 'package:chiragar_chiragar_spacex_explore/domain/usecases/get_rocket_details_usecase.dart';

part 'rocket_details_event.dart';
part 'rocket_details_state.dart';

@injectable
class RocketDetailsBloc extends Bloc<RocketDetailsEvent, RocketDetailsState> {
  final GetRocketDetailsUseCase getRocketDetailsUseCase;

  RocketDetailsBloc(this.getRocketDetailsUseCase) : super(RocketDetailsInitial()) {
    on<FetchRocketDetails>(_onFetchRocketDetails);
  }

  Future<void> _onFetchRocketDetails(
      FetchRocketDetails event,
      Emitter<RocketDetailsState> emit,
      ) async {
    emit(RocketDetailsLoading());
    final result = await getRocketDetailsUseCase(GetRocketDetailsParams(id: event.rocketId));
    result.fold(
          (failure) => emit(RocketDetailsError(failure.message)),
          (rocket) => emit(RocketDetailsLoaded(rocket)),
    );
  }
}