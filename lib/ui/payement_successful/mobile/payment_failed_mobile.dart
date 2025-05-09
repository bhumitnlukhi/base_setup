import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PaymentFailedMobile extends ConsumerStatefulWidget {
  const PaymentFailedMobile({Key? key}) : super(key: key);

  @override
  ConsumerState<PaymentFailedMobile> createState() => _PaymentFailedMobileState();
}

class _PaymentFailedMobileState extends ConsumerState<PaymentFailedMobile> {

  ///Init Override
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      // final paymentFailedWatch = ref.watch(paymentFailedController);
      //paymentFailedWatch.disposeController(isNotify : true);
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
