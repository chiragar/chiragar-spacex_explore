import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:chiragar_chiragar_spacex_explore/injection_container.dart';
import 'package:chiragar_chiragar_spacex_explore/presentation/blocs_cubits/launches_list/launches_list_bloc.dart';
import 'package:chiragar_chiragar_spacex_explore/presentation/blocs_cubits/theme/theme_cubit.dart';
import 'package:chiragar_chiragar_spacex_explore/presentation/pages/rockets_list_page.dart'; // Create this
import 'package:chiragar_chiragar_spacex_explore/presentation/widgets/launch_list_item.dart';

import 'company_info_page.dart';
import 'favorites_page.dart';

class LaunchesListPage extends StatefulWidget {
  const LaunchesListPage({super.key});

  @override
  State<LaunchesListPage> createState() => _LaunchesListPageState();
}

class _LaunchesListPageState extends State<LaunchesListPage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  late LaunchesListBloc _launchesListBloc;

  // Filter state
  String? _selectedYear;
  bool? _selectedSuccess;
  // String? _selectedRocketName; // Potentially fetch rocket names for dropdown

  @override
  void initState() {
    super.initState();
    _launchesListBloc = getIt<LaunchesListBloc>()..add(const FetchLaunches());
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_isBottom) {
      _launchesListBloc.add(FetchMoreLaunches());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9); // Fetch when 90% scrolled
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String? tempYear = _selectedYear;
        bool? tempSuccess = _selectedSuccess;
        // String? tempRocket = _selectedRocketName;

        return AlertDialog(
          title: const Text('Filter Launches'),
          content: StatefulBuilder( // Use StatefulBuilder for local dialog state
            builder: (BuildContext context, StateSetter setStateDialog) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(
                      decoration: const InputDecoration(labelText: 'Launch Year (e.g., 2020)'),
                      keyboardType: TextInputType.number,
                      onChanged: (value) => tempYear = value.isEmpty ? null : value,
                      controller: TextEditingController(text: tempYear),
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<bool?>(
                      decoration: const InputDecoration(labelText: 'Launch Status'),
                      value: tempSuccess,
                      items: const [
                        DropdownMenuItem(value: null, child: Text('Any')),
                        DropdownMenuItem(value: true, child: Text('Success')),
                        DropdownMenuItem(value: false, child: Text('Failure')),
                      ],
                      onChanged: (value) {
                        setStateDialog(() => tempSuccess = value);
                      },
                    ),
                    // TODO: Add Rocket Name filter (perhaps a dropdown fetched from rockets list)
                  ],
                ),
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Clear'),
              onPressed: () {
                _selectedYear = null;
                _selectedSuccess = null;
                // _selectedRocketName = null;
                _launchesListBloc.add(const ApplyLaunchFilters()); // Apply empty filters to reset
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Apply'),
              onPressed: () {
                _selectedYear = tempYear;
                _selectedSuccess = tempSuccess;
                // _selectedRocketName = tempRocket;
                _launchesListBloc.add(ApplyLaunchFilters(
                  year: _selectedYear,
                  success: _selectedSuccess,
                  // rocketName: _selectedRocketName,
                ));
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('SpaceX Launches'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
            tooltip: 'Filter',
          ),
          IconButton(
            icon: Icon(
              context.watch<ThemeCubit>().state.themeMode == ThemeMode.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: () => context.read<ThemeCubit>().toggleTheme(),
            tooltip: 'Toggle Theme',
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search Missions or Rockets...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: theme.colorScheme.surfaceVariant.withOpacity(0.5),
                contentPadding: EdgeInsets.zero,
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _launchesListBloc.add(const SearchLaunches('')); // Empty search resets
                  },
                )
                    : null,
              ),
              onChanged: (query) {
                _launchesListBloc.add(SearchLaunches(query));
              },
            ),
          ),
        ),
      ),
      drawer: _buildDrawer(context),
      body: BlocProvider.value(
        value: _launchesListBloc,
        child: BlocBuilder<LaunchesListBloc, LaunchesListState>(
          builder: (context, state) {
            if (state is LaunchesListInitial ||
                state is LaunchesListLoading ||
                (state is LaunchesListLoaded && state.launches.isEmpty)) {
              return Center(child: SpinKitFadingCube(color: theme.colorScheme.primary));
            } else if (state is LaunchesListLoaded) {
              if (state.launches.isEmpty) {
                return const Center(child: Text('No launches found. Try different filters or search.'));
              }
              return RefreshIndicator(
                onRefresh: () async {
                  _launchesListBloc.add(const FetchLaunches(isRefresh: true));
                },
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: state.hasReachedMax
                      ? state.launches.length
                      : state.launches.length + 1, // +1 for loading indicator
                  itemBuilder: (context, index) {
                    if (index >= state.launches.length) {
                      return state.hasReachedMax
                          ? const SizedBox.shrink()
                          : Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(child: SpinKitThreeBounce(color: theme.colorScheme.primary, size: 30.0)),
                      );
                    }
                    return LaunchListItem(launch: state.launches[index]);
                  },
                ),
              );
            } else if (state is LaunchesListError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Error: ${state.message}'),
                    const SizedBox(height: 10),
                    ElevatedButton(onPressed: () => _launchesListBloc.add(const FetchLaunches(isRefresh: true)), child: const Text('Retry'))
                  ],
                ),
              );
            }
            return const Center(child: Text('Something went wrong.')); // Should not reach here
          },
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Text(
              'SpaceX Explorer',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.rocket_launch),
            title: const Text('Launches'),
            onTap: () {
              Navigator.pop(context); // Close drawer
              // Already on launches, or navigate if you have other main sections
            },
          ),
          ListTile(
            leading: const Icon(Icons.rocket),
            title: const Text('Rockets'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const RocketsListPage()));
            },
          ),
          ListTile( // New Favorite Item
            leading: const Icon(Icons.favorite),
            title: const Text('Favorites'),
            onTap: () {
              Navigator.pop(context); // Close drawer
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FavoritesPage()),
              );
            },
          ),
          ListTile( // New Company Info Item
            leading: const Icon(Icons.info_outline),
            title: const Text('Company Info'),
            onTap: () {
              Navigator.pop(context); // Close drawer
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CompanyInfoPage()),
              );
            },
          ),
          Divider(),
          // ListTile for Theme Toggle if you put it in drawer
          ListTile(
            leading: Icon(
              context.watch<ThemeCubit>().state.themeMode == ThemeMode.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            title: Text(
              context.watch<ThemeCubit>().state.themeMode == ThemeMode.dark
                  ? 'Switch to Light Theme'
                  : 'Switch to Dark Theme',
            ),
            onTap: () {
              context.read<ThemeCubit>().toggleTheme();
              Navigator.pop(context);
            },
          ),
          // Add more items like "Favorites" if implementing
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    // _launchesListBloc.close(); // get_it manages singleton lifecycle
    super.dispose();
  }
}