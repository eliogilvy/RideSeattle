import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ride_seattle/provider/local_storage_provider.dart';

class FavoriteButton extends StatefulWidget {
  const FavoriteButton({super.key, required this.routeId, required this.callback});
  final String routeId;
  final Function callback;

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  @override
  Widget build(BuildContext context) {
    final storage = Provider.of<LocalStorageProvider>(context, listen: false);
    return !storage.getFavoriteRoutes().contains(widget.routeId)
        ? IconButton(
            tooltip: "Add to favorites",
            icon: const Icon(
              Icons.star_border,
            ),
            onPressed: () {
              storage.addRoute(widget.routeId);
              widget.callback();
            },
          )
        : IconButton(
            tooltip: "Remove from favorites",
            icon: const Icon(
              Icons.star,
            ),
            onPressed: () {
              // Remove route
            },
          );
  }
}
