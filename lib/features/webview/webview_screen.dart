import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'webview_controller.dart';

class WebViewScreen extends StatelessWidget {
  const WebViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(WebViewControllerX());

    return Scaffold(
      appBar: AppBar(
        title: Text(controller.title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Get.back(),
        ),
        elevation: 0,
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: controller.webController),
          Obx(() =>
          controller.isLoading.value ?
            const Center(child: CircularProgressIndicator()) :
            const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}