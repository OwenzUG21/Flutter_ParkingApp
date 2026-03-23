import 'package:flutter/foundation.dart';

class ReservationManager extends ChangeNotifier {
  static final ReservationManager _instance = ReservationManager._internal();

  static ReservationManager get instance => _instance;

  ReservationManager._internal();

  final List<Map<String, dynamic>> _reservations = [
    // Active Sessions
    {
      'reservationId': 'RES-1',
      'location': 'Boazi Parking',
      'spot': 'ZCDV',
      'address': '8 Nakasero Ln, Kampala, Uganda',
      'date': '2026-03-06',
      'timeRange': '17:55 - 19:55',
      'duration': '2h 0m',
      'time': 'Mar 6, 5:55pm - 7:55pm',
      'cost': 'UGX 5,000.00',
      'status': 'Active',
      'paymentStatus': 'Payment pending',
      'phone': '0771234567',
      'provider': 'MTN',
      'imagePath': 'lib/assets/images/bd.jpg',
    },
    {
      'reservationId': 'RES-2',
      'location': 'Acacia Mall Parking',
      'spot': 'UAH-123',
      'address': 'Kololo, Kampala, Uganda',
      'date': '2026-03-06',
      'timeRange': '14:00 - 18:00',
      'duration': '4h 0m',
      'time': 'Mar 6, 2:00pm - 6:00pm',
      'cost': 'UGX 20,000.00',
      'status': 'Active',
      'paymentStatus': 'Paid',
      'phone': '0771234567',
      'provider': 'MTN',
      'imagePath': 'lib/assets/images/bd.jpg',
    },
    // Upcoming Sessions
    {
      'reservationId': 'RES-3',
      'location': 'Garden City Parking',
      'spot': 'UBB-456',
      'address': 'Kira Rd, Kampala, Uganda',
      'date': '2026-03-07',
      'timeRange': '09:00 - 12:00',
      'duration': '3h 0m',
      'time': 'Mar 7, 9:00am - 12:00pm',
      'cost': 'UGX 18,000.00',
      'status': 'Upcoming',
      'paymentStatus': 'Payment pending',
      'phone': '0709876543',
      'provider': 'Airtel',
      'imagePath': 'lib/assets/images/Kampala-ciuty.jpg',
    },
    {
      'reservationId': 'RES-4',
      'location': 'Kampala Road Parking',
      'spot': 'UCC-789',
      'address': 'Central Division, Kampala',
      'date': '2026-03-08',
      'timeRange': '10:00 - 14:00',
      'duration': '4h 0m',
      'time': 'Mar 8, 10:00am - 2:00pm',
      'cost': 'UGX 18,000.00',
      'status': 'Upcoming',
      'paymentStatus': 'Paid',
      'phone': '0771234567',
      'provider': 'MTN',
      'imagePath': 'lib/assets/images/ka1.jpg',
    },
    // History (Completed & Cancelled)
    {
      'reservationId': 'RES-5',
      'location': 'Acacia Mall Parking',
      'spot': 'P2-05, Kololo',
      'address': 'Kololo, Kampala, Uganda',
      'date': '2026-02-18',
      'timeRange': '14:00 - 16:00',
      'duration': '2h 0m',
      'time': 'Feb 18, 2pm - 4pm',
      'cost': 'UGX 10,000',
      'status': 'Completed',
      'paymentStatus': 'Paid',
      'phone': '0771234567',
      'provider': 'MTN',
      'imagePath': 'lib/assets/images/bd.jpg',
    },
    {
      'reservationId': 'RES-6',
      'location': 'Garden City Parking',
      'spot': 'Level 3, B-12',
      'address': 'Kira Rd, Kampala, Uganda',
      'date': '2026-02-15',
      'timeRange': '14:00 - 17:00',
      'duration': '3h 0m',
      'time': 'Feb 15, 2pm - 5pm',
      'cost': 'UGX 15,000',
      'status': 'Cancelled',
      'paymentStatus': 'Refunded',
      'phone': '0709876543',
      'provider': 'Airtel',
      'imagePath': 'lib/assets/images/Kampala-ciuty.jpg',
    },
    {
      'reservationId': 'RES-7',
      'location': 'Kampala Road Parking',
      'spot': 'Ground Floor, A-08',
      'address': 'Central Division, Kampala',
      'date': '2026-02-14',
      'timeRange': '10:00 - 12:00',
      'duration': '2h 0m',
      'time': 'Feb 14, 10am - 12pm',
      'cost': 'UGX 10,000',
      'status': 'Completed',
      'paymentStatus': 'Paid',
      'phone': '0771234567',
      'provider': 'MTN',
      'imagePath': 'lib/assets/images/ka1.jpg',
    },
  ];

  bool _hasNewReservation = true;

  List<Map<String, dynamic>> get reservations => _reservations;

  bool get hasNewReservation => _hasNewReservation;

  void markAsRead() {
    _hasNewReservation = false;
  }

  void addReservation(Map<String, dynamic> reservation) {
    _reservations.insert(0, reservation);
    _hasNewReservation = true;
    notifyListeners();
  }

  void updateReservationPaymentStatus(
    String reservationId,
    String paymentStatus,
  ) {
    final index = _reservations.indexWhere(
      (r) => r['reservationId'] == reservationId,
    );
    if (index != -1) {
      _reservations[index]['paymentStatus'] = paymentStatus;
      notifyListeners();
      print('✅ Payment status updated for $reservationId to $paymentStatus');
    } else {
      print('❌ Reservation not found: $reservationId');
    }
  }

  void endSession(String reservationId) {
    final index = _reservations.indexWhere(
      (r) => r['reservationId'] == reservationId,
    );
    if (index != -1) {
      _reservations[index]['status'] = 'Completed';
      if (_reservations[index]['paymentStatus'] == 'Payment pending') {
        _reservations[index]['paymentStatus'] = 'Cancelled';
      }
      notifyListeners();
    }
  }

  void cancelReservation(String reservationId) {
    final index = _reservations.indexWhere(
      (r) => r['reservationId'] == reservationId,
    );
    if (index != -1) {
      _reservations[index]['status'] = 'Cancelled';
      if (_reservations[index]['paymentStatus'] == 'Paid') {
        _reservations[index]['paymentStatus'] = 'Refunded';
      } else {
        _reservations[index]['paymentStatus'] = 'Cancelled';
      }
      notifyListeners();
    }
  }

  Map<String, dynamic>? getReservationById(String reservationId) {
    try {
      return _reservations.firstWhere(
        (r) => r['reservationId'] == reservationId,
      );
    } catch (e) {
      return null;
    }
  }
}
