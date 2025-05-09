import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PaymentCancelMobile extends ConsumerStatefulWidget {
  const PaymentCancelMobile({Key? key}) : super(key: key);

  @override
  ConsumerState<PaymentCancelMobile> createState() => _PaymentCancelMobileState();
}

class _PaymentCancelMobileState extends ConsumerState<PaymentCancelMobile> {

  ///Init Override
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      // final paymentCancelWatch = ref.watch(paymentCancelController);
      //paymentCancelWatch.disposeController(isNotify : true);
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
