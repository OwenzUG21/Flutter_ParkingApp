import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import '../themes/colors.dart';

void main() {
  runApp(const ParkingBookingApp());
}

class ParkingBookingApp extends StatelessWidget {
  const ParkingBookingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Parking Booking',
      theme: ThemeData(primarySwatch: Colors.indigo, fontFamily: 'Roboto'),
      debugShowCheckedModeBanner: false,
      home: const BookingScreen(),
    );
  }
}

class BookingScreen extends StatefulWidget {
  final String parkingName;
  final String parkingLocation;
  final int spacesLeft;
  final int pricePerHour;
  final int? slotNumber;
  final String? imagePath;

  const BookingScreen({
    super.key,
    this.parkingName = 'Acacia Mall Parking',
    this.parkingLocation = 'Kololo, Kampala',
    this.spacesLeft = 45,
    this.pricePerHour = 5000,
    this.slotNumber,
    this.imagePath,
  });

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  String selectedDuration = '1 Hr';
  DateTime selectedDate = DateTime.now();
  TimeOfDay? selectedTime;
  int selectedNavIndex = 0;
  final TextEditingController _vehiclePlateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Set default time to current time
    selectedTime = TimeOfDay.now();
  }

  @override
  void dispose() {
    _vehiclePlateController.dispose();
    super.dispose();
  }

  bool _isTimeAvailable(DateTime date, TimeOfDay time) {
    // Allow 24/7 parking - no time restrictions

    // If the date is in the future, any time is valid
    final today = DateTime.now();
    final selectedDateOnly = DateTime(date.year, date.month, date.day);
    final todayDateOnly = DateTime(today.year, today.month, today.day);

    if (selectedDateOnly.isAfter(todayDateOnly)) {
      // Future date - allow any time for advance booking
      return true;
    }

    // For today, allow any time that hasn't passed by more than 1 hour
    // This gives flexibility for immediate bookings
    final now = DateTime.now();
    final chosen = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

    final oneHourAgo = now.subtract(const Duration(hours: 1));
    return chosen.isAfter(oneHourAgo);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: Color(0xFF5B6B9E)),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      // Allow any time - 24/7 parking available
      setState(() {
        selectedTime = picked;
      });
    }
  }

  int _durationHours() {
    if (selectedDuration == '2 Hr') {
      return 2;
    }
    if (selectedDuration == '3 Hr') {
      return 3;
    }
    if (selectedDuration == 'All Day') {
      return 8;
    }
    return 1;
  }

  TimeOfDay? _calculateEndTime(TimeOfDay? start, int hours) {
    if (start == null) {
      return null;
    }
    final endHour = (start.hour + hours) % 24;
    return TimeOfDay(hour: endHour, minute: start.minute);
  }

  String _formatTime(TimeOfDay? time) {
    if (time == null) {
      return 'Select time';
    }
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    final durationHours = _durationHours();
    final endTime = _calculateEndTime(selectedTime, durationHours);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: Column(
          children: [
            // Professional Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Color(0xFF5B6B9E),
                    ),
                    onPressed: () => Navigator.pop(context),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Book Parking',
                    style: TextStyle(
                      color: Color(0xFF5B6B9E),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),

            // Main Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Location Card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.06),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFF5B6B9E,
                                  ).withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.local_parking_rounded,
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
                                      widget.parkingName,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF111827),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.location_on,
                                          size: 14,
                                          color: Colors.grey.shade600,
                                        ),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            widget.parkingLocation,
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey.shade600,
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
                          const Divider(height: 1),
                          const SizedBox(height: 16),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              _buildInfoChip(
                                icon: Icons.event_available,
                                label: '${widget.spacesLeft} Available',
                                color: widget.spacesLeft > 20
                                    ? Colors.green
                                    : widget.spacesLeft > 10
                                    ? Colors.orange
                                    : Colors.red,
                              ),
                              _buildInfoChip(
                                icon: Icons.confirmation_number,
                                label: 'Slot ${widget.slotNumber ?? '--'}',
                                color: const Color(0xFF5B6B9E),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF5B6B9E),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'UGX ${widget.pricePerHour}/hr',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Vehicle Number Plate Section
                    const Text(
                      'Vehicle Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _vehiclePlateController,
                        textCapitalization: TextCapitalization.characters,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 2,
                        ),
                        decoration: InputDecoration(
                          hintText: 'e.g., UAH 123X',
                          hintStyle: TextStyle(
                            color: Colors.grey.shade400,
                            fontWeight: FontWeight.normal,
                            letterSpacing: 1,
                          ),
                          prefixIcon: const Icon(
                            Icons.directions_car,
                            color: Color(0xFF5B6B9E),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Date Section
                    const Text(
                      'Parking Date',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2026),
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: const ColorScheme.light(
                                  primary: Color(0xFF5B6B9E),
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (date != null && mounted) {
                          setState(() {
                            selectedDate = date;
                          });
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color(
                                  0xFF5B6B9E,
                                ).withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.calendar_today,
                                color: Color(0xFF5B6B9E),
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Selected Date',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF111827),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Duration Section
                    const Text(
                      'Duration',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _buildDurationButton('1 Hr'),
                        const SizedBox(width: 10),
                        _buildDurationButton('2 Hr'),
                        const SizedBox(width: 10),
                        _buildDurationButton('3 Hr'),
                        const SizedBox(width: 10),
                        _buildDurationButton('All Day'),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Time Section
                    const Text(
                      'Parking Time',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: _pickTime,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF5B6B9E), Color(0xFF4A5A8E)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(
                                0xFF5B6B9E,
                              ).withValues(alpha: 0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Start Time',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    _formatTime(selectedTime),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 1,
                              height: 40,
                              color: Colors.white.withValues(alpha: 0.3),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'End Time',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    _formatTime(endTime),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.access_time,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Proceed Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_vehiclePlateController.text.trim().isEmpty) {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text(
                                    'Please enter vehicle number plate',
                                  ),
                                  backgroundColor: Colors.red.shade400,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              );
                            }
                            return;
                          }

                          if (selectedTime == null) {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text('Please select a time'),
                                  backgroundColor: Colors.red.shade400,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              );
                            }
                            return;
                          }

                          if (!_isTimeAvailable(selectedDate, selectedTime!)) {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text(
                                    'Please select a more recent time for today',
                                  ),
                                  backgroundColor: Colors.red.shade400,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              );
                            }
                            return;
                          }

                          // Calculate hours based on duration
                          final hours = _durationHours();

                          // Calculate total cost
                          final parkingRate = widget.pricePerHour * hours;
                          final serviceFee = (parkingRate * 0.15).round();
                          final totalCost = parkingRate + serviceFee;

                          // Navigate to reservation screen with details
                          Navigator.pushNamed(
                            context,
                            '/reservation',
                            arguments: {
                              'parkingName': widget.parkingName,
                              'parkingLocation': widget.parkingLocation,
                              'date': selectedDate,
                              'duration': selectedDuration,
                              'hours': hours,
                              'parkingRate': parkingRate,
                              'serviceFee': serviceFee,
                              'totalCost': totalCost,
                              'slotNumber': widget.slotNumber,
                              'startTime': selectedTime,
                              'vehiclePlate': _vehiclePlateController.text
                                  .trim()
                                  .toUpperCase(),
                              'imagePath': widget.imagePath,
                            },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.redButton,
                          foregroundColor: Colors.white,
                          elevation: 4,
                          shadowColor: AppColors.redButton.withValues(
                            alpha: 0.4,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          'Proceed to Payment',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withValues(alpha: 0.1),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 12),
            child: GNav(
              rippleColor: Colors.grey.withValues(alpha: 0.1),
              hoverColor: Colors.grey.withValues(alpha: 0.05),
              gap: 6,
              activeColor: Colors.white,
              iconSize: 24,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              duration: const Duration(milliseconds: 400),
              tabBackgroundColor: AppColors.redButton,
              color: Colors.grey.shade600,
              textSize: 12,
              tabs: const [
                GButton(icon: Icons.home_rounded, text: 'Home'),
                GButton(icon: Icons.groups_rounded, text: 'Community'),
                GButton(icon: Icons.person_rounded, text: 'Profile'),
                GButton(icon: Icons.settings_rounded, text: 'Settings'),
              ],
              selectedIndex: selectedNavIndex,
              onTabChange: (index) {
                setState(() {
                  selectedNavIndex = index;
                });

                // Navigate based on selection
                if (index == 0) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/dashboard',
                    (route) => false,
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDurationButton(String duration) {
    final isSelected = selectedDuration == duration;
    return Expanded(
      child: SizedBox(
        height: 48,
        child: ElevatedButton(
          onPressed: () {
            setState(() {
              selectedDuration = duration;
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: isSelected
                ? const Color(0xFF5B6B9E)
                : Colors.white,
            foregroundColor: isSelected
                ? Colors.white
                : const Color(0xFF5B6B9E),
            elevation: isSelected ? 4 : 0,
            shadowColor: isSelected
                ? const Color(0xFF5B6B9E).withValues(alpha: 0.3)
                : Colors.transparent,
            side: isSelected
                ? null
                : BorderSide(color: Colors.grey.shade300, width: 1.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: EdgeInsets.zero,
          ),
          child: Text(
            duration,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : const Color(0xFF5B6B9E),
            ),
          ),
        ),
      ),
    );
  }
}
