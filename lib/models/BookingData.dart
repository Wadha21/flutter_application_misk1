class BookingData {
  final String vehicle;
  final String pickupTime;
  final String fromLocation;
  final String toLocation;
  final int? passengerCount;

  BookingData({
    required this.vehicle,
    required this.pickupTime,
    required this.fromLocation,
    required this.toLocation,
    this.passengerCount,
  });

  BookingData copyWith({
    String? vehicle,
    String? pickupTime,
    String? fromLocation,
    String? toLocation,
    int? passengerCount,
  }) {
    return BookingData(
      vehicle: vehicle ?? this.vehicle,
      pickupTime: pickupTime ?? this.pickupTime,
      fromLocation: fromLocation ?? this.fromLocation,
      toLocation: toLocation ?? this.toLocation,
      passengerCount: passengerCount ?? this.passengerCount,
    );
  }
}
