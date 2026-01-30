import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/booking_model.dart';
import '../../../../core/constants/app_constants.dart';

class BookingRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> createBooking(BookingModel booking) async {
    await _db.collection(AppConstants.bookingsCollection).add(booking.toMap());
  }

  Stream<List<BookingModel>> getUserBookings(String userId) {
    return _db
        .collection(AppConstants.bookingsCollection)
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => BookingModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  Stream<List<BookingModel>> getAllBookings() {
    return _db
        .collection(AppConstants.bookingsCollection)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => BookingModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  Future<void> updateBookingStatus(String bookingId, BookingStatus status) async {
    await _db.collection(AppConstants.bookingsCollection).doc(bookingId).update({
      'status': status.toString().split('.').last,
      'updatedAt': Timestamp.now(),
    });
  }
}
