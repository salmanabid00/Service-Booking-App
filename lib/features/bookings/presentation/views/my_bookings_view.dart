import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/booking_controller.dart';
import '../../domain/entities/booking_model.dart';

class MyBookingsView extends StatelessWidget {
  final BookingController _bookingController = Get.find<BookingController>();

  MyBookingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('My Bookings', style: TextStyle(fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (_bookingController.userBookings.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.calendar_today_outlined, size: 64, color: Colors.grey[300]),
                const SizedBox(height: 16),
                Text('You haven\'t booked anything yet', style: TextStyle(color: Colors.grey[500])),
              ],
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _bookingController.userBookings.length,
          itemBuilder: (context, index) {
            final booking = _bookingController.userBookings[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                title: Text(
                  booking.serviceName,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(
                          '${booking.dateTime.day}/${booking.dateTime.month}/${booking.dateTime.year}',
                          style: TextStyle(color: Colors.grey[600], fontSize: 13),
                        ),
                      ],
                    ),
                  ],
                ),
                trailing: _buildStatusBadge(booking.status),
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildStatusBadge(BookingStatus status) {
    Color color;
    switch (status) {
      case BookingStatus.pending: color = Colors.orange; break;
      case BookingStatus.approved: color = Colors.blue; break;
      case BookingStatus.completed: color = Colors.green; break;
      case BookingStatus.rejected: color = Colors.red; break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.name.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
