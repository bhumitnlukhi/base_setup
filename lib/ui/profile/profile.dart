import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigo_vendor/framework/controller/profile/profile_controller.dart';
import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/ui/profile/mobile/profile_mobile.dart';
import 'package:odigo_vendor/ui/profile/web/profile_web.dart';
import 'package:odigo_vendor/ui/utils/helper/base_widget.dart';
import 'package:responsive_builder/responsive_builder.dart';

class Profile extends ConsumerStatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  ConsumerState<Profile> createState() => _ProfileState();
}

class _ProfileState extends ConsumerState<Profile> with BaseStatefulWidget{
  ///Build Override
  @override
  Widget buildPage(BuildContext context) {
    return ScreenTypeLayout.builder(
      breakpoints: const ScreenBreakpoints(desktop: 600, tablet: 600, watch: 0),
        mobile: (BuildContext context) {
          return const ProfileMobile();
        },
        desktop: (BuildContext context) {
          return const ProfileWeb();
        },
    );
  }

  @override
  void didChangeDependencies() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      if (mounted) {
        if (context.isWebScreen) {
          // EasyDebounce.debounce(showStoreDetailsDialogDebounce, const Duration(milliseconds: 100), () {

          //   if (widget.storeUuid != null) {
          //     storeWatch.showStoreDetailsDialog(context, ref, storeUuid: widget.storeUuid!);
          //   }
          // });
        } else {
          EasyDebounce.debounce('profileDebounce', const Duration(milliseconds: 50), () {
            final profileWatch = ref.read(profileController);
            if(profileWatch.sendOtpDialogKey.currentContext != null) {Navigator.pop(profileWatch.sendOtpDialogKey.currentContext!);}
            if(profileWatch.changeEmailDialogKey.currentContext != null) {Navigator.pop(profileWatch.changeEmailDialogKey.currentContext!);}
            if(profileWatch.successDialogKey.currentContext != null) {Navigator.pop(profileWatch.successDialogKey.currentContext!);}


          });
        }
      }
    });
    super.didChangeDependencies();
  }
}

