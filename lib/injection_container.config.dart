// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:graphql_flutter/graphql_flutter.dart' as _i128;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import 'data/datasources/local/favorites_local_data_source.dart' as _i987;
import 'data/datasources/remote/spacex_graphql_data_source.dart' as _i397;
import 'data/repositories/spacex_repository.dart' as _i735;
import 'domain/repositories/spacex_repository_impl.dart' as _i989;
import 'domain/usecases/get_all_rocket_usecase.dart' as _i121;
import 'domain/usecases/get_company_info_usecase.dart' as _i312;
import 'domain/usecases/get_launch_details_usecase.dart' as _i525;
import 'domain/usecases/get_launches_usecase.dart' as _i936;
import 'domain/usecases/get_rocket_details_usecase.dart' as _i767;
import 'presentation/blocs_cubits/company_info/company_info_bloc.dart'
    as _i1047;
import 'presentation/blocs_cubits/favorites/favorites_cubit.dart' as _i306;
import 'presentation/blocs_cubits/launches_list/launches_list_bloc.dart'
    as _i647;
import 'presentation/blocs_cubits/rocket_details/rocket_details_bloc.dart'
    as _i1007;
import 'presentation/blocs_cubits/rockets_list/rockets_list_bloc.dart' as _i379;
import 'presentation/blocs_cubits/theme/theme_cubit.dart' as _i543;
import 'presentation/launch_details/launch_details_bloc.dart' as _i197;

// initializes the registration of main-scope dependencies inside of GetIt
_i174.GetIt $initGetIt(
  _i174.GetIt getIt, {
  String? environment,
  _i526.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i526.GetItHelper(
    getIt,
    environment,
    environmentFilter,
  );
  gh.lazySingleton<_i987.FavoritesLocalDataSource>(
      () => _i987.FavoritesLocalDataSourceImpl(gh<_i460.SharedPreferences>()));
  gh.factory<_i543.ThemeCubit>(
      () => _i543.ThemeCubit(gh<_i460.SharedPreferences>()));
  gh.lazySingleton<_i397.SpaceXRemoteDataSource>(
      () => _i397.SpaceXGraphQLDataSourceImpl(gh<_i128.GraphQLClient>()));
  gh.factory<_i306.FavoritesCubit>(
      () => _i306.FavoritesCubit(gh<_i987.FavoritesLocalDataSource>()));
  gh.lazySingleton<_i735.SpaceXRepository>(
      () => _i989.SpaceXRepositoryImpl(gh<_i397.SpaceXRemoteDataSource>()));
  gh.lazySingleton<_i121.GetAllRocketsUseCase>(
      () => _i121.GetAllRocketsUseCase(gh<_i735.SpaceXRepository>()));
  gh.lazySingleton<_i312.GetCompanyInfoUseCase>(
      () => _i312.GetCompanyInfoUseCase(gh<_i735.SpaceXRepository>()));
  gh.lazySingleton<_i936.GetPastLaunchesUseCase>(
      () => _i936.GetPastLaunchesUseCase(gh<_i735.SpaceXRepository>()));
  gh.lazySingleton<_i525.GetLaunchDetailsUseCase>(
      () => _i525.GetLaunchDetailsUseCase(gh<_i735.SpaceXRepository>()));
  gh.lazySingleton<_i767.GetRocketDetailsUseCase>(
      () => _i767.GetRocketDetailsUseCase(gh<_i735.SpaceXRepository>()));
  gh.factory<_i197.LaunchDetailsBloc>(
      () => _i197.LaunchDetailsBloc(gh<_i525.GetLaunchDetailsUseCase>()));
  gh.factory<_i379.RocketsListBloc>(
      () => _i379.RocketsListBloc(gh<_i121.GetAllRocketsUseCase>()));
  gh.factory<_i647.LaunchesListBloc>(
      () => _i647.LaunchesListBloc(gh<_i936.GetPastLaunchesUseCase>()));
  gh.factory<_i1007.RocketDetailsBloc>(
      () => _i1007.RocketDetailsBloc(gh<_i767.GetRocketDetailsUseCase>()));
  gh.factory<_i1047.CompanyInfoBloc>(
      () => _i1047.CompanyInfoBloc(gh<_i312.GetCompanyInfoUseCase>()));
  return getIt;
}
