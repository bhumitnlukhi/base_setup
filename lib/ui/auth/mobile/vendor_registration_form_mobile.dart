import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VendorRegistrationFormMobile extends ConsumerStatefulWidget {
  const VendorRegistrationFormMobile({Key? key}) : super(key: key);

  @override
  ConsumerState<VendorRegistrationFormMobile> createState() => _VendorRegistrationFormMobileState();
}

class _VendorRegistrationFormMobileState extends ConsumerState<VendorRegistrationFormMobile> {

  ///Init Override
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      // final vendorRegistrationFormWatch = ref.watch(vendorRegistrationFormController);
      //vendorRegistrationFormWatch.disposeController(isNotify : true);
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
