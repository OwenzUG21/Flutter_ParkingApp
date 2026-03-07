import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';

class ParkingSpot {
  final String name;
  final String distance;
  final String location;
  final String status;
  final Color pinColor;
  final LatLng position;

  ParkingSpot({
    required this.name,
    required this.distance,
    required this.location,
    required this.status,
    required this.pinColor,
    required this.position,
  });
}
