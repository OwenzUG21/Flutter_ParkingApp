import 'package:flutter/material.dart';

class ParkingSpotsScreen extends StatelessWidget {
  const ParkingSpotsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF5B6B9E),
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
                        Icon(
                          Icons.location_on,
                          color: Colors.white,
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Current Location',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
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
                        children: const [
                          Icon(Icons.search, color: Colors.grey),
                          SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Search parking spots...',
                                border: InputBorder.none,
                                hintStyle: TextStyle(color: Colors.grey),
                              ),
                            ),
                          ),
                          Icon(Icons.tune, color: Colors.grey),
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
                                  color: const Color(0xFF5B6B9E).withOpacity(0.7),
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
                    
                    _buildParkingSpot(
                      context,
                      'Acacia Mall Parking',
                      'Kololo, Kampala',
                      45,
                      5000,
                      const Color(0xFF5B6B9E),
                    ),
                    const SizedBox(height: 12),
                    
                    _buildParkingSpot(
                      context,
                      'Garden City Parking',
                      'Kampala Road',
                      32,
                      4500,
                      const Color(0xFFFF6B6B),
                    ),
                    const SizedBox(height: 12),
                    
                    _buildParkingSpot(
                      context,
                      'Oasis Mall Parking',
                      'Yusuf Lule Road',
                      18,
                      6000,
                      const Color(0xFF4CAF50),
                    ),
                    const SizedBox(height: 12),
                    
                    _buildParkingSpot(
                      context,
                      'Kampala Road Parking',
                      'City Center',
                      8,
                      3500,
                      const Color(0xFFB8956A),
                    ),
                    const SizedBox(height: 12),
                    
                    _buildParkingSpot(
                      context,
                      'Lugogo Mall Parking',
                      'Lugogo Bypass',
                      56,
                      5500,
                      const Color(0xFF5B6B9E),
                    ),
                    const SizedBox(height: 12),
                    
                    _buildParkingSpot(
                      context,
                      'Forest Mall Parking',
                      'Lugogo',
                      23,
                      4000,
                      const Color(0xFFFF6B6B),
                    ),
                    const SizedBox(height: 12),
                    
                    _buildParkingSpot(
                      context,
                      'Village Mall Parking',
                      'Bugolobi',
                      12,
                      7000,
                      const Color(0xFF4CAF50),
                    ),
                    const SizedBox(height: 12),
                    
                    _buildParkingSpot(
                      context,
                      'Metroplex Mall Parking',
                      'Naalya',
                      67,
                      6500,
                      const Color(0xFFB8956A),
                    ),
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
            child: Icon(
              Icons.local_parking,
              color: color,
              size: 32,
            ),
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
                Text(
                  location,
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.local_parking,
                      size: 16,
                      color: spacesLeft > 20 ? const Color(0xFF4CAF50) : 
                             spacesLeft > 10 ? Colors.orange : Colors.red,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        '$spacesLeft spaces left',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          color: spacesLeft > 20 ? const Color(0xFF4CAF50) : 
                                 spacesLeft > 10 ? Colors.orange : Colors.red,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        'UGX ${price.toString().replaceAllMapped(
                          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                          (Match m) => '${m[1]},',
                        )}/hr',
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
          Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: Colors.grey,
          ),
        ],
      ),
      ),
    );
  }
}
