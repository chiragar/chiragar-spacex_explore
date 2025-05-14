import 'package:injectable/injectable.dart';
import 'package:chiragar_spacex_explore/core/usecases/usecase.dart';
import 'package:chiragar_spacex_explore/core/utils/either.dart';
import 'package:chiragar_spacex_explore/core/utils/failure.dart';
import 'package:chiragar_spacex_explore/domain/entities/company_info.dart';
import 'package:chiragar_spacex_explore/data/repositories/spacex_repository.dart';

@lazySingleton
class GetCompanyInfoUseCase implements UseCaseWithoutParams<CompanyInfo> {
  final SpaceXRepository repository;

  GetCompanyInfoUseCase(this.repository);

  @override
  Future<Either<Failure, CompanyInfo>> call() async {
    return await repository.getCompanyInfo();
  }
}