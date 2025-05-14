import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:chiragar_chiragar_spacex_explore/domain/entities/rocket.dart';
import 'package:chiragar_chiragar_spacex_explore/presentation/pages/rocket_details_page.dart'; // We'll create this next

class RocketListItem extends StatelessWidget {
  final Rocket rocket;

  const RocketListItem({super.key, required this.rocket});

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
              builder: (_) => RocketDetailsPage(rocketId: rocket.id),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (rocket.flickrImages.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: CachedNetworkImage(
                    imageUrl: rocket.flickrImages.first,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                    const Center(child: CircularProgressIndicator.adaptive()),
                    errorWidget: (context, url, error) =>
                        Container(height: 150, color: Colors.grey[300], child: const Icon(Icons.rocket, size: 50, color: Colors.grey)),
                  ),
                )
              else
                Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Icon(Icons.rocket_outlined, size: 60, color: theme.colorScheme.onSurfaceVariant),
                ),
              const SizedBox(height: 12),
              Text(
                rocket.name,
                style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                'Type: ${rocket.type}',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 4),
              Text(
                'First Flight: ${rocket.firstFlight}',
                style: theme.textTheme.bodySmall,
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Status: ${rocket.active ? "Active" : "Inactive"}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: rocket.active ? Colors.green.shade600 : Colors.red.shade600,
                    ),
                  ),
                  Text(
                    'Success: ${rocket.successRatePct}%',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}