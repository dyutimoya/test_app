import 'package:get/get.dart';
import '../../core/services/ad_service.dart';

class HomeController extends GetxController {
  void showInterstitialAd() {
    AdService.showInterstitialAd();
  }
}