import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BillingMobile extends ConsumerStatefulWidget {
  const BillingMobile({Key? key}) : super(key: key);

  @override
  ConsumerState<BillingMobile> createState() => _BillingMobileState();
}

class _BillingMobileState extends ConsumerState<BillingMobile> {

  ///Init Override
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      // final billingWatch = ref.watch(billingController);
      //billingWatch.disposeController(isNotify : true);
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
