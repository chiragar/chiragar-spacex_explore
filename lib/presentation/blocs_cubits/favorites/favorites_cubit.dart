// lib/presentation/blocs_cubits/favorites/favorites_cubit.dart
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart'; // Import injectable
import 'package:chiragar_spacex_explore/data/datasources/local/favorites_local_data_source.dart';

part 'favorites_state.dart';

@injectable // Or @lazySingleton if you prefer
class FavoritesCubit extends Cubit<FavoritesState> {
  final FavoritesLocalDataSource _localDataSource;

  FavoritesCubit(this._localDataSource) : super(FavoritesInitial());

  Future<void> loadFavorites() async {
    // Only emit loading if not already loaded, to avoid unnecessary UI flashes on hot reload/restart
    if (state is! FavoritesLoaded) {
      emit(FavoritesLoading());
    }
    try {
      final ids = await _localDataSource.getFavoriteLaunchIds();
      emit(FavoritesLoaded(Set.from(ids)));
    } catch (e) {
      emit(FavoritesError("Failed to load favorites: $e"));
    }
  }

  // ... toggleLaunchFavorite and isFavorite methods ...
  void toggleLaunchFavorite(String launchId) {
    // ... (implementation as before)
    if (state is FavoritesLoaded) {
      final currentFavorites = Set<String>.from((state as FavoritesLoaded).favoriteLaunchIds);
      bool wasFavorite = currentFavorites.contains(launchId);

      if (wasFavorite) {
        _localDataSource.removeFavoriteLaunch(launchId);
        currentFavorites.remove(launchId);
      } else {
        _localDataSource.addFavoriteLaunch(launchId);
        currentFavorites.add(launchId);
      }
      emit(FavoritesLoaded(currentFavorites));
    } else {
      // Handle case where favorites aren't loaded yet - perhaps load them first
      // For simplicity, this might mean the toggle doesn't work until loaded.
      // Or, queue the action. For now, we assume it's loaded via loadFavorites().
      print("Favorites not loaded, cannot toggle.");
    }
  }

  bool isFavorite(String launchId) {
    if (state is FavoritesLoaded) {
      return (state as FavoritesLoaded).favoriteLaunchIds.contains(launchId);
    }
    return false; // Default to false if not loaded or in error state
  }
}