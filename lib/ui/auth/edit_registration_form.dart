import 'package:flutter/material.dart';
import 'package:odigo_vendor/ui/auth/mobile/edit_registration_form_mobile.dart';
import 'package:odigo_vendor/ui/auth/web/edit_registration_form_web.dart';
import 'package:responsive_builder/responsive_builder.dart';

class EditRegistrationForm extends StatelessWidget {
  const EditRegistrationForm({Key? key}) : super(key: key);

  ///Build Override
  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
      breakpoints: const ScreenBreakpoints(desktop: 600, tablet: 600, watch: 0),

      mobile: (BuildContext context) {
          return const EditRegistrationFormMobile();
        },
        desktop: (BuildContext context) {
          return const EditRegistrationFormWeb();
        },
      // tablet: (BuildContext context) {
      //   return OrientationBuilder(
      //     builder: (BuildContext context, Orientation orientation) {
      //       return orientation == Orientation.landscape ? const EditRegistrationFormWeb() : const EditRegistrationFormMobile();
      //     },
      //   );
      // },
    );
  }
}

