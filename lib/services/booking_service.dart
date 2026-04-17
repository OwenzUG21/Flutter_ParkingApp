import 'package:drift/drift.dart';
import '../database/app_database.dart';
import 'drift_service.dart';
import 'parking_service.dart';

/// Service for managing parking bookings with database persistence
/// Ensures bookings survive app restarts
class BookingService {
  static final BookingService _instance = BookingService._internal();
  factory BookingService() => _instance;
  BookingService._internal();

  final _driftService = DriftService();
  final _parkingService = ParkingService();

  // ========== BOOKING MANAGEMENT ==========

  /// Create a new booking
  Future<ParkingRecord> createBooking({
    required String plateNumber,
    required String slotNumber,
    required DateTime startTime,
    required int durationHours,
    required double parkingRate,
    required double serviceFee,
    String vehicleType = 'car',
    String? notes,
    String? parkingName,
    String? parkingLocation,
  }) async {
    // Create parking record with future start time and duration
    final recordId = await _driftService.addParkingRecord(
      ParkingRecordsCompanion.insert(
        plateNumber: plateNumber.toUpperCase(),
        entryTime: startTime,
        parkingSlot: slotNumber,
        vehicleType: Value(vehicleType),
        attendantId: const Value('SYSTEM'),
        paymentStatus: const Value('pending'),
        amountCharged: Value(parkingRate),
        duration: Value(durationHours * 60), // Store duration in minutes
        notes: Value(notes),
        parkingName: Value(parkingName),
        parkingLocation: Value(parkingLocation),
      ),
    );

    // Reserve the parking slot
    final slot = await _driftService.getSlotByNumber(slotNumber);
    if (slot != null) {
      await _driftService.updateSlot(
        ParkingSlotsCompanion(
          id: Value(slot.id),
          isReserved: const Value(true),
          reservedBy: Value(plateNumber.toUpperCase()),
          reservedUntil: Value(startTime.add(Duration(hours: durationHours))),
        ),
      );
    }

    // Log booking activity
    await _driftService.addVehicleLog(
      VehicleLogsCompanion.insert(
        plateNumber: plateNumber.toUpperCase(),
        timestamp: DateTime.now(),
        activityType: 'reservation',
        parkingSlot: Value(slotNumber),
        amount: Value(parkingRate + serviceFee),
        status: const Value('success'),
        description: Value(
          'Booking created for slot $slotNumber starting at $startTime',
        ),
        metadata: Value(
          '{"durationHours": $durationHours, "serviceFee": $serviceFee}',
        ),
      ),
    );

    return (await _driftService.getParkingRecordById(recordId))!;
  }

  /// Get all bookings (active and upcoming)
  Future<List<ParkingRecord>> getAllBookings() async {
    return await _driftService.getAllParkingRecords();
  }

  /// Get active bookings (currently in progress)
  Future<List<ParkingRecord>> getActiveBookings() async {
    final now = DateTime.now();
    final allRecords = await _driftService.getAllParkingRecords();

    return allRecords.where((record) {
      // Active if entry time has passed and no exit time
      return record.entryTime.isBefore(now) && record.exitTime == null;
    }).toList();
  }

  /// Get upcoming bookings (scheduled for future)
  Future<List<ParkingRecord>> getUpcomingBookings() async {
    final now = DateTime.now();
    final allRecords = await _driftService.getAllParkingRecords();

    return allRecords.where((record) {
      // Upcoming if entry time is in future
      return record.entryTime.isAfter(now) && record.exitTime == null;
    }).toList();
  }

  /// Get completed bookings (includes completed, cancelled, and unpaid)
  Future<List<ParkingRecord>> getCompletedBookings() async {
    final allRecords = await _driftService.getAllParkingRecords();
    return allRecords.where((record) => record.exitTime != null).toList();
  }

  /// Get booking by ID
  Future<ParkingRecord?> getBookingById(int id) async {
    return await _driftService.getParkingRecordById(id);
  }

  /// Get bookings by plate number
  Future<List<ParkingRecord>> getBookingsByPlate(String plateNumber) async {
    return await _driftService.searchParkingByPlate(plateNumber.toUpperCase());
  }

  /// Cancel a booking
  Future<void> cancelBooking(int bookingId) async {
    final booking = await _driftService.getParkingRecordById(bookingId);
    if (booking == null) {
      throw Exception('Booking not found');
    }

    // Update booking status to cancelled and set exit time
    await _driftService.updateParkingRecord(
      ParkingRecordsCompanion(
        id: Value(bookingId),
        paymentStatus: const Value('cancelled'),
        exitTime: Value(DateTime.now()),
        notes: Value('${booking.notes ?? ''}\nCancelled at ${DateTime.now()}'),
      ),
    );

    // Release the slot
    final slot = await _driftService.getSlotByNumber(booking.parkingSlot);
    if (slot != null) {
      await _driftService.updateSlot(
        ParkingSlotsCompanion(
          id: Value(slot.id),
          isReserved: const Value(false),
          isOccupied: const Value(false),
          currentPlateNumber: const Value(null),
          occupiedSince: const Value(null),
          reservedBy: const Value(null),
          reservedUntil: const Value(null),
        ),
      );
    }

    // Log cancellation
    await _driftService.addVehicleLog(
      VehicleLogsCompanion.insert(
        plateNumber: booking.plateNumber,
        timestamp: DateTime.now(),
        activityType: 'cancellation',
        parkingSlot: Value(booking.parkingSlot),
        status: const Value('success'),
        description: Value('Booking cancelled for slot ${booking.parkingSlot}'),
      ),
    );
  }

  /// Mark booking as paid
  Future<void> markBookingAsPaid(
    int bookingId,
    String paymentMethod,
    String? phoneNumber,
  ) async {
    final booking = await _driftService.getParkingRecordById(bookingId);
    if (booking == null) {
      throw Exception('Booking not found');
    }

    // Update booking
    await _driftService.updateParkingRecord(
      ParkingRecordsCompanion(
        id: Value(bookingId),
        paymentStatus: const Value('paid'),
        paymentMethod: Value(paymentMethod),
      ),
    );

    // Create transaction record
    await _driftService.addTransaction(
      TransactionsCompanion.insert(
        plateNumber: booking.plateNumber,
        transactionDate: DateTime.now(),
        durationMinutes: 0, // Will be calculated on exit
        feePaid: booking.amountCharged ?? 0.0,
        paymentMethod: paymentMethod,
        paymentStatus: 'completed',
        phoneNumber: Value(phoneNumber),
        attendantId: const Value('SYSTEM'),
        parkingSlot: Value(booking.parkingSlot),
        entryTime: Value(booking.entryTime),
        receiptNumber: Value('RCP${DateTime.now().millisecondsSinceEpoch}'),
      ),
    );

    // Log payment
    await _driftService.addVehicleLog(
      VehicleLogsCompanion.insert(
        plateNumber: booking.plateNumber,
        timestamp: DateTime.now(),
        activityType: 'payment',
        parkingSlot: Value(booking.parkingSlot),
        amount: Value(booking.amountCharged),
        status: const Value('success'),
        description: Value('Payment received via $paymentMethod'),
      ),
    );
  }

  /// Activate a booking (when start time arrives)
  Future<void> activateBooking(int bookingId) async {
    final booking = await _driftService.getParkingRecordById(bookingId);
    if (booking == null) {
      throw Exception('Booking not found');
    }

    // Update slot to occupied
    final slot = await _driftService.getSlotByNumber(booking.parkingSlot);
    if (slot != null) {
      await _driftService.updateSlot(
        ParkingSlotsCompanion(
          id: Value(slot.id),
          isOccupied: const Value(true),
          isReserved: const Value(false),
          currentPlateNumber: Value(booking.plateNumber),
          occupiedSince: Value(DateTime.now()),
          reservedBy: const Value(null),
          reservedUntil: const Value(null),
        ),
      );
    }

    // Log activation
    await _driftService.addVehicleLog(
      VehicleLogsCompanion.insert(
        plateNumber: booking.plateNumber,
        timestamp: DateTime.now(),
        activityType: 'entry',
        parkingSlot: Value(booking.parkingSlot),
        status: const Value('success'),
        description: Value('Booking activated for slot ${booking.parkingSlot}'),
      ),
    );
  }

  /// Complete a booking (vehicle exits)
  Future<Transaction> completeBooking(
    int bookingId,
    String paymentMethod,
    String? phoneNumber,
  ) async {
    final booking = await _driftService.getParkingRecordById(bookingId);
    if (booking == null) {
      throw Exception('Booking not found');
    }

    // Use parking service to handle exit
    return await _parkingService.vehicleExit(
      plateNumber: booking.plateNumber,
      paymentMethod: paymentMethod,
      phoneNumber: phoneNumber,
      attendantId: 'SYSTEM',
    );
  }

  /// Get booking statistics
  Future<Map<String, dynamic>> getBookingStats() async {
    final allBookings = await getAllBookings();
    final activeBookings = await getActiveBookings();
    final upcomingBookings = await getUpcomingBookings();
    final completedBookings = await getCompletedBookings();

    final totalRevenue = completedBookings.fold<double>(
      0.0,
      (sum, booking) => sum + (booking.amountCharged ?? 0.0),
    );

    return {
      'total': allBookings.length,
      'active': activeBookings.length,
      'upcoming': upcomingBookings.length,
      'completed': completedBookings.length,
      'totalRevenue': totalRevenue,
    };
  }

  /// Clean up expired bookings (no-shows)
  Future<void> cleanupExpiredBookings() async {
    final now = DateTime.now();
    final allBookings = await getAllBookings();

    for (final booking in allBookings) {
      // If booking start time was more than 1 hour ago and still pending
      if (booking.entryTime.isBefore(now.subtract(const Duration(hours: 1))) &&
          booking.exitTime == null &&
          booking.paymentStatus == 'pending') {
        await cancelBooking(booking.id);
      }
    }
  }

  /// Update booking statuses based on time and payment
  /// This should be called periodically to manage session lifecycle
  Future<void> updateBookingStatuses() async {
    final now = DateTime.now();
    final allBookings = await getAllBookings();

    print('🔄 Updating booking statuses at $now');
    print('   Total bookings to check: ${allBookings.length}');

    for (final booking in allBookings) {
      // Skip already completed bookings
      if (booking.exitTime != null) {
        print('   ⏭️  Skipping booking ${booking.id} - already has exitTime');
        continue;
      }

      final entryTime = booking.entryTime;
      final duration = booking.duration ?? 120; // Default 2 hours in minutes
      final sessionEndTime = entryTime.add(Duration(minutes: duration));
      final paymentStatus = booking.paymentStatus ?? 'pending';

      print('   📋 Booking ${booking.id}:');
      print('      Entry: $entryTime');
      print('      Duration: $duration minutes');
      print('      End Time: $sessionEndTime');
      print('      Payment: $paymentStatus');
      print(
        '      Time until end: ${sessionEndTime.difference(now).inMinutes} minutes',
      );

      // Case 1: Upcoming -> Active (when session time arrives)
      if (entryTime.isBefore(now) &&
          entryTime.isAfter(now.subtract(const Duration(minutes: 5)))) {
        // Session just started, activate it if paid
        if (paymentStatus == 'paid') {
          print('      ✅ Activating booking ${booking.id}');
          await activateBooking(booking.id);
        }
      }

      // Case 2: Active (PAID) -> History with "completed" status (ONLY when time is done)
      if (sessionEndTime.isBefore(now) &&
          (paymentStatus == 'paid' || paymentStatus == 'completed')) {
        print('      ✅ Completing booking ${booking.id} - time ended and paid');
        // Mark as completed - session time has ended
        await _driftService.updateParkingRecord(
          ParkingRecordsCompanion(
            id: Value(booking.id),
            exitTime: Value(sessionEndTime),
            duration: Value(duration),
            paymentStatus: const Value('completed'),
          ),
        );

        // Release the slot
        final slot = await _driftService.getSlotByNumber(booking.parkingSlot);
        if (slot != null) {
          await _driftService.updateSlot(
            ParkingSlotsCompanion(
              id: Value(slot.id),
              isOccupied: const Value(false),
              isReserved: const Value(false),
              currentPlateNumber: const Value(null),
              occupiedSince: const Value(null),
              reservedBy: const Value(null),
              reservedUntil: const Value(null),
            ),
          );
        }

        // Log completion
        await _driftService.addVehicleLog(
          VehicleLogsCompanion.insert(
            plateNumber: booking.plateNumber,
            timestamp: now,
            activityType: 'exit',
            parkingSlot: Value(booking.parkingSlot),
            status: const Value('success'),
            description: Value(
              'Session completed for slot ${booking.parkingSlot}',
            ),
          ),
        );
      } else if (sessionEndTime.isAfter(now) &&
          (paymentStatus == 'paid' || paymentStatus == 'completed')) {
        print(
          '      ⏳ Booking ${booking.id} is PAID but time not ended yet - staying in Active',
        );
      }

      // Case 3: Active (UNPAID) -> History with "unpaid" status (30 minutes after session end)
      if (sessionEndTime.add(const Duration(minutes: 30)).isBefore(now) &&
          paymentStatus == 'pending') {
        print(
          '      ⚠️  Marking booking ${booking.id} as unpaid - 30 min grace period expired',
        );
        // Mark as unpaid and end session
        await _driftService.updateParkingRecord(
          ParkingRecordsCompanion(
            id: Value(booking.id),
            exitTime: Value(sessionEndTime.add(const Duration(minutes: 30))),
            duration: Value(duration + 30),
            paymentStatus: const Value('unpaid'),
          ),
        );

        // Release the slot
        final slot = await _driftService.getSlotByNumber(booking.parkingSlot);
        if (slot != null) {
          await _driftService.updateSlot(
            ParkingSlotsCompanion(
              id: Value(slot.id),
              isOccupied: const Value(false),
              isReserved: const Value(false),
              currentPlateNumber: const Value(null),
              occupiedSince: const Value(null),
              reservedBy: const Value(null),
              reservedUntil: const Value(null),
            ),
          );
        }

        // Log unpaid session
        await _driftService.addVehicleLog(
          VehicleLogsCompanion.insert(
            plateNumber: booking.plateNumber,
            timestamp: now,
            activityType: 'exit',
            parkingSlot: Value(booking.parkingSlot),
            status: const Value('unpaid'),
            description: Value(
              'Session ended unpaid for slot ${booking.parkingSlot}',
            ),
          ),
        );
      }
    }
    print('✅ Booking status update complete\n');
  }
}
