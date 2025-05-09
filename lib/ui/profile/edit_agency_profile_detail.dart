import 'package:flutter/material.dart';
import 'package:odigo_vendor/ui/profile/mobile/edit_agency_profile_detail_mobile.dart';
import 'package:odigo_vendor/ui/profile/web/edit_agency_profile_detail_web.dart';
import 'package:responsive_builder/responsive_builder.dart';

class EditAgencyProfileDetail extends StatelessWidget {
  const EditAgencyProfileDetail({Key? key}) : super(key: key);

  ///Build Override
  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
        breakpoints: const ScreenBreakpoints(desktop: 600, tablet: 600, watch: 0),
        mobile: (BuildContext context) {
          return const EditAgencyProfileDetailMobile();
        },
        desktop: (BuildContext context) {
          return const EditAgencyProfileDetailWeb();
        },
    );
  }
}

