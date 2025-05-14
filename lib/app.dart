import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chiragar_chiragar_spacex_explore/core/theme/app_theme.dart';
import 'package:chiragar_chiragar_spacex_explore/presentation/blocs_cubits/theme/theme_cubit.dart';
import 'package:chiragar_chiragar_spacex_explore/presentation/pages/launches_list_page.dart';
// Import your router if you use one

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, themeState) {
        return MaterialApp(
          title: 'SpaceX Explorer',
          theme: themeState.themeData,
          darkTheme: AppTheme.darkTheme, // Provide dark theme if you want system to also influence
          themeMode: themeState.themeMode,
          debugShowCheckedModeBanner: false,
          home: const LaunchesListPage(), // Your initial page
          // onGenerateRoute: AppRouter.generateRoute, // If using a router
        );
      },
    );
  }
}