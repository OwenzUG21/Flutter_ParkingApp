import 'package:flutter/material.dart';

class ParkingSpotsScreen extends StatefulWidget {
  const ParkingSpotsScreen({super.key});

  @override
  State<ParkingSpotsScreen> createState() => _ParkingSpotsScreenState();
}

class _ParkingSpotsScreenState extends State<ParkingSpotsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<Map<String, dynamic>> _parkingSpots = [
    {
      'name': 'Acacia Mall Parking',
      'location': 'Kololo, Kampala',
      'spacesLeft': 45,
      'price': 5000,
      'color': const Color(0xFF5B6B9E),
    },
    {
      'name': 'Garden City Parking',
      'location': 'Kampala Road',
      'spacesLeft': 32,
      'price': 4500,
      'color': const Color(0xFFFF6B6B),
    },
    {
      'name': 'Oasis Mall Parking',
      'location': 'Yusuf Lule Road',
      'spacesLeft': 18,
      'price': 6000,
      'color': const Color(0xFF4CAF50),
    },
    {
      'name': 'Kampala Road Parking',
      'location': 'City Center',
      'spacesLeft': 8,
      'price': 3500,
      'color': const Color(0xFFB8956A),
    },
    {
      'name': 'Lugogo Mall Parking',
      'location': 'Lugogo Bypass',
      'spacesLeft': 56,
      'price': 5500,
      'color': const Color(0xFF5B6B9E),
    },
    {
      'name': 'Forest Mall Parking',
      'location': 'Lugogo',
      'spacesLeft': 23,
      'price': 4000,
      'color': const Color(0xFFFF6B6B),
    },
    {
      'name': 'Village Mall Parking',
      'location': 'Bugolobi',
      'spacesLeft': 12,
      'price': 7000,
      'color': const Color(0xFF4CAF50),
    },
    {
      'name': 'Metroplex Mall Parking',
      'location': 'Naalya',
      'spacesLeft': 67,
      'price': 6500,
      'color': const Color(0xFFB8956A),
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredParkingSpots {
    if (_searchQuery.isEmpty) {
      return _parkingSpots;
    }
    return _parkingSpots.where((spot) {
      return spot['name'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          spot['location'].toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        elevation: 0,
        title: const Text(
          'Available Parking Spots',
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
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Current Location & Search Bar
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF5B6B9E), Color(0xFF6B7AB8)],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.location_on, color: Colors.white, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Current Location',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Kampala, Uganda',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Search Bar
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.search, color: Colors.grey),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              onChanged: (value) {
                                setState(() {
                                  _searchQuery = value;
                                });
                              },
                              decoration: const InputDecoration(
                                hintText: 'Search parking spots...',
                                border: InputBorder.none,
                                hintStyle: TextStyle(color: Colors.grey),
                              ),
                            ),
                          ),
                          if (_searchQuery.isNotEmpty)
                            IconButton(
                              icon: const Icon(Icons.clear, color: Colors.grey),
                              onPressed: () {
                                setState(() {
                                  _searchController.clear();
                                  _searchQuery = '';
                                });
                              },
                            )
                          else
                            const Icon(Icons.tune, color: Colors.grey),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Map Section
              Container(
                height: 200,
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Stack(
                    children: [
                      // Map placeholder with gradient
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              const Color(0xFF5B6B9E).withOpacity(0.1),
                              const Color(0xFF6B7AB8).withOpacity(0.2),
                            ],
                          ),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.map,
                                size: 60,
                                color: const Color(0xFF5B6B9E).withOpacity(0.5),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Map View',
                                style: TextStyle(
                                  color: const Color(
                                    0xFF5B6B9E,
                                  ).withOpacity(0.7),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Map markers
                      Positioned(
                        top: 40,
                        left: 60,
                        child: Icon(
                          Icons.location_pin,
                          color: Colors.red,
                          size: 30,
                        ),
                      ),
                      Positioned(
                        top: 80,
                        right: 80,
                        child: Icon(
                          Icons.location_pin,
                          color: const Color(0xFF4CAF50),
                          size: 30,
                        ),
                      ),
                      Positioned(
                        bottom: 50,
                        left: 100,
                        child: Icon(
                          Icons.location_pin,
                          color: const Color(0xFFFF6B6B),
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Parking Spots List
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Select a Parking Spot',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (_filteredParkingSpots.isEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(40),
                          child: Column(
                            children: [
                              Icon(
                                Icons.search_off,
                                size: 64,
                                color: Colors.grey.shade400,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No parking spots found',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey.shade600,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Try a different search term',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      ..._filteredParkingSpots.map((spot) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _buildParkingSpot(
                            context,
                            spot['name'],
                            spot['location'],
                            spot['spacesLeft'],
                            spot['price'],
                            spot['color'],
                          ),
                        );
                      }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildParkingSpot(
    BuildContext context,
    String name,
    String location,
    int spacesLeft,
    int price,
    Color color,
  ) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/booking',
          arguments: {
            'parkingName': name,
            'parkingLocation': location,
            'spacesLeft': spacesLeft,
            'pricePerHour': price,
          },
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.local_parking, color: color, size: 32),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          location,
                          style:
                              const TextStyle(fontSize: 13, color: Colors.grey),
                        ),
                      ),
                      const SizedBox(width: 8),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/map_directions',
                            arguments: {
                              'parkingName': name,
                              'parkingLocation': location,
                            },
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF4CAF50),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(Icons.directions,
                                  color: Colors.white, size: 14),
                              SizedBox(width: 4),
                              Text(
                                'Directions',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.local_parking,
                        size: 16,
                        color: spacesLeft > 20
                            ? const Color(0xFF4CAF50)
                            : spacesLeft > 10
                                ? Colors.orange
                                : Colors.red,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          '$spacesLeft spaces left',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            color: spacesLeft > 20
                                ? const Color(0xFF4CAF50)
                                : spacesLeft > 10
                                    ? Colors.orange
                                    : Colors.red,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          'UGX ${price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}/hr',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.end,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
