import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/service_model.dart';

class ServiceController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final RxList<ServiceModel> services = <ServiceModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    services.bindStream(getServices());
  }

  Stream<List<ServiceModel>> getServices() {
    return _db.collection(AppConstants.servicesCollection).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => ServiceModel.fromMap(doc.data(), doc.id)).toList();
    });
  }

  Future<void> addService(ServiceModel service) async {
    await _db.collection(AppConstants.servicesCollection).add(service.toMap());
  }
}
