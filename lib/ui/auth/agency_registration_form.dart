import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigo_vendor/framework/controller/auth/agency_registration_form_controller.dart';
import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/ui/auth/mobile/agency_registration_form_mobile.dart';
import 'package:odigo_vendor/ui/auth/web/agency_registration_form_web.dart';
import 'package:odigo_vendor/ui/utils/helper/base_widget.dart';
import 'package:responsive_builder/responsive_builder.dart';

class AgencyRegistrationForm extends ConsumerStatefulWidget  {
  final bool? isEdit;
  const AgencyRegistrationForm({Key? key,this.isEdit}) : super(key: key);

  @override
  ConsumerState<AgencyRegistrationForm> createState() => _AgencyRegistrationFormState();
}

class _AgencyRegistrationFormState extends ConsumerState<AgencyRegistrationForm> with BaseConsumerStatefulWidget{
  ///Build Override
  @override
  Widget buildPage(BuildContext context) {
    return ScreenTypeLayout.builder(
      breakpoints: const ScreenBreakpoints(desktop: 600, tablet: 600, watch: 0),

      mobile: (BuildContext context) {
          return const AgencyRegistrationFormMobile();
        },
        desktop: (BuildContext context) {
          return const AgencyRegistrationFormWeb();
        },
    );
  }

  @override
  void didChangeDependencies() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      if (mounted) {
        if (context.isWebScreen) {
        } else {
          EasyDebounce.debounce('agencyRegistrationDebounce', const Duration(milliseconds: 50), () {
            final agencyRegistrationFormWatch = ref.watch(agencyRegistrationFormController);
            if(agencyRegistrationFormWatch.waitingDialog.currentContext != null) {Navigator.pop(agencyRegistrationFormWatch.waitingDialog.currentContext!);}

          });
        }
      }
    });
    super.didChangeDependencies();
  }
}

