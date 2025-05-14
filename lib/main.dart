// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart'; // For initHiveForFlutter
import 'package:chiragar_spacex_explore/app.dart';
import 'package:chiragar_spacex_explore/injection_container.dart';
import 'package:chiragar_spacex_explore/presentation/blocs_cubits/theme/theme_cubit.dart';
import 'package:chiragar_spacex_explore/presentation/blocs_cubits/favorites/favorites_cubit.dart';

import 'presentation/blocs_cubits/launches_list/launches_list_bloc.dart'; // If you implement favorites

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive for Flutter (required by graphql_flutter's HiveStore)
  // This needs to be done before HiveStore.open() is called,
  // which happens inside configureDependencies().
  await initHiveForFlutter();

  await configureDependencies();

  runApp(const MyAppWrapper());
}

class MyAppWrapper extends StatelessWidget {
  const MyAppWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      // Use MultiBlocProvider for multiple global BLoCs/Cubits
      providers: [
        BlocProvider(
          create: (context) => getIt<ThemeCubit>(),
        ),

    BlocProvider( // Provide LaunchesListBloc globally here
    create: (context) => getIt<LaunchesListBloc>()..add(const FetchLaunches(isRefresh: true)),
    ),
        BlocProvider(
          create: (context) => getIt<FavoritesCubit>()..loadFavorites(),
        ),

        // Add other global BLoCs here
      ],
      child: const MyApp(),
    );
  }
}
