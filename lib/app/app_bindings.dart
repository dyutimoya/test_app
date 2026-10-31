import 'package:get/get.dart';
import '../core/services/database_service.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DatabaseService(), fenix: true);
  }
}