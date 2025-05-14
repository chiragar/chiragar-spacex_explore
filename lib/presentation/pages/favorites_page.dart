import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chiragar_spacex_explore/domain/entities/launch.dart';
import 'package:chiragar_spacex_explore/presentation/blocs_cubits/favorites/favorites_cubit.dart';
import 'package:chiragar_spacex_explore/presentation/blocs_cubits/launches_list/launches_list_bloc.dart'; // To access loaded launches
import 'package:chiragar_spacex_explore/presentation/widgets/launch_list_item.dart'; // Your existing launch item
// lib/presentation/pages/favorites_page.dart
// ... (imports) ...

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    print("FavoritesPage: Building UI"); // DEBUG

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Launches'),
      ),
      body: BlocBuilder<FavoritesCubit, FavoritesState>(
        builder: (context, favoritesState) {
          print("FavoritesPage: FavoritesCubit state: $favoritesState"); // DEBUG

          if (favoritesState is FavoritesLoading || favoritesState is FavoritesInitial) {
            return const Center(child: CircularProgressIndicator.adaptive());
          } else if (favoritesState is FavoritesLoaded) {
            final favoriteLaunchIds = favoritesState.favoriteLaunchIds;
            print("FavoritesPage: Favorite Launch IDs: $favoriteLaunchIds"); // DEBUG

            if (favoriteLaunchIds.isEmpty) {
              print("FavoritesPage: No favorite IDs found."); // DEBUG
              return const Center(
                child: Text(
                  'No favorite launches yet.\nTap the ❤️ on a launch to add it!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              );
            }

            // Now, get the actual Launch objects.
            return BlocBuilder<LaunchesListBloc, LaunchesListState>(
              builder: (context, launchesState) {
                print("FavoritesPage: LaunchesListBloc state: $launchesState"); // DEBUG

                if (launchesState is LaunchesListLoaded) {
                  final allLoadedLaunches = launchesState.launches;
                  print("FavoritesPage: All loaded launches count: ${allLoadedLaunches.length}"); // DEBUG

                  final favoriteLaunches = allLoadedLaunches
                      .where((launch) => favoriteLaunchIds.contains(launch.id))
                      .toList();
                  print("FavoritesPage: Filtered favorite launches count: ${favoriteLaunches.length}"); // DEBUG
                  print("FavoritesPage: Filtered favorite launches (first 5): ${favoriteLaunches.take(5).map((l) => '${l.missionName}(${l.id})').toList()}");


                  if (favoriteLaunches.isEmpty && favoriteLaunchIds.isNotEmpty) {
                    print("FavoritesPage: Favorites exist, but not in current loaded launches."); // DEBUG
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'Some favorite launches might not be displayed as they are not in the currently loaded launch list. For a complete list, consider implementing fetching favorites by ID.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: theme.textTheme.bodySmall?.color),
                        ),
                      ),
                    );
                  }

                  if (favoriteLaunches.isEmpty) {
                    print("FavoritesPage: No matching favorite launches found in the current list."); // DEBUG
                    return const Center(
                      child: Text(
                        'Favorite launches not found in the current list.',
                        textAlign: TextAlign.center,
                      ),
                    );
                  }

                  // *** THIS IS WHERE THE ListView.builder IS ***
                  return ListView.builder(
                    itemCount: favoriteLaunches.length,
                    itemBuilder: (context, index) {
                      final launch = favoriteLaunches[index];
                      print("FavoritesPage: Building LaunchListItem for: ${launch.missionName} (ID: ${launch.id}) at index $index"); // DEBUG
                      return LaunchListItem(launch: launch);
                    },
                  );
                } else if (launchesState is LaunchesListLoading) {
                  print("FavoritesPage: LaunchesListBloc is loading."); // DEBUG
                  return const Center(child: CircularProgressIndicator.adaptive());
                } else if (launchesState is LaunchesListError) {
                  print("FavoritesPage: LaunchesListBloc error: ${launchesState.message}"); // DEBUG
                  return Center(child: Text("Error loading launches: ${launchesState.message}"));
                }
                print("FavoritesPage: LaunchesListBloc in unexpected state or not loaded yet."); // DEBUG
                return const Center(child: Text("Loading launch data..."));
              },
            );
          } else if (favoritesState is FavoritesError) {
            print("FavoritesPage: FavoritesCubit error: ${favoritesState.message}"); // DEBUG
            return Center(child: Text("Error loading favorites: ${favoritesState.message}"));
          }
          print("FavoritesPage: FavoritesCubit in unexpected state."); // DEBUG
          return const Center(child: Text("Something went wrong with favorites."));
        },
      ),
    );
  }
}