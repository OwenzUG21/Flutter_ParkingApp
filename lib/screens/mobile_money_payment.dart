import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import '../models/reservation_manager.dart';
import '../themes/colors.dart';
import '../services/notification_service.dart';
import '../services/booking_service.dart';
import '../services/preferences_service.dart';
import '../services/translation_service.dart';

// Phone number formatter for Uganda format: 0700 000 000
class PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Remove all non-digit characters
    String digitsOnly = newValue.text.replaceAll(RegExp(r'\D'), '');

    // Limit to 10 digits
    if (digitsOnly.length > 10) {
      digitsOnly = digitsOnly.substring(0, 10);
    }

    // Format with spaces: 0700 000 000
    String formatted = '';
    for (int i = 0; i < digitsOnly.length; i++) {
      if (i == 4 || i == 7) {
        formatted += ' ';
      }
      formatted += digitsOnly[i];
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class MobileMoneyPaymentScreen extends StatefulWidget {
  final int totalAmount;
  final String parkingName;
  final String parkingLocation;
  final String? reservationId;
  final int? parkingRecordId;
  final String? vehiclePlate;
  final String? slotNumber;
  final String? duration;
  final int? hours;

  const MobileMoneyPaymentScreen({
    super.key,
    this.totalAmount = 11500,
    this.parkingName = 'Acacia Mall Parking',
    this.parkingLocation = 'Kololo, Kampala',
    this.reservationId,
    this.parkingRecordId,
    this.vehiclePlate,
    this.slotNumber,
    this.duration,
    this.hours,
  });

  @override
  State<MobileMoneyPaymentScreen> createState() =>
      _MobileMoneyPaymentScreenState();
}

class _MobileMoneyPaymentScreenState extends State<MobileMoneyPaymentScreen> {
  String selectedProvider = 'MTN';
  final TextEditingController phoneController = TextEditingController();
  int selectedNavIndex = 0;
  final _bookingService = BookingService();
  PreferencesService? _prefsService;

  @override
  void initState() {
    super.initState();
    _initPrefs();
    print('💰 MobileMoneyPaymentScreen initialized');
    print('   ReservationId: ${widget.reservationId}');
    print('   ParkingRecordId: ${widget.parkingRecordId}');
    print('   VehiclePlate: ${widget.vehiclePlate}');
    print('   TotalAmount: ${widget.totalAmount}');
  }

  Future<void> _initPrefs() async {
    _prefsService = await PreferencesService.getInstance();
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
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
                    'Mobile Money Payment',
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
                    // Booking Info Card
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
                      child: Row(
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
                              size: 32,
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
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: theme.colorScheme.onSurface,
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
                    ),

                    const SizedBox(height: 24),

                    // Amount to Pay Card
                    Text(
                      'Amount to Pay',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF5B6B9E), Color(0xFF4A5A8E)],
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
                      child: Column(
                        children: [
                          const Text(
                            'Total Amount',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'UGX ${_formatCurrency(widget.totalAmount)}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Select Provider
                    Text(
                      'Select Provider',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildProviderButton(
                            'MTN',
                            Colors.yellow.shade700,
                            Colors.black,
                            selectedProvider == 'MTN',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildProviderButton(
                            'Airtel',
                            Colors.red.shade600,
                            Colors.white,
                            selectedProvider == 'Airtel',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildProviderButton(
                            'Africell',
                            Colors.blue.shade700,
                            Colors.white,
                            selectedProvider == 'Africell',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildProviderButton(
                            'M-Cash',
                            Colors.green.shade700,
                            Colors.white,
                            selectedProvider == 'M-Cash',
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Phone Number
                    Text(
                      'Phone Number',
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
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          PhoneNumberFormatter(),
                          LengthLimitingTextInputFormatter(
                              12), // 10 digits + 2 spaces
                        ],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onSurface,
                        ),
                        decoration: InputDecoration(
                          hintText: '0700 000 000',
                          hintStyle: TextStyle(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.4,
                            ),
                            fontWeight: FontWeight.normal,
                          ),
                          prefixIcon: Icon(
                            Icons.phone,
                            color: theme.colorScheme.primary,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: theme.colorScheme.surface,
                          contentPadding: const EdgeInsets.all(16),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Instructions
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.blue.shade200),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Colors.blue.shade700,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'You will receive a prompt on your phone to complete the payment.',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF111827),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Pay Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () async {
                          // Remove spaces and validate phone number
                          String phoneNumber =
                              phoneController.text.replaceAll(' ', '');

                          if (phoneNumber.isEmpty) {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text(
                                    'Please enter your phone number',
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

                          if (phoneNumber.length != 10) {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text(
                                    'Phone number must be exactly 10 digits',
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

                          // Show payment processing dialog
                          if (!mounted) return;
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (dialogContext) => AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  CircularProgressIndicator(
                                    color: Color(0xFF5B6B9E),
                                  ),
                                  SizedBox(height: 20),
                                  Text(
                                    'Processing payment...',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Please check your phone for the payment prompt',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );

                          try {
                            // Simulate payment processing
                            await Future.delayed(const Duration(seconds: 4));

                            // Process payment in database
                            // Update payment status in database
                            if (widget.parkingRecordId != null) {
                              print(
                                '💾 Marking booking as paid: ${widget.parkingRecordId}',
                              );

                              // Mark booking as paid (does NOT set exitTime)
                              await _bookingService.markBookingAsPaid(
                                widget.parkingRecordId!,
                                'mobile_money',
                                phoneNumber, // Use cleaned phone number
                              );

                              print('✅ Booking marked as paid in database');

                              // Update in-memory reservation manager (for backward compatibility)
                              if (widget.reservationId != null) {
                                print(
                                  '🔄 Updating payment status for: ${widget.reservationId}',
                                );
                                ReservationManager.instance
                                    .updateReservationPaymentStatus(
                                  widget.reservationId!,
                                  'Paid',
                                );
                                print('✅ Payment status update called');
                              }
                            } else {
                              print('❌ No parkingRecordId provided!');
                            }

                            // Close the dialog
                            if (!mounted) return;
                            Navigator.of(context).pop();

                            // Trigger payment success notification
                            await NotificationService()
                                .showPaymentCompletedNotification(
                              amount: widget.totalAmount.toDouble(),
                              parkingName: widget.parkingName,
                            );

                            // Save payment method phone number
                            if (_prefsService != null &&
                                phoneNumber.isNotEmpty) {
                              if (selectedProvider == 'MTN') {
                                await _prefsService!.saveMtnNumber(phoneNumber);
                                print('✅ Saved MTN number: $phoneNumber');
                              } else if (selectedProvider == 'Airtel') {
                                await _prefsService!
                                    .saveAirtelNumber(phoneNumber);
                                print('✅ Saved Airtel number: $phoneNumber');
                              }
                            }

                            // Show success message
                            if (!mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Row(
                                  children: [
                                    Icon(
                                      Icons.check_circle,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 12),
                                    Text('Payment successful!'),
                                  ],
                                ),
                                backgroundColor: Colors.green.shade600,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            );

                            // Navigate back to dashboard Reserve tab
                            if (!mounted) return;
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              '/dashboard',
                              (route) => false,
                              arguments: {
                                'initialTab': 1, // Reserve tab
                              },
                            );
                          } catch (e) {
                            // Close dialog
                            if (!mounted) return;
                            Navigator.of(context).pop();

                            // Show error
                            if (!mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Payment failed: $e'),
                                backgroundColor: Colors.red.shade400,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade600,
                          foregroundColor: Colors.white,
                          elevation: 4,
                          shadowColor: Colors.green.shade600.withValues(
                            alpha: 0.4,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Text(
                          'pay_now'.tr(context),
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
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
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

  Widget _buildProviderButton(
    String provider,
    Color bgColor,
    Color textColor,
    bool isSelected,
  ) {
    final theme = Theme.of(context);

    // Improve text contrast for light mode
    Color finalTextColor = textColor;
    if (theme.brightness == Brightness.light) {
      // For light mode, ensure better contrast
      if (provider == 'MTN') {
        finalTextColor = Colors.black87; // Better contrast on yellow
      } else if (provider == 'Airtel') {
        finalTextColor = Colors.white; // Keep white on red
      } else if (provider == 'Africell') {
        finalTextColor = Colors.white; // Keep white on blue
      } else if (provider == 'M-Cash') {
        finalTextColor = Colors.white; // Keep white on green
      }
    }

    return InkWell(
      onTap: () {
        setState(() {
          selectedProvider = provider;
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? (theme.brightness == Brightness.dark
                    ? Colors.white
                    : const Color(0xFF111827))
                : Colors.transparent,
            width: 3,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Center(
          child: Text(
            provider,
            style: TextStyle(
              color: finalTextColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              shadows: theme.brightness == Brightness.light && provider == 'MTN'
                  ? null // No shadow needed for black text on yellow
                  : [
                      Shadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                    ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatCurrency(int amount) {
    return amount.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
  }
}
