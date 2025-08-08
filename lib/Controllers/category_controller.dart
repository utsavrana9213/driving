import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';



class CategoryController extends GetxController {
  final currentIndex = 0.obs;

  final labels = ['B, B1', 'C', 'D', 'T, S'];

  void setIndex(int idx) => currentIndex.value = idx;

  String get currentLabel => labels[currentIndex.value];
}
