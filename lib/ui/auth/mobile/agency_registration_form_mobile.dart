import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AgencyRegistrationFormMobile extends ConsumerStatefulWidget {
  const AgencyRegistrationFormMobile({Key? key}) : super(key: key);

  @override
  ConsumerState<AgencyRegistrationFormMobile> createState() => _AgencyRegistrationFormMobileState();
}

class _AgencyRegistrationFormMobileState extends ConsumerState<AgencyRegistrationFormMobile> {

  ///Init Override
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      // final agencyRegistrationFormWatch = ref.watch(agencyRegistrationFormController);
      //agencyRegistrationFormWatch.disposeController(isNotify : true);
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
