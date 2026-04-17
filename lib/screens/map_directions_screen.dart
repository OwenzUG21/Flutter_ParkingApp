import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapDirectionsScreen extends StatefulWidget {
  const MapDirectionsScreen({super.key});

  @override
  State<MapDirectionsScreen> createState() => _MapDirectionsScreenState();
}

class _MapDirectionsScreenState extends State<MapDirectionsScreen> {
  final MapController _mapController = MapController();

  // Default location: Kampala, Uganda
  final LatLng _currentLocation = const LatLng(0.3476, 32.5825);

  // Parking locations map
  final Map<String, LatLng> _parkingLocations = {
    'Kololo, Kampala': const LatLng(0.3354, 32.5969),
    'Kampala Road': const LatLng(0.3136, 32.5811),
    'Yusuf Lule Road': const LatLng(0.3163, 32.5822),
    'City Center': const LatLng(0.3163, 32.5822),
    'Lugogo Bypass': const LatLng(0.3476, 32.6134),
    'Lugogo': const LatLng(0.3476, 32.6134),
    'Bugolobi': const LatLng(0.3264, 32.6134),
    'Naalya': const LatLng(0.3676, 32.6534),
  };

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String parkingName = args['parkingName'] ?? 'Unknown Parking';
    final String parkingLocation =
        args['parkingLocation'] ?? 'Unknown Location';

    // Get destination coordinates
    final LatLng destination =
        _parkingLocations[parkingLocation] ?? _currentLocation;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF5B6B9E),
        elevation: 0,
        title: const Text(
          'Directions',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location, color: Colors.white),
            onPressed: () {
              _mapController.move(_currentLocation, 13.0);
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // OpenStreetMap
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _currentLocation,
              initialZoom: 13.0,
              minZoom: 5.0,
              maxZoom: 18.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.project8',
                maxZoom: 19,
              ),
              // Polyline for route
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: [_currentLocation, destination],
                    strokeWidth: 4.0,
                    color: const Color(0xFF5B6B9E),
                    borderStrokeWidth: 2.0,
                    borderColor: Colors.white,
                  ),
                ],
              ),
              // Markers
              MarkerLayer(
                markers: [
                  // Current location marker
                  Marker(
                    point: _currentLocation,
                    width: 80,
                    height: 80,
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.3),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.person_pin_circle,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Destination marker
                  Marker(
                    point: destination,
                    width: 80,
                    height: 80,
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.3),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.local_parking,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Info card at the bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 20,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF5B6B9E).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.local_parking,
                          color: Color(0xFF5B6B9E),
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              parkingName,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  size: 16,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    parkingLocation,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Distance and time info
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color:
                                const Color(0xFF4CAF50).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: [
                              const Icon(
                                Icons.directions_car,
                                color: Color(0xFF4CAF50),
                                size: 24,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _calculateDistance(
                                    _currentLocation, destination),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const Text(
                                'Distance',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color:
                                const Color(0xFFFF6B6B).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: [
                              const Icon(
                                Icons.access_time,
                                color: Color(0xFFFF6B6B),
                                size: 24,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _calculateTime(_currentLocation, destination),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const Text(
                                'Est. Time',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Start Navigation button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Center map to show both markers
                        _centerMapOnRoute(_currentLocation, destination);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5B6B9E),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.navigation, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            'Start Navigation',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _calculateDistance(LatLng start, LatLng end) {
    const Distance distance = Distance();
    final double km = distance.as(LengthUnit.Kilometer, start, end);
    if (km < 1) {
      return '${(km * 1000).toStringAsFixed(0)} m';
    }
    return '${km.toStringAsFixed(1)} km';
  }

  String _calculateTime(LatLng start, LatLng end) {
    const Distance distance = Distance();
    final double km = distance.as(LengthUnit.Kilometer, start, end);
    // Assuming average speed of 30 km/h in city traffic
    final int minutes = ((km / 30) * 60).round();
    if (minutes < 60) {
      return '$minutes min';
    }
    final int hours = minutes ~/ 60;
    final int remainingMinutes = minutes % 60;
    return '${hours}h ${remainingMinutes}m';
  }

  void _centerMapOnRoute(LatLng start, LatLng end) {
    // Calculate bounds
    final double minLat =
        start.latitude < end.latitude ? start.latitude : end.latitude;
    final double maxLat =
        start.latitude > end.latitude ? start.latitude : end.latitude;
    final double minLng =
        start.longitude < end.longitude ? start.longitude : end.longitude;
    final double maxLng =
        start.longitude > end.longitude ? start.longitude : end.longitude;

    // Calculate center
    final LatLng center = LatLng(
      (minLat + maxLat) / 2,
      (minLng + maxLng) / 2,
    );

    // Move map to center with appropriate zoom
    _mapController.move(center, 12.0);
  }
}
