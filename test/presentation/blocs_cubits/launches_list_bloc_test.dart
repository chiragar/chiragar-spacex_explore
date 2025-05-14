import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:chiragar_chiragar_spacex_explore/core/utils/either.dart';
import 'package:chiragar_chiragar_spacex_explore/core/utils/failure.dart';
import 'package:chiragar_chiragar_spacex_explore/domain/entities/launch.dart';
import 'package:chiragar_chiragar_spacex_explore/domain/usecases/get_launches_usecase.dart';
import 'package:chiragar_chiragar_spacex_explore/presentation/blocs_cubits/launches_list/launches_list_bloc.dart';

class MockGetPastLaunchesUseCase extends Mock implements GetPastLaunchesUseCase {}
class MockLaunch extends Mock implements Launch {} // For list creation

void main() {
  late LaunchesListBloc launchesListBloc;
  late MockGetPastLaunchesUseCase mockGetPastLaunchesUseCase;

  setUp(() {
    mockGetPastLaunchesUseCase = MockGetPastLaunchesUseCase();
    launchesListBloc = LaunchesListBloc(mockGetPastLaunchesUseCase);
  });

  tearDown(() {
    launchesListBloc.close();
  });

  final tLaunch = Launch(
    id: '1',
    missionName: 'Test Mission',
    launchDateUtc: DateTime.now(),
    rocketName: 'Test Rocket',
    rocketType: 'TR1',
  );
  final tLaunchList = [tLaunch];
  const tParams = GetPastLaunchesParams(limit: 20, offset: 0);


  test('initial state should be LaunchesListInitial', () {
    expect(launchesListBloc.state, LaunchesListInitial());
  });

  blocTest<LaunchesListBloc, LaunchesListState>(
    'emits [LaunchesListLoading, LaunchesListLoaded] when FetchLaunches is added and use case succeeds.',
    build: () {
      when(() => mockGetPastLaunchesUseCase(any())).thenAnswer((_) async => Right(tLaunchList));
      return launchesListBloc;
    },
    act: (bloc) => bloc.add(const FetchLaunches()),
    expect: () => [
      LaunchesListLoading(),
      LaunchesListLoaded(launches: tLaunchList, hasReachedMax: tLaunchList.length < 20),
    ],
    verify: (_) {
      verify(() => mockGetPastLaunchesUseCase(tParams)).called(1);
    },
  );

  blocTest<LaunchesListBloc, LaunchesListState>(
    'emits [LaunchesListLoading, LaunchesListError] when FetchLaunches is added and use case fails.',
    build: () {
      when(() => mockGetPastLaunchesUseCase(any())).thenAnswer((_) async => const Left(ServerFailure('Server Error')));
      return launchesListBloc;
    },
    act: (bloc) => bloc.add(const FetchLaunches()),
    expect: () => [
      LaunchesListLoading(),
      const LaunchesListError('Server Error'),
    ],
  );
}