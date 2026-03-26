import 'package:flutter/foundation.dart';

/// Singleton manager for handling reservations and notifications
class ReservationManager extends ChangeNotifier {
  static final ReservationManager _instance = ReservationManager._internal();
  static ReservationManager get instance => _instance;

  ReservationManager._internal();

  final List<Map<String, dynamic>> _reservations = [];
  int _unreadCount = 0;

  List<Map<String, dynamic>> get reservations =>
      List.unmodifiable(_reservations);
  int get unreadCount => _unreadCount;

  /// Add a new reservation
  void addReservation(Map<String, dynamic> reservation) {
    _reservations.add(reservation);
    _unreadCount++;
    notifyListeners();
  }

  /// Update reservation payment status
  void updateReservationPaymentStatus(String reservationId, String status) {
    final index = _reservations.indexWhere(
      (r) => r['reservationId'] == reservationId,
    );
    if (index != -1) {
      _reservations[index]['paymentStatus'] = status;
      notifyListeners();
    }
  }

  /// End a parking session
  void endSession(String reservationId) {
    final index = _reservations.indexWhere(
      (r) => r['reservationId'] == reservationId,
    );
    if (index != -1) {
      _reservations[index]['status'] = 'Completed';
      notifyListeners();
    }
  }

  /// Mark all reservations as read
  void markAsRead() {
    _unreadCount = 0;
    notifyListeners();
  }

  /// Clear all reservations
  void clear() {
    _reservations.clear();
    _unreadCount = 0;
    notifyListeners();
  }
}
