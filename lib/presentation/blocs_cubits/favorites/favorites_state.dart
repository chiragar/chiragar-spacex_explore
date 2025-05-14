part of 'favorites_cubit.dart';


abstract class FavoritesState extends Equatable {
  const FavoritesState();
  @override
  List<Object> get props => [];
}
class FavoritesInitial extends FavoritesState {}
class FavoritesLoading extends FavoritesState {}
class FavoritesLoaded extends FavoritesState {
  final Set<String> favoriteLaunchIds; // Using Set for quick lookups
  const FavoritesLoaded(this.favoriteLaunchIds);
  @override
  List<Object> get props => [favoriteLaunchIds];
}
class FavoritesError extends FavoritesState {
  final String message;
  const FavoritesError(this.message);
  @override
  List<Object> get props => [message];
}
