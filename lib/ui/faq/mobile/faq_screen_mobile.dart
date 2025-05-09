import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FaqScreenMobile extends ConsumerStatefulWidget {
  const FaqScreenMobile({Key? key}) : super(key: key);

  @override
  ConsumerState<FaqScreenMobile> createState() => _FaqScreenMobileState();
}

class _FaqScreenMobileState extends ConsumerState<FaqScreenMobile> {

  ///Init Override
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      // final faqScreenWatch = ref.read(faqScreenController);
      //faqScreenWatch.disposeController(isNotify : true);
    });
  }

  ///Dispose Override
  @override
  void dispose() {
    super.dispose();
  }

  ///Build Override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _bodyWidget(),
    );
  }

  ///Body Widget
  Widget _bodyWidget() {
    return Container();
  }


}
