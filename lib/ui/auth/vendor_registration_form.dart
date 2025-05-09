import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigo_vendor/framework/controller/auth/vendor_registration_form_controller.dart';
import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/ui/auth/mobile/vendor_registration_form_mobile.dart';
import 'package:odigo_vendor/ui/auth/web/vendor_registration_form_web.dart';
import 'package:odigo_vendor/ui/utils/helper/base_widget.dart';
import 'package:responsive_builder/responsive_builder.dart';

class VendorRegistrationForm extends ConsumerStatefulWidget {
  const VendorRegistrationForm({Key? key}) : super(key: key);

  @override
  ConsumerState<VendorRegistrationForm> createState() => _VendorRegistrationFormState();
}

class _VendorRegistrationFormState extends ConsumerState<VendorRegistrationForm> with BaseConsumerStatefulWidget{
  ///Build Override
  @override
  Widget buildPage(BuildContext context) {
    return ScreenTypeLayout.builder(
      breakpoints: const ScreenBreakpoints(desktop: 600, tablet: 600, watch: 0),

      mobile: (BuildContext context) {
          return const VendorRegistrationFormMobile();
        },
        desktop: (BuildContext context) {
          return const VendorRegistrationFormWeb();
        },
        // tablet: (BuildContext context) {
        //   return OrientationBuilder(
        //     builder: (BuildContext context, Orientation orientation) {
        //       return orientation == Orientation.landscape ? const VendorRegistrationFormWeb() : const VendorRegistrationFormMobile();
        //     },
        //   );
        // },
    );
  }

  @override
  void didChangeDependencies() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      if (mounted) {
        if (context.isWebScreen) {
        } else {
          EasyDebounce.debounce('vendorRegistrationDebounce', const Duration(milliseconds: 50), () {
            final vendorRegistrationFormWatch = ref.watch(vendorRegistrationFormController);
            if(vendorRegistrationFormWatch.waitingDialog.currentContext != null) {Navigator.pop(vendorRegistrationFormWatch.waitingDialog.currentContext!);}

          });
        }
      }
    });
    super.didChangeDependencies();
  }
}

