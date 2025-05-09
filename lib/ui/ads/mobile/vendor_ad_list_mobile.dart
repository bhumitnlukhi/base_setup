import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VendorAdListMobile extends ConsumerStatefulWidget {
  const VendorAdListMobile({Key? key}) : super(key: key);

  @override
  ConsumerState<VendorAdListMobile> createState() => _VendorAdListMobileState();
}

class _VendorAdListMobileState extends ConsumerState<VendorAdListMobile> {

  ///Init Override
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      // final vendorAdListWatch = ref.watch(vendorAdListController);
      //vendorAdListWatch.disposeController(isNotify : true);
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
