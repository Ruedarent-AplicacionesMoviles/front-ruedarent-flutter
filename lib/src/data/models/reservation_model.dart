// src/data/models/reservation_model.dart

class ReservationModel {
  final int? id;
  final int renterId;
  final int vehicleId;
  final DateTime startDate;
  final DateTime endDate;
  final String pickupLocation;
  final String dropoffLocation;
  final String reservationStatus; // 'confirmed', 'canceled'
  final double totalPrice;
  final String paymentMethod;

  ReservationModel({
    this.id,
    required this.renterId,
    required this.vehicleId,
    required this.startDate,
    required this.endDate,
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.reservationStatus,
    required this.totalPrice,
    required this.paymentMethod,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'renterId': renterId,
      'vehicleId': vehicleId,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'pickupLocation': pickupLocation,
      'dropoffLocation': dropoffLocation,
      'reservationStatus': reservationStatus,
      'totalPrice': totalPrice,
      'paymentMethod': paymentMethod,
    };
  }

  factory ReservationModel.fromMap(Map<String, dynamic> map) {
    return ReservationModel(
      id: map['id'],
      renterId: map['renterId'],
      vehicleId: map['vehicleId'],
      startDate: DateTime.parse(map['startDate']),
      endDate: DateTime.parse(map['endDate']),
      pickupLocation: map['pickupLocation'],
      dropoffLocation: map['dropoffLocation'],
      reservationStatus: map['reservationStatus'],
      totalPrice: map['totalPrice'],
      paymentMethod: map['paymentMethod'],
    );
  }
}
