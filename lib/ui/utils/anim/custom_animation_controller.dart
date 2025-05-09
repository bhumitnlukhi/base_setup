import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:odigo_vendor/framework/dependency_injection/inject.dart';

final customAnimationController = ChangeNotifierProvider(
  (ref) => getIt<CustomAnimationController>(),
);

@injectable
class CustomAnimationController extends ChangeNotifier {
  @override
  void notifyListeners() {
    super.notifyListeners();
  }

  void notify() {
    notifyListeners();
  }

  void valueList(List<AnimationController> value){
    value.forEach((element) {
      element.value==0;
    });
  }
}
