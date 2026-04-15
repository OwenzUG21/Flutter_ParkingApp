import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;
import '../services/weather_service.dart';
import 'weather_screen.dart';

class AppColors {
  static const Color background = Color(0xFF4A5AA8);
  static const Color primaryText = Color(0xFF212121);
  static const Color pinAvailable = Color(0xFF4CAF50);
  static const Color pinFew = Color(0xFFFF9800);
  static const Color pinFull = Color(0xFFF44336);
  static const Color cardBackground = Color(0xFFFFFFFF);
}

class ParkingMapScreen extends StatefulWidget {
  const ParkingMapScreen({super.key});

  @override
  State<ParkingMapScreen> createState() => _ParkingMapScreenState();
}

class _ParkingMapScreenState extends State<ParkingMapScreen> {
  final TextEditingController _searchController = TextEditingController();

  final gmaps.LatLng initialPosition = gmaps.LatLng(0.3476, 32.5825); // Kampala

  final WeatherService _weatherService = WeatherService();
  WeatherData? _currentWeather;

  List<ParkingSpot> parkingSpots = [
    ParkingSpot(
      name: 'Kireka',
      distance: '2km/hr',
      location: '2km away - Jinja Rd',
      status: 'Many slots available',
      pinColor: AppColors.pinAvailable,
      position: gmaps.LatLng(0.3485, 32.5850),
    ),
    ParkingSpot(
      name: 'Ntinda',
      distance: '4km/hr',
      location: '4km away - Jinja Rd',
      status: 'Few slots available',
      pinColor: AppColors.pinFew,
      position: gmaps.LatLng(0.3490, 32.5860),
    ),
    ParkingSpot(
      name: 'Kyambogo',
      distance: '5km/hr',
      location: '5km away - Jinja Rd',
      status: 'Full',
      pinColor: AppColors.pinFull,
      position: gmaps.LatLng(0.3500, 32.5870),
    ),
  ];

  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  Future<void> _fetchWeather() async {
    final weather = await _weatherService.getWeather('Kampala');
    if (mounted) {
      setState(() {
        _currentWeather = weather;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Filter spots based on search
    List<ParkingSpot> filteredSpots = parkingSpots
        .where(
          (spot) =>
              spot.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
              spot.location.toLowerCase().contains(searchQuery.toLowerCase()),
        )
        .toList();

    Set<gmaps.Marker> markers = filteredSpots.map((spot) {
      return gmaps.Marker(
        markerId: gmaps.MarkerId(spot.name),
        position: spot.position,
        infoWindow: gmaps.InfoWindow(
          title: spot.name,
          snippet: '${spot.status} - ${spot.distance}',
        ),
        icon: gmaps.BitmapDescriptor.defaultMarkerWithHue(
          spot.status.contains('Many')
              ? gmaps.BitmapDescriptor.hueGreen
              : spot.status.contains('Few')
                  ? gmaps.BitmapDescriptor.hueOrange
                  : gmaps.BitmapDescriptor.hueRed,
        ),
      );
    }).toSet();

    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        elevation: 0,
        title: Row(
          children: [
            const Icon(Icons.location_pin, color: AppColors.primaryText),
            const SizedBox(width: 5),
            const Text(
              'Kampala',
              style: TextStyle(color: AppColors.primaryText),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const WeatherScreen(currentCity: 'Kampala'),
                  ),
                );
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_currentWeather != null) ...[
                    Text(
                      _currentWeather!.weatherIcon,
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${_currentWeather!.temperature.round()}°C',
                      style: const TextStyle(
                        color: AppColors.primaryText,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ] else
                    const SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.primaryText,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
        actions: const [
          SizedBox(width: 8),
          Icon(Icons.menu, color: AppColors.primaryText),
          SizedBox(width: 8),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            /// Search Box
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
                decoration: const InputDecoration(
                  hintText: 'Search',
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),

            SizedBox(height: MediaQuery.of(context).size.height * 0.02),

            /// Google Map
            Expanded(
              flex: 2,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: DummyMap(
                  spots: filteredSpots,
                  initialPosition: initialPosition,
                ),
              ),
            ),

            SizedBox(height: MediaQuery.of(context).size.height * 0.02),

            /// Parking Slots List
            Expanded(
              flex: 1,
              child: ListView.builder(
                itemCount: filteredSpots.length,
                itemBuilder: (context, index) {
                  final spot = filteredSpots[index];
                  return ParkingCard(spot: spot);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Parking Spot Model
class ParkingSpot {
  final String name;
  final String distance;
  final String location;
  final String status;
  final Color pinColor;
  final gmaps.LatLng position;

  ParkingSpot({
    required this.name,
    required this.distance,
    required this.location,
    required this.status,
    required this.pinColor,
    required this.position,
  });
}

/// Parking Card Widget
class ParkingCard extends StatelessWidget {
  final ParkingSpot spot;

  const ParkingCard({super.key, required this.spot});

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    if (spot.status.contains('Many')) {
      statusColor = Colors.green;
    } else if (spot.status.contains('Few')) {
      statusColor = Colors.orange;
    } else {
      statusColor = Colors.red;
    }

    return Card(
      color: AppColors.cardBackground,
      margin: const EdgeInsets.symmetric(vertical: 5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: spot.pinColor,
          child: const Icon(Icons.local_parking, color: Colors.white),
        ),
        title: Text('${spot.name} - ${spot.distance}'),
        subtitle: Text(
          '${spot.location}\n${spot.status}',
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
          style: TextStyle(color: statusColor, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

/// A lightweight placeholder map widget that draws a simple background and
/// places markers roughly positioned relative to the provided spot coordinates.
class DummyMap extends StatelessWidget {
  final List<ParkingSpot> spots;
  final gmaps.LatLng initialPosition;

  const DummyMap({
    super.key,
    required this.spots,
    required this.initialPosition,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.cardBackground,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final w = constraints.maxWidth;
          final h = constraints.maxHeight;

          // Determine lat/lng range from spots (include initialPosition to center)
          double minLat = initialPosition.latitude;
          double maxLat = initialPosition.latitude;
          double minLng = initialPosition.longitude;
          double maxLng = initialPosition.longitude;

          for (final s in spots) {
            final lat = s.position.latitude;
            final lng = s.position.longitude;
            if (lat < minLat) minLat = lat;
            if (lat > maxLat) maxLat = lat;
            if (lng < minLng) minLng = lng;
            if (lng > maxLng) maxLng = lng;
          }

          // Add a small padding to ranges so markers are not on the edges
          final latPad = (maxLat - minLat) * 0.2 + 0.0005;
          final lngPad = (maxLng - minLng) * 0.2 + 0.0005;
          minLat -= latPad;
          maxLat += latPad;
          minLng -= lngPad;
          maxLng += lngPad;

          Widget buildMarker(ParkingSpot s) {
            // normalize
            final latRange = (maxLat - minLat);
            final lngRange = (maxLng - minLng);
            final nx = lngRange == 0
                ? 0.5
                : (s.position.longitude - minLng) / lngRange;
            final ny = latRange == 0
                ? 0.5
                : 1.0 - (s.position.latitude - minLat) / latRange;

            final left = (nx * (w - 56)).clamp(8.0, w - 56.0);
            final top = (ny * (h - 56)).clamp(8.0, h - 56.0);

            return Positioned(
              left: left,
              top: top,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 12,
                      backgroundColor: s.pinColor,
                      child: const Icon(
                        Icons.local_parking,
                        size: 14,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 3),
                      ],
                    ),
                    child: Text(
                      s.name,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return Stack(
            children: [
              // Simple painted background resembling a map
              Positioned.fill(child: CustomPaint(painter: _MapPainter())),
              // place each marker
              ...spots.map(buildMarker),
            ],
          );
        },
      ),
    );
  }
}

class _MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0xFFE6E9F2);
    final road = Paint()
      ..color = const Color(0xFFCDD6EE)
      ..strokeWidth = 12.0
      ..strokeCap = StrokeCap.round;

    // base
    canvas.drawRect(Offset.zero & size, paint);

    // draw some illustrative roads
    final path = Path();
    path.moveTo(size.width * 0.05, size.height * 0.25);
    path.lineTo(size.width * 0.95, size.height * 0.25);
    canvas.drawPath(path, road);

    final path2 = Path();
    path2.moveTo(size.width * 0.3, size.height * 0.05);
    path2.lineTo(size.width * 0.3, size.height * 0.95);
    canvas.drawPath(path2, road);

    final path3 = Path();
    path3.moveTo(size.width * 0.15, size.height * 0.7);
    path3.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.55,
      size.width * 0.85,
      size.height * 0.8,
    );
    canvas.drawPath(path3, road);

    // small blocks to suggest buildings/blocks
    final blockPaint = Paint()..color = const Color(0xFFD7E0F5);
    for (int i = 0; i < 5; i++) {
      final bx = size.width * (0.08 + i * 0.18);
      final by = size.height * 0.12;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(bx, by, size.width * 0.12, size.height * 0.08),
          const Radius.circular(6),
        ),
        blockPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
