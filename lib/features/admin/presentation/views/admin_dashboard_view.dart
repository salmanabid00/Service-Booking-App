import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../bookings/presentation/controllers/booking_controller.dart';
import '../../../bookings/domain/entities/booking_model.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../../features/services/presentation/controllers/service_controller.dart';
import '../../../../features/services/domain/entities/service_model.dart';

class AdminDashboardView extends StatelessWidget {
  final BookingController _bookingController = Get.put(BookingController());
  final AuthController _authController = Get.find<AuthController>();
  final ServiceController _serviceController = Get.put(ServiceController());

  AdminDashboardView({super.key}) {
    _bookingController.loadAllBookings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Admin Console', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: Colors.red.withOpacity(0.1), shape: BoxShape.circle),
              child: const Icon(Icons.logout_rounded, color: Colors.redAccent, size: 20),
            ),
            onPressed: () => _authController.logout(),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatsHeader(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              'Recent Bookings',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (_bookingController.allBookings.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.inbox_rounded, size: 64, color: Colors.grey[300]),
                      const SizedBox(height: 16),
                      Text('No bookings found', style: TextStyle(color: Colors.grey[500])),
                    ],
                  ),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _bookingController.allBookings.length,
                itemBuilder: (context, index) {
                  final booking = _bookingController.allBookings[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey[100]!),
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
                          Text('Client ID: ${booking.userId.substring(0, 8)}...', style: TextStyle(color: Colors.grey[600])),
                          const SizedBox(height: 8),
                          _buildStatusChip(booking.status),
                        ],
                      ),
                      trailing: PopupMenuButton<BookingStatus>(
                        icon: const Icon(Icons.more_vert_rounded),
                        onSelected: (status) => _bookingController.updateStatus(booking.id, status),
                        itemBuilder: (context) => BookingStatus.values
                            .map((status) => PopupMenuItem<BookingStatus>(
                                  value: status,
                                  child: Text(status.name.toUpperCase()),
                                ))
                            .toList(),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _addSampleService(),
        label: const Text('Add Test Service', style: TextStyle(fontWeight: FontWeight.bold)),
        icon: const Icon(Icons.add_circle_outline_rounded),
      ),
    );
  }

  Widget _buildStatsHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          _buildStatCard('Total', _bookingController.allBookings.length.toString(), Colors.blue),
          const SizedBox(width: 12),
          _buildStatCard('Pending', _bookingController.allBookings.where((e) => e.status == BookingStatus.pending).length.toString(), Colors.orange),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(BookingStatus status) {
    Color color;
    switch (status) {
      case BookingStatus.pending: color = Colors.orange; break;
      case BookingStatus.approved: color = Colors.blue; break;
      case BookingStatus.completed: color = Colors.green; break;
      case BookingStatus.rejected: color = Colors.red; break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
      child: Text(
        status.name.toUpperCase(),
        style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold),
      ),
    );
  }

  void _addSampleService() {
    final newService = ServiceModel(
      id: '',
      name: 'Sample Service ${DateTime.now().second}',
      description: 'Automatically added sample service for testing.',
      price: 25.0,
      durationInMinutes: 60,
    );
    _serviceController.addService(newService);
    Get.snackbar('Success', 'Sample service added!', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green, colorText: Colors.white);
  }
}
