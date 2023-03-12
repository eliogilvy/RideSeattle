import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive/hive.dart';

part 'old_stops.g.dart';

@HiveType(typeId: 1)
class OldStops {
  @HiveField(0)
  String stopId;
  @HiveField(1)
  String name;
  @HiveField(2)
  double lat;
  @HiveField(3)
  double lon;
  OldStops(
      {required this.stopId,
      required this.name,
      required this.lat,
      required this.lon});
}
