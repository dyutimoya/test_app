import 'package:get/get.dart';
import '../../core/services/database_service.dart';

class HistoryController extends GetxController {
  final DatabaseService _db = Get.find<DatabaseService>();
  final calculations = <CalculationHistory>[].obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadHistory();
  }

  Future<void> loadHistory() async {
    isLoading.value = true;
    try {
      final result = await _db.getCalculations();
      calculations.assignAll(result);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteItem(int id) async {
    await _db.deleteCalculation(id);
    loadHistory();
  }

  Future<void> clearAll() async {
    await _db.clearAllHistory();
    calculations.clear();
  }
}