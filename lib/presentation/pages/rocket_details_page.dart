import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:chiragar_chiragar_spacex_explore/domain/entities/rocket.dart';
import 'package:chiragar_chiragar_spacex_explore/injection_container.dart';
import 'package:chiragar_chiragar_spacex_explore/presentation/blocs_cubits/rocket_details/rocket_details_bloc.dart';
// Import your favorites cubit if implementing favorites for rockets
// import 'package:chiragar_chiragar_spacex_explorer/presentation/blocs_cubits/favorites/favorites_cubit.dart';

class RocketDetailsPage extends StatefulWidget {
  final String rocketId;
  const RocketDetailsPage({super.key, required this.rocketId});

  @override
  State<RocketDetailsPage> createState() => _RocketDetailsPageState();
}

class _RocketDetailsPageState extends State<RocketDetailsPage> {
  late RocketDetailsBloc _rocketDetailsBloc;

  @override
  void initState() {
    super.initState();
    _rocketDetailsBloc = getIt<RocketDetailsBloc>()
      ..add(FetchRocketDetails(widget.rocketId));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      // appBar: AppBar(title: const Text('Rocket Details')), // Title can be set dynamically
      body: BlocProvider.value(
        value: _rocketDetailsBloc,
        child: BlocBuilder<RocketDetailsBloc, RocketDetailsState>(
          builder: (context, state) {
            if (state is RocketDetailsInitial || state is RocketDetailsLoading) {
              return Center(child: SpinKitFadingCube(color: theme.colorScheme.primary));
            } else if (state is RocketDetailsLoaded) {
              final rocket = state.rocket;
              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    expandedHeight: 250.0,
                    floating: false,
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
                      title: Text(rocket.name, style: const TextStyle()),
                      background: rocket.flickrImages.isNotEmpty
                          ? CachedNetworkImage(
                        imageUrl: rocket.flickrImages.first,
                        fit: BoxFit.cover,
                        color: Colors.black.withOpacity(0.3), // Darken image for title readability
                        colorBlendMode: BlendMode.darken,
                        placeholder: (context, url) => Container(color: Colors.grey),
                        errorWidget: (context, url, error) => Container(color: Colors.grey[800], child: const Icon(Icons.broken_image, color: Colors.grey)),
                      )
                          : Container(color: theme.primaryColorDark), // Fallback color
                    ),
                    // actions: [
                    //   BlocBuilder<FavoritesCubit, FavoritesState>( // If you have favorites for rockets
                    //     builder: (context, favState) {
                    //       bool isFav = false;
                    //       if (favState is FavoritesLoaded) {
                    //         // isFav = favState.favoriteRocketIds.contains(rocket.id);
                    //       }
                    //       return IconButton(
                    //         icon: Icon(isFav ? Icons.favorite : Icons.favorite_border),
                    //         color: isFav ? Colors.red : null,
                    //         onPressed: () {
                    //           // context.read<FavoritesCubit>().toggleRocketFavorite(rocket.id);
                    //         },
                    //       );
                    //     },
                    //   ),
                    // ],
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate([
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(rocket.description, style: theme.textTheme.bodyLarge),
                            const SizedBox(height: 20),
                            _buildSectionTitle(context, 'Key Specifications'),
                            _buildSpecRow(context, 'Type', rocket.type),
                            _buildSpecRow(context, 'Active Status', rocket.active ? 'Active' : 'Inactive',
                                valueColor: rocket.active ? Colors.green : Colors.red),
                            _buildSpecRow(context, 'First Flight', rocket.firstFlight),
                            _buildSpecRow(context, 'Country', rocket.country),
                            _buildSpecRow(context, 'Company', rocket.company),
                            _buildSpecRow(context, 'Stages', rocket.stages.toString()),
                            _buildSpecRow(context, 'Cost per Launch',
                                NumberFormat.currency(locale: 'en_US', symbol: '\$').format(rocket.costPerLaunch)),
                            _buildSpecRow(context, 'Success Rate', '${rocket.successRatePct}%'),

                            if (rocket.height?.meters != null)
                              _buildSpecRow(context, 'Height', '${rocket.height!.meters} m (${rocket.height!.feet} ft)'),
                            if (rocket.diameter?.meters != null)
                              _buildSpecRow(context, 'Diameter', '${rocket.diameter!.meters} m (${rocket.diameter!.feet} ft)'),
                            if (rocket.mass?.kg != null)
                              _buildSpecRow(context, 'Mass', '${NumberFormat.decimalPattern().format(rocket.mass!.kg)} kg (${NumberFormat.decimalPattern().format(rocket.mass!.lb)} lb)'),

                            const SizedBox(height: 20),
                            if (rocket.flickrImages.length > 1) ...[
                              _buildSectionTitle(context, 'Gallery'),
                              SizedBox(
                                height: 180,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: rocket.flickrImages.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.only(right: 8.0),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: CachedNetworkImage(
                                          imageUrl: rocket.flickrImages[index],
                                          width: 250,
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) => Container(width: 250, color: Colors.grey[300]),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                            const SizedBox(height: 20),
                            // Consider adding sections for Engines, Payload Weights if data is available and parsed
                          ],
                        ),
                      ),
                    ]),
                  ),
                ],
              );
            } else if (state is RocketDetailsError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Error: ${state.message}', textAlign: TextAlign.center,),
                      const SizedBox(height: 10),
                      ElevatedButton(
                          onPressed: () => _rocketDetailsBloc.add(FetchRocketDetails(widget.rocketId)),
                          child: const Text('Retry'))
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
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildSpecRow(BuildContext context, String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('$label:', style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: valueColor),
            ),
          ),
        ],
      ),
    );
  }
}