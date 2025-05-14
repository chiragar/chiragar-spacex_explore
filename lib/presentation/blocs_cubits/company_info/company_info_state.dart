part of 'company_info_bloc.dart';

abstract class CompanyInfoState extends Equatable {
  const CompanyInfoState();
  @override
  List<Object> get props => [];
}

class CompanyInfoInitial extends CompanyInfoState {}

class CompanyInfoLoading extends CompanyInfoState {}

class CompanyInfoLoaded extends CompanyInfoState {
  final CompanyInfo info;
  const CompanyInfoLoaded(this.info);
  @override
  List<Object> get props => [info];
}

class CompanyInfoError extends CompanyInfoState {
  final String message;
  const CompanyInfoError(this.message);
  @override
  List<Object> get props => [message];
}