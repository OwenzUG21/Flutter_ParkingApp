import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import '../themes/colors.dart';
import '../services/parking_service.dart';
import '../services/booking_service.dart';
import '../services/notification_service.dart';
import '../services/translation_service.dart';

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
  final _parkingService = ParkingService();
  final _bookingService = BookingService();
  bool _isProcessing = false;

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

    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Professional Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
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
                    icon: Icon(
                      Icons.arrow_back,
                      color: theme.colorScheme.primary,
                    ),
                    onPressed: () => Navigator.pop(context),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Book Parking',
                    style: TextStyle(
                      color: theme.colorScheme.primary,
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
                        color: theme.colorScheme.surface,
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
                                  color: theme.colorScheme.primary.withValues(
                                    alpha: 0.1,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.local_parking_rounded,
                                  color: theme.colorScheme.primary,
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
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: theme.colorScheme.onSurface,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.location_on,
                                          size: 14,
                                          color: theme.colorScheme.onSurface
                                              .withValues(alpha: 0.6),
                                        ),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            widget.parkingLocation,
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: theme.colorScheme.onSurface
                                                  .withValues(alpha: 0.6),
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
                    Text(
                      'Vehicle Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
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
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 2,
                          color: theme.colorScheme.onSurface,
                        ),
                        decoration: InputDecoration(
                          hintText: 'e.g., UAH 123X',
                          hintStyle: TextStyle(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.4,
                            ),
                            fontWeight: FontWeight.normal,
                            letterSpacing: 1,
                          ),
                          prefixIcon: Icon(
                            Icons.directions_car,
                            color: theme.colorScheme.primary,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: theme.colorScheme.surface,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Date Section
                    Text(
                      'Parking Date',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime.now().subtract(
                            const Duration(days: 365),
                          ),
                          lastDate: DateTime.now().add(
                            const Duration(days: 365),
                          ),
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
                          color: theme.colorScheme.surface,
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
                                color: theme.colorScheme.primary.withValues(
                                  alpha: 0.1,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                Icons.calendar_today,
                                color: theme.colorScheme.primary,
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
                                      color: theme.colorScheme.onSurface
                                          .withValues(alpha: 0.6),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: theme.colorScheme.onSurface,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: theme.colorScheme.onSurface.withValues(
                                alpha: 0.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Duration Section
                    Text(
                      'Duration',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
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
                    Text(
                      'Parking Time',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
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
                        onPressed: _isProcessing
                            ? null
                            : () async {
                                if (_vehiclePlateController.text
                                    .trim()
                                    .isEmpty) {
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: const Text(
                                          'Please enter vehicle number plate',
                                        ),
                                        backgroundColor: Colors.red.shade400,
                                        behavior: SnackBarBehavior.floating,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
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
                                        content: const Text(
                                          'Please select a time',
                                        ),
                                        backgroundColor: Colors.red.shade400,
                                        behavior: SnackBarBehavior.floating,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                  return;
                                }

                                if (!_isTimeAvailable(
                                  selectedDate,
                                  selectedTime!,
                                )) {
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: const Text(
                                          'Please select a more recent time for today',
                                        ),
                                        backgroundColor: Colors.red.shade400,
                                        behavior: SnackBarBehavior.floating,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                  return;
                                }

                                setState(() => _isProcessing = true);

                                try {
                                  // Calculate hours based on duration
                                  final hours = _durationHours();
                                  final parkingRate =
                                      widget.pricePerHour * hours;
                                  final serviceFee =
                                      (parkingRate * 0.15).round();
                                  final totalCost = parkingRate + serviceFee;
                                  final plateNumber = _vehiclePlateController
                                      .text
                                      .trim()
                                      .toUpperCase();
                                  final slotNumber =
                                      widget.slotNumber?.toString() ?? 'A001';

                                  // Calculate booking start time
                                  final bookingStartTime = DateTime(
                                    selectedDate.year,
                                    selectedDate.month,
                                    selectedDate.day,
                                    selectedTime!.hour,
                                    selectedTime!.minute,
                                  );

                                  // Create booking in database (this persists!)
                                  final booking =
                                      await _bookingService.createBooking(
                                    plateNumber: plateNumber,
                                    slotNumber: slotNumber,
                                    startTime: bookingStartTime,
                                    durationHours: hours,
                                    parkingRate: parkingRate.toDouble(),
                                    serviceFee: serviceFee.toDouble(),
                                    vehicleType: 'car',
                                    notes: 'Booking from ${widget.parkingName}',
                                    parkingName: widget.parkingName,
                                    parkingLocation: widget.parkingLocation,
                                  );

                                  print(
                                    '✅ Booking created in database: ID ${booking.id}, Plate: $plateNumber, Slot: $slotNumber',
                                  );

                                  setState(() => _isProcessing = false);

                                  // Trigger booking completed notification
                                  await NotificationService()
                                      .showBookingCompletedNotification(
                                    parkingName: widget.parkingName,
                                    bookingDate: selectedDate,
                                    slotNumber: slotNumber,
                                  );

                                  // Schedule notification for when booking becomes active
                                  if (bookingStartTime.isAfter(
                                    DateTime.now(),
                                  )) {
                                    await NotificationService()
                                        .scheduleBookingActiveNotification(
                                      parkingName: widget.parkingName,
                                      scheduledTime: bookingStartTime,
                                      slotNumber: slotNumber,
                                      notificationId: DateTime.now()
                                              .millisecondsSinceEpoch %
                                          100000,
                                    );
                                  } else {
                                    // If booking is for now, show parking started notification
                                    await NotificationService()
                                        .showParkingStartedNotification(
                                      parkingName: widget.parkingName,
                                      slotNumber: slotNumber,
                                    );
                                  }

                                  if (mounted) {
                                    // Navigate to dashboard Reserve tab
                                    Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      '/dashboard',
                                      (route) => false,
                                      arguments: {
                                        'initialTab': 1, // Reserve tab index
                                        'bookingId':
                                            booking.id, // Pass booking ID
                                      },
                                    );
                                  }
                                } catch (e) {
                                  setState(() => _isProcessing = false);
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Error creating booking: $e',
                                        ),
                                        backgroundColor: Colors.red.shade400,
                                        behavior: SnackBarBehavior.floating,
                                      ),
                                    );
                                  }
                                }
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
                        child: _isProcessing
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'Proceed to Reserve',
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
          color: theme.colorScheme.surface,
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
              gap: 4, // Reduced from 6 to 4
              activeColor: Colors.white,
              iconSize: 24,
              padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 12), // Reduced from 16 to 12
              duration: const Duration(milliseconds: 400),
              tabBackgroundColor: AppColors.redButton,
              color: Colors.grey.shade600,
              textSize: 11, // Reduced from 12 to 11
              tabs: [
                GButton(icon: Icons.home_rounded, text: 'home'.tr(context)),
                GButton(
                    icon: Icons.groups_rounded, text: 'community'.tr(context)),
                GButton(
                    icon: Icons.person_rounded, text: 'profile'.tr(context)),
                GButton(
                    icon: Icons.settings_rounded, text: 'settings'.tr(context)),
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
    final theme = Theme.of(context);
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
                ? theme.colorScheme.primary
                : theme.colorScheme.surface,
            foregroundColor: isSelected
                ? theme.colorScheme.onPrimary
                : theme.colorScheme.primary,
            elevation: isSelected ? 4 : 0,
            shadowColor: isSelected
                ? theme.colorScheme.primary.withValues(alpha: 0.3)
                : Colors.transparent,
            side: isSelected
                ? null
                : BorderSide(
                    color: theme.brightness == Brightness.dark
                        ? theme.colorScheme.outline
                        : Colors.grey.shade300,
                    width: 1.5,
                  ),
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
              color: isSelected
                  ? theme.colorScheme.onPrimary
                  : theme.colorScheme.primary,
            ),
          ),
        ),
      ),
    );
  }

  // Helper methods to get coordinates for different locations
  double _getLatitudeForLocation(String location) {
    // Sample coordinates for Uganda locations
    if (location.toLowerCase().contains('kololo')) {
      return 0.3476; // Kololo, Kampala
    } else if (location.toLowerCase().contains('kampala')) {
      return 0.3476; // Kampala city center
    } else if (location.toLowerCase().contains('jinja')) {
      return 0.4314; // Jinja
    } else if (location.toLowerCase().contains('entebbe')) {
      return 0.0564; // Entebbe
    }
    return 0.3476; // Default to Kampala
  }

  double _getLongitudeForLocation(String location) {
    // Sample coordinates for Uganda locations
    if (location.toLowerCase().contains('kololo')) {
      return 32.6052; // Kololo, Kampala
    } else if (location.toLowerCase().contains('kampala')) {
      return 32.6052; // Kampala city center
    } else if (location.toLowerCase().contains('jinja')) {
      return 33.2042; // Jinja
    } else if (location.toLowerCase().contains('entebbe')) {
      return 32.4432; // Entebbe
    }
    return 32.6052; // Default to Kampala
  }
}
