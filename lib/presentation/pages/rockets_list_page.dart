import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:chiragar_spacex_explore/injection_container.dart';
import 'package:chiragar_spacex_explore/presentation/blocs_cubits/rockets_list/rockets_list_bloc.dart';
import 'package:chiragar_spacex_explore/presentation/widgets/rocket_list_item.dart';

class RocketsListPage extends StatefulWidget {
  const RocketsListPage({super.key});

  @override
  State<RocketsListPage> createState() => _RocketsListPageState();
}

class _RocketsListPageState extends State<RocketsListPage> {
  late RocketsListBloc _rocketsListBloc;

  @override
  void initState() {
    super.initState();
    _rocketsListBloc = getIt<RocketsListBloc>()..add(FetchAllRockets());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('SpaceX Rockets'),
      ),
      body: BlocProvider.value(
        value: _rocketsListBloc,
        child: BlocBuilder<RocketsListBloc, RocketsListState>(
          builder: (context, state) {
            if (state is RocketsListInitial || state is RocketsListLoading) {
              return Center(child: SpinKitFadingCube(color: theme.colorScheme.primary));
            } else if (state is RocketsListLoaded) {
              if (state.rockets.isEmpty) {
                return const Center(child: Text('No rockets found.'));
              }
              return ListView.builder(
                itemCount: state.rockets.length,
                itemBuilder: (context, index) {
                  return RocketListItem(rocket: state.rockets[index]);
                },
              );
            } else if (state is RocketsListError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Error: ${state.message}'),
                    const SizedBox(height: 10),
                    ElevatedButton(onPressed: () => _rocketsListBloc.add(FetchAllRockets()), child: const Text('Retry'))
                  ],
                ),
              );
            }
            return const Center(child: Text('Something went wrong.'));
          },
        ),
      ),
    );
  }
}