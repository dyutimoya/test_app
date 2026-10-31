import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewArguments {
  final String url;
  final String title;
  WebViewArguments({required this.url, required this.title});
}

class WebViewControllerX extends GetxController {
  late final WebViewController webController;
  final isLoading = true.obs;
  late final String url;
  late final String title;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>;
    url = args['url'] as String;
    title = args['title'] as String;
    _initWebView();
  }

  void _initWebView() {
    webController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {},
          onPageStarted: (String url) => isLoading.value = true,
          onPageFinished: (String url) => isLoading.value = false,
          onWebResourceError: (WebResourceError error) {},
        ),
      )
      ..loadRequest(Uri.parse(url));
  }
}