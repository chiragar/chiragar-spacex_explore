import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:chiragar_chiragar_spacex_explore/domain/entities/launch.dart';
import 'package:chiragar_chiragar_spacex_explore/domain/entities/rocket.dart'; // For Rocket Specs
import 'package:chiragar_chiragar_spacex_explore/injection_container.dart';
import 'package:chiragar_chiragar_spacex_explore/presentation/blocs_cubits/favorites/favorites_cubit.dart';

import 'package:url_launcher/url_launcher.dart';

import '../launch_details/launch_details_bloc.dart';
// If implementing map: import 'package:google_maps_flutter/google_maps_flutter.dart';

class LaunchDetailsPage extends StatefulWidget {
  final String launchId;
  const LaunchDetailsPage({super.key, required this.launchId});

  @override
  State<LaunchDetailsPage> createState() => _LaunchDetailsPageState();
}

class _LaunchDetailsPageState extends State<LaunchDetailsPage> {
  late LaunchDetailsBloc _launchDetailsBloc;

  @override
  void initState() {
    super.initState();
    _launchDetailsBloc = getIt<LaunchDetailsBloc>()
      ..add(FetchLaunchDetails(widget.launchId));
    // Ensure FavoritesCubit is loaded if not already (usually done globally)
    // context.read<FavoritesCubit>().loadFavorites(); // Or handle in MyAppWrapper
  }

  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch $urlString')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: BlocProvider.value(
        value: _launchDetailsBloc,
        child: BlocBuilder<LaunchDetailsBloc, LaunchDetailsState>(
          builder: (context, state) {
            if (state is LaunchDetailsInitial || state is LaunchDetailsLoading) {
              return Center(child: SpinKitFadingCube(color: theme.colorScheme.primary));
            } else if (state is LaunchDetailsLoaded) {
              final launch = state.launch;
              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    expandedHeight: 250.0,
                    floating: false,
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
                      title: Text(
                        launch.missionName,
                        style: const TextStyle(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      background: launch.missionPatch != null || (launch.flickrImages.isNotEmpty)
                          ? CachedNetworkImage(
                        imageUrl: launch.flickrImages.isNotEmpty ? launch.flickrImages.first : launch.missionPatch!,
                        fit: BoxFit.cover,
                        color: Colors.black.withOpacity(0.4),
                        colorBlendMode: BlendMode.darken,
                        placeholder: (context, url) => Container(color: Colors.grey[700]),
                        errorWidget: (context, url, error) => Container(
                            color: Colors.grey[800],
                            child: Center(child: Icon(Icons.rocket_launch_outlined, size: 100, color: Colors.grey[600]))),
                      )
                          : Container(
                        color: theme.primaryColorDark,
                        child: Center(child: Icon(Icons.rocket_launch_outlined, size: 100, color: theme.colorScheme.onPrimary.withOpacity(0.5))),
                      ),
                    ),
                    actions: [
                      BlocBuilder<FavoritesCubit, FavoritesState>(
                        builder: (context, favState) {
                          bool isFav = false;
                          if (favState is FavoritesLoaded) {
                            isFav = favState.favoriteLaunchIds.contains(launch.id);
                          }
                          return IconButton(
                            icon: Icon(isFav ? Icons.favorite : Icons.favorite_border, color: isFav ? Colors.redAccent : null),
                            tooltip: isFav ? 'Remove from Favorites' : 'Add to Favorites',
                            onPressed: () {
                              context.read<FavoritesCubit>().toggleLaunchFavorite(launch.id);
                            },
                          );
                        },
                      ),
                    ],
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate([
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildInfoRow(context, 'Mission Name:', launch.missionName, isTitle: true),
                            _buildInfoRow(context, 'Date:', DateFormat.yMMMMd().add_jm().format(launch.launchDateUtc.toLocal())),
                            _buildInfoRow(context, 'Status:', launch.launchSuccess == null ? "Upcoming/Unknown" : launch.launchSuccess! ? "Success" : "Failure",
                                valueColor: launch.launchSuccess == null ? null : (launch.launchSuccess! ? Colors.green.shade600 : Colors.red.shade700)),
                            if (launch.details != null && launch.details!.isNotEmpty) ...[
                              const SizedBox(height: 12),
                              _buildSectionTitle(context, 'Mission Details'),
                              Text(launch.details!, style: theme.textTheme.bodyLarge, textAlign: TextAlign.justify,),
                            ],

                            const SizedBox(height: 20),
                            _buildSectionTitle(context, 'Rocket Used'),
                            _buildInfoRow(context, 'Name:', launch.rocketName),
                            _buildInfoRow(context, 'Type:', launch.rocketType),
                            if(launch.rocketDetails != null)
                              _buildRocketSpecs(context, launch.rocketDetails!),


                            if (launch.launchSiteName != null) ...[
                              const SizedBox(height: 20),
                              _buildSectionTitle(context, 'Launch Site'),
                              _buildInfoRow(context, 'Site:', launch.launchSiteName!),
                              // Placeholder for map:
                              // Container(
                              //   height: 200,
                              //   margin: const EdgeInsets.symmetric(vertical: 8),
                              //   color: Colors.grey[300],
                              //   child: const Center(child: Text('Map Placeholder (Site: ${launch.launchSiteName})')),
                              // ),
                            ],

                            if (launch.flickrImages.isNotEmpty) ...[
                              const SizedBox(height: 20),
                              _buildSectionTitle(context, 'Photo Gallery'),
                              SizedBox(
                                height: 200,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: launch.flickrImages.length,
                                  itemBuilder: (lbContext, index) {
                                    return Padding(
                                      padding: const EdgeInsets.only(right: 8.0),
                                      child: InkWell(
                                        onTap: () => _launchUrl(launch.flickrImages[index]), // Or open in a full-screen viewer
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(8),
                                          child: CachedNetworkImage(
                                            imageUrl: launch.flickrImages[index],
                                            width: 280,
                                            fit: BoxFit.cover,
                                            placeholder: (c, u) => Container(width: 280, color: Colors.grey[300]),
                                            errorWidget: (c,u,e) => Container(width: 280, color: Colors.grey[400], child: const Icon(Icons.broken_image)),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],

                            if (launch.videoLink != null || launch.articleLink != null) ...[
                              const SizedBox(height: 20),
                              _buildSectionTitle(context, 'Links'),
                              if (launch.videoLink != null)
                                ListTile(
                                  leading: const Icon(Icons.videocam),
                                  title: const Text('Watch Video'),
                                  onTap: () => _launchUrl(launch.videoLink!),
                                ),
                              if (launch.articleLink != null)
                                ListTile(
                                  leading: const Icon(Icons.article),
                                  title: const Text('Read Article'),
                                  onTap: () => _launchUrl(launch.articleLink!),
                                ),
                            ],
                            const SizedBox(height: 30), // Bottom padding
                          ],
                        ),
                      ),
                    ]),
                  ),
                ],
              );
            } else if (state is LaunchDetailsError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Error: ${state.message}', textAlign: TextAlign.center),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () => _launchDetailsBloc.add(FetchLaunchDetails(widget.launchId)),
                        child: const Text('Retry'),
                      )
                    ],
                  ),
                ),
              );
            }
            return const Center(child: Text('Something went wrong.'));
          },
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value, {Color? valueColor, bool isTitle = false}) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100, // Adjust as needed
            child: Text(
              label,
              style: isTitle ? textTheme.headlineSmall : textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              style: (isTitle ? textTheme.headlineSmall : textTheme.titleMedium)?.copyWith(color: valueColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRocketSpecs(BuildContext context, Rocket rocket) {
    final theme = Theme.of(context);
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Rocket Specifications (${rocket.name})", style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const Divider(height: 16),
            _specDetail("First Flight:", rocket.firstFlight),
            _specDetail("Height:", rocket.height != null ? "${rocket.height!.meters}m / ${rocket.height!.feet}ft" : "N/A"),
            _specDetail("Diameter:", rocket.diameter != null ? "${rocket.diameter!.meters}m / ${rocket.diameter!.feet}ft" : "N/A"),
            _specDetail("Mass:", rocket.mass != null ? "${NumberFormat.decimalPattern().format(rocket.mass!.kg)}kg / ${NumberFormat.decimalPattern().format(rocket.mass!.lb)}lb" : "N/A"),
            _specDetail("Success Rate:", "${rocket.successRatePct}%"),
          ],
        ),
      ),
    );
  }

  Widget _specDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(width: 8),
          Expanded(child: Text(value, style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.end)),
        ],
      ),
    );
  }
}