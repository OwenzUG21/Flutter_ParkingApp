import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import '../themes/colors.dart';
import '../services/translation_service.dart';

void main() {
  runApp(const ReservationDetailsApp());
}

class ReservationDetailsApp extends StatelessWidget {
  const ReservationDetailsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reservation Details',
      theme: ThemeData(primarySwatch: Colors.indigo, fontFamily: 'Roboto'),
      debugShowCheckedModeBanner: false,
      home: ReservationDetailsScreen(),
    );
  }
}

class ReservationDetailsScreen extends StatefulWidget {
  final String parkingName;
  final String parkingLocation;
  final DateTime date;
  final String duration;
  final int hours;
  final int parkingRate;
  final int serviceFee;
  final int totalCost;
  final int? slotNumber;
  final TimeOfDay? startTime;
  final String? vehiclePlate;
  final String? imagePath;
  final String? reservationId;
  final int? parkingRecordId;

  ReservationDetailsScreen({
    super.key,
    this.parkingName = 'Acacia Mall Parking',
    this.parkingLocation = 'Kololo, Kampala',
    DateTime? date,
    this.duration = '2 Hr',
    this.hours = 2,
    this.parkingRate = 10000,
    this.serviceFee = 1500,
    this.totalCost = 11500,
    this.slotNumber,
    this.startTime,
    this.vehiclePlate,
    this.imagePath,
    this.reservationId,
    this.parkingRecordId,
  }) : date = date ?? DateTime(2025, 11, 16);

  @override
  State<ReservationDetailsScreen> createState() =>
      _ReservationDetailsScreenState();
}

class _ReservationDetailsScreenState extends State<ReservationDetailsScreen> {
  String selectedPaymentMethod = 'Mobile money';
  int selectedNavIndex = 0;

  @override
  void initState() {
    super.initState();
    print('🎫 ReservationDetailsScreen initialized');
    print('   ReservationId: ${widget.reservationId}');
    print('   ParkingRecordId: ${widget.parkingRecordId}');
    print('   VehiclePlate: ${widget.vehiclePlate}');
  }

  @override
  Widget build(BuildContext context) {
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
                    'Reservation Details',
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
                    // Parking Details Card
                    Container(
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
                          // Image Header
                          Stack(
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(16),
                                  topRight: Radius.circular(16),
                                ),
                                child: widget.imagePath != null
                                    ? Image.asset(
                                        widget.imagePath!,
                                        width: double.infinity,
                                        height: 160,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Container(
                                            width: double.infinity,
                                            height: 160,
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  const Color(
                                                    0xFF5B6B9E,
                                                  ).withValues(alpha: 0.8),
                                                  const Color(0xFF4A5A8E),
                                                ],
                                              ),
                                            ),
                                            child: const Icon(
                                              Icons.local_parking_rounded,
                                              size: 60,
                                              color: Colors.white,
                                            ),
                                          );
                                        },
                                      )
                                    : Container(
                                        width: double.infinity,
                                        height: 160,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              const Color(
                                                0xFF5B6B9E,
                                              ).withValues(alpha: 0.8),
                                              const Color(0xFF4A5A8E),
                                            ],
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.local_parking_rounded,
                                          size: 60,
                                          color: Colors.white,
                                        ),
                                      ),
                              ),
                              // Gradient Overlay
                              Container(
                                height: 160,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(16),
                                    topRight: Radius.circular(16),
                                  ),
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.black.withValues(alpha: 0.3),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),

                          // Details Section
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
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
                                        Icons.location_on,
                                        color: Color(0xFF5B6B9E),
                                        size: 20,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            widget.parkingName,
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color:
                                                  theme.colorScheme.onSurface,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            widget.parkingLocation,
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: theme.colorScheme.onSurface
                                                  .withValues(alpha: 0.6),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 20),
                                const Divider(height: 1),
                                const SizedBox(height: 20),

                                // Booking Info Grid
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildInfoItem(
                                        icon: Icons.calendar_today,
                                        label: 'Date',
                                        value:
                                            '${_getWeekday(widget.date)}, ${_getMonthName(widget.date.month)} ${widget.date.day}',
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: _buildInfoItem(
                                        icon: Icons.access_time,
                                        label: 'Duration',
                                        value: widget.duration,
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 16),

                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildInfoItem(
                                        icon: Icons.confirmation_number,
                                        label: 'Slot Number',
                                        value: widget.slotNumber?.toString() ??
                                            '--',
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: _buildInfoItem(
                                        icon: Icons.directions_car,
                                        label: 'Vehicle',
                                        value: widget.vehiclePlate ?? 'N/A',
                                      ),
                                    ),
                                  ],
                                ),

                                if (widget.startTime != null) ...[
                                  const SizedBox(height: 16),
                                  _buildInfoItem(
                                    icon: Icons.schedule,
                                    label: 'Start Time',
                                    value: _formatTime(widget.startTime!),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Payment Summary Card
                    Text(
                      'Payment Summary',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 12),

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
                        children: [
                          _buildSummaryRow(
                            'Parking rate (${widget.hours} hrs)',
                            'UGX ${_formatCurrency(widget.parkingRate)}',
                            icon: Icons.local_parking,
                          ),
                          const SizedBox(height: 16),
                          _buildSummaryRow(
                            'Service fee (15%)',
                            'UGX ${_formatCurrency(widget.serviceFee)}',
                            icon: Icons.receipt_long,
                          ),
                          const SizedBox(height: 16),
                          const Divider(height: 1),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withValues(
                                alpha: 0.1,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.payments,
                                      color: theme.colorScheme.primary,
                                      size: 24,
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      'Total Amount',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: theme.colorScheme.onSurface,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'UGX ${_formatCurrency(widget.totalCost)}',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Payment Method Section
                    Text(
                      'Payment Method',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 12),

                    _buildPaymentMethodButton(
                      'Mobile Money',
                      Icons.phone_android,
                      'Mobile money',
                      'Pay with MTN, Airtel Money',
                    ),

                    const SizedBox(height: 12),

                    _buildPaymentMethodButton(
                      'Credit Card',
                      Icons.credit_card,
                      'Credit card',
                      'Visa, Mastercard, Amex',
                    ),

                    const SizedBox(height: 32),

                    // Confirm Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          print(
                              '💳 Selected payment method: $selectedPaymentMethod');

                          if (selectedPaymentMethod == 'Mobile money') {
                            print('📱 Navigating to mobile money payment');
                            Navigator.pushNamed(
                              context,
                              '/mobile-money-payment',
                              arguments: {
                                'totalAmount': widget.totalCost,
                                'parkingName': widget.parkingName,
                                'parkingLocation': widget.parkingLocation,
                                'reservationId': widget.reservationId,
                                'parkingRecordId': widget.parkingRecordId,
                                'vehiclePlate': widget.vehiclePlate,
                                'slotNumber': widget.slotNumber?.toString(),
                                'duration': widget.duration,
                                'hours': widget.hours,
                              },
                            );
                          } else if (selectedPaymentMethod == 'Credit card') {
                            print('💳 Navigating to credit card payment');
                            Navigator.pushNamed(
                              context,
                              '/credit-card-payment',
                              arguments: {
                                'totalAmount': widget.totalCost,
                                'parkingName': widget.parkingName,
                                'parkingLocation': widget.parkingLocation,
                                'reservationId': widget.reservationId,
                                'parkingRecordId': widget.parkingRecordId,
                                'vehiclePlate': widget.vehiclePlate,
                                'slotNumber': widget.slotNumber?.toString(),
                                'duration': widget.duration,
                                'hours': widget.hours,
                              },
                            );
                          } else {
                            print(
                                '⚠️ Unknown payment method: $selectedPaymentMethod');
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Please select a payment method'),
                                backgroundColor: Colors.orange.shade600,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            );
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
                        child: Text(
                          'confirm_pay'.tr(context),
                          style: const TextStyle(
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

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Builder(
      builder: (context) {
        final theme = Theme.of(context);
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.brightness == Brightness.dark
                ? theme.colorScheme.surfaceContainerHighest
                : const Color(0xFFF5F7FA),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, size: 16, color: theme.colorScheme.primary),
                  const SizedBox(width: 6),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 11,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSummaryRow(
    String label,
    String value, {
    required IconData icon,
  }) {
    return Builder(
      builder: (context) {
        final theme = Theme.of(context);
        return Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPaymentMethodButton(
    String method,
    IconData icon,
    String value,
    String subtitle,
  ) {
    return Builder(
      builder: (context) {
        final theme = Theme.of(context);
        final isSelected = selectedPaymentMethod == value;

        return InkWell(
          onTap: () {
            setState(() {
              selectedPaymentMethod = value;
              print('💳 Payment method selected: $value');
            });
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.brightness == Brightness.dark
                        ? theme.colorScheme.outline
                        : Colors.grey.shade300,
                width: isSelected ? 2 : 1,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: theme.colorScheme.primary.withValues(alpha: 0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : [],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? theme.colorScheme.primary.withValues(alpha: 0.1)
                        : theme.brightness == Brightness.dark
                            ? theme.colorScheme.surfaceContainerHighest
                            : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    color: isSelected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        method,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isSelected
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.6,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (isSelected)
                  Icon(
                    Icons.check_circle,
                    color: theme.colorScheme.primary,
                    size: 24,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatCurrency(int amount) {
    return amount.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  String _getWeekday(DateTime date) {
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return weekdays[date.weekday - 1];
  }

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }
}
