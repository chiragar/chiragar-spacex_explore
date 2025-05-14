import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:chiragar_spacex_explore/domain/entities/rocket.dart';
import 'package:chiragar_spacex_explore/domain/usecases/get_all_rocket_usecase.dart';

part 'rockets_list_event.dart';
part 'rockets_list_state.dart';

@injectable
class RocketsListBloc extends Bloc<RocketsListEvent, RocketsListState> {
  final GetAllRocketsUseCase getAllRocketsUseCase;

  RocketsListBloc(this.getAllRocketsUseCase) : super(RocketsListInitial()) {
    on<FetchAllRockets>(_onFetchAllRockets);
  }

  Future<void> _onFetchAllRockets(
      FetchAllRockets event,
      Emitter<RocketsListState> emit,
      ) async {
    emit(RocketsListLoading());
    final result = await getAllRocketsUseCase();
    result.fold(
          (failure) => emit(RocketsListError(failure.message)),
          (rockets) => emit(RocketsListLoaded(rockets)),
    );
  }
}