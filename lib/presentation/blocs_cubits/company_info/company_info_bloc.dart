import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:chiragar_spacex_explore/domain/entities/company_info.dart';
import 'package:chiragar_spacex_explore/domain/usecases/get_company_info_usecase.dart';

part 'company_info_event.dart';
part 'company_info_state.dart';

@injectable
class CompanyInfoBloc extends Bloc<CompanyInfoEvent, CompanyInfoState> {
  final GetCompanyInfoUseCase getCompanyInfoUseCase;

  CompanyInfoBloc(this.getCompanyInfoUseCase) : super(CompanyInfoInitial()) {
    on<FetchCompanyInfo>(_onFetchCompanyInfo);
  }

  Future<void> _onFetchCompanyInfo(
      FetchCompanyInfo event,
      Emitter<CompanyInfoState> emit,
      ) async {
    emit(CompanyInfoLoading());
    final result = await getCompanyInfoUseCase();
    result.fold(
          (failure) => emit(CompanyInfoError(failure.message)),
          (info) => emit(CompanyInfoLoaded(info)),
    );
  }
}