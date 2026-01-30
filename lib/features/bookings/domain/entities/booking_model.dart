import 'package:cloud_firestore/cloud_firestore.dart';

enum BookingStatus { pending, approved, rejected, completed }

class BookingModel {
  final String id;
  final String userId;
  final String serviceId;
  final String serviceName;
  final DateTime dateTime;
  final BookingStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  BookingModel({
    required this.id,
    required this.userId,
    required this.serviceId,
    required this.serviceName,
    required this.dateTime,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BookingModel.fromMap(Map<String, dynamic> map, String id) {
    return BookingModel(
      id: id,
      userId: map['userId'] ?? '',
      serviceId: map['serviceId'] ?? '',
      serviceName: map['serviceName'] ?? '',
      dateTime: (map['dateTime'] as Timestamp).toDate(),
      status: BookingStatus.values.firstWhere(
        (e) => e.toString().split('.').last == map['status'],
        orElse: () => BookingStatus.pending,
      ),
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'serviceId': serviceId,
      'serviceName': serviceName,
      'dateTime': Timestamp.fromDate(dateTime),
      'status': status.toString().split('.').last,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
}
