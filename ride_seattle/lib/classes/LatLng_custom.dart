import 'package:hive/hive.dart';

part 'LatLng_custom.g.dart';

@HiveType(typeId: 0)
class LatLng_custom {

  @HiveField(0)
  double Latitude;

  @HiveField(1)
  double Longitude;

  LatLng_custom({required this.Latitude, required this.Longitude});
}