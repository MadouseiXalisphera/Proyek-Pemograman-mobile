import 'package:get/get.dart';

import 'splash_controller.dart';

// CATATAN PENTING:
// Pakai Get.put (EAGER), BUKAN lazyPut. Ini sengaja, sesuai pelajaran dari bug
// "splash hang" sebelumnya: dengan lazyPut, controller baru dibuat saat view
// memanggilnya, sehingga onReady() (yang menjalankan init + navigasi) bisa
// telat/terlewat dan splash nyangkut. Get.put memastikan controller hidup &
// onReady() pasti jalan begitu halaman dibuka.
class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<SplashController>(SplashController());
  }
}
