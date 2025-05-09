import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditRegistrationFormMobile extends ConsumerStatefulWidget {
  const EditRegistrationFormMobile({Key? key}) : super(key: key);

  @override
  ConsumerState<EditRegistrationFormMobile> createState() => _EditRegistrationFormMobileState();
}

class _EditRegistrationFormMobileState extends ConsumerState<EditRegistrationFormMobile> {

  ///Init Override
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      // final editRegistrationFormWatch = ref.watch(editRegistrationFormController);
      //editRegistrationFormWatch.disposeController(isNotify : true);
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
