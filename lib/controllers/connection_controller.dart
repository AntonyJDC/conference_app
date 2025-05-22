import 'dart:async';
import 'dart:io';
import 'package:get/get.dart';

class ConnectionController extends GetxController {
  final hasConnection = true.obs;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    _checkConnection(); // Revisión inicial
    _timer = Timer.periodic(const Duration(seconds: 5), (_) => _checkConnection());
  }

  Future<void> _checkConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      hasConnection.value =
          result.isNotEmpty && result.first.rawAddress.isNotEmpty;
    } catch (_) {
      hasConnection.value = false;
    }
  }

  @override
  void onClose() {
    _timer?.cancel(); // Cancelar el Timer al destruir el controller
    super.onClose();
  }
}
