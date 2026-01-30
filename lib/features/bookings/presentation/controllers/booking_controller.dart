import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../../domain/entities/booking_model.dart';
import '../../data/repositories/booking_repository.dart';

class BookingController extends GetxController {
  final BookingRepository _repository = BookingRepository();
  final RxList<BookingModel> userBookings = <BookingModel>[].obs;
  final RxList<BookingModel> allBookings = <BookingModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      userBookings.bindStream(_repository.getUserBookings(uid));
    }
  }

  void loadAllBookings() {
    allBookings.bindStream(_repository.getAllBookings());
  }

  Future<void> createBooking(String serviceId, String serviceName, DateTime date) async {
    try {
      isLoading.value = true;
      String uid = FirebaseAuth.instance.currentUser!.uid;
      
      final booking = BookingModel(
        id: '',
        userId: uid,
        serviceId: serviceId,
        serviceName: serviceName,
        dateTime: date,
        status: BookingStatus.pending,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _repository.createBooking(booking);
      Get.back();
      Get.snackbar('Success', 'Booking request sent!');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateStatus(String bookingId, BookingStatus status) async {
    try {
      await _repository.updateBookingStatus(bookingId, status);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }
}
