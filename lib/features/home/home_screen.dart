import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/services/ad_service.dart';
import 'home_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Welcome to Home Screen',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: controller.showInterstitialAd,
                child: const Text('Show Interstitial Ad'),
              ),
              AdService.bannerWidget(AdService.banner),
              AdService.bannerWidget(AdService.largeBanner),
              AdService.bannerWidget(AdService.mediumRectangle),
            ],
          ),
        ),
      ),
    );
  }
}