import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class FavoritesLocalDataSource {
  Future<List<String>> getFavoriteLaunchIds();
  Future<void> addFavoriteLaunch(String launchId);
  Future<void> removeFavoriteLaunch(String launchId);
  bool isFavoriteLaunch(String launchId); // Synchronous check for UI
}

const String _favoriteLaunchesKey = 'favoriteLaunches';

@LazySingleton(as: FavoritesLocalDataSource)
class FavoritesLocalDataSourceImpl implements FavoritesLocalDataSource {
  final SharedPreferences _prefs;
  List<String> _cachedFavoriteLaunchIds = [];


  FavoritesLocalDataSourceImpl(this._prefs) {
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    _cachedFavoriteLaunchIds = _prefs.getStringList(_favoriteLaunchesKey) ?? [];
  }

  @override
  Future<List<String>> getFavoriteLaunchIds() async {
    await _loadFavorites(); // Ensure it's up-to-date if accessed externally
    return List.from(_cachedFavoriteLaunchIds);
  }

  @override
  Future<void> addFavoriteLaunch(String launchId) async {
    if (!_cachedFavoriteLaunchIds.contains(launchId)) {
      _cachedFavoriteLaunchIds.add(launchId);
      await _prefs.setStringList(_favoriteLaunchesKey, _cachedFavoriteLaunchIds);
    }
  }

  @override
  Future<void> removeFavoriteLaunch(String launchId) async {
    _cachedFavoriteLaunchIds.remove(launchId);
    await _prefs.setStringList(_favoriteLaunchesKey, _cachedFavoriteLaunchIds);
  }

  @override
  bool isFavoriteLaunch(String launchId) {
    // This can be sync if _loadFavorites is called in constructor or first get
    return _cachedFavoriteLaunchIds.contains(launchId);
  }
}