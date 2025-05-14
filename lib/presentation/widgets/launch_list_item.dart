import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:chiragar_spacex_explore/domain/entities/launch.dart';
import 'package:chiragar_spacex_explore/presentation/pages/launch_details_page.dart';
import 'package:chiragar_spacex_explore/presentation/blocs_cubits/favorites/favorites_cubit.dart';

class LaunchListItem extends StatelessWidget {
  final Launch launch;

  const LaunchListItem({super.key, required this.launch});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => LaunchDetailsPage(launchId: launch.id),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              SizedBox(
                width: 80,
                height: 80,
                child: launch.missionPatchSmall != null
                    ? CachedNetworkImage(
                  imageUrl: launch.missionPatchSmall!,
                  placeholder: (context, url) => const Center(child: CircularProgressIndicator.adaptive()),
                  errorWidget: (context, url, error) => const Icon(Icons.rocket_launch_outlined, size: 40),
                  fit: BoxFit.contain,
                )
                    : const Icon(Icons.rocket_launch_outlined, size: 40),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      launch.missionName,
                      style: theme.textTheme.titleLarge,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Rocket: ${launch.rocketName}',
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Date: ${DateFormat.yMMMd().add_jm().format(launch.launchDateUtc.toLocal())}',
                      style: theme.textTheme.bodySmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Status: ${launch.launchSuccess == null ? "Upcoming/Unknown" : launch.launchSuccess! ? "Success" : "Failure"}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: launch.launchSuccess == null
                            ? theme.colorScheme.onSurface.withOpacity(0.7)
                            : launch.launchSuccess!
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
          BlocBuilder<FavoritesCubit, FavoritesState>(
            builder: (context, favState) {
              bool isFav = false;
              if (favState is FavoritesLoaded) {
                isFav = favState.favoriteLaunchIds.contains(launch.id);
              }
              return IconButton(
                icon: Icon(isFav ? Icons.favorite : Icons.favorite_border),
                color: isFav ? Colors.redAccent : theme.iconTheme.color,
                tooltip: isFav ? 'Remove from Favorites' : 'Add to Favorites',
                onPressed: () {
                  context.read<FavoritesCubit>().toggleLaunchFavorite(launch.id);
                },
              );
            }
          ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}