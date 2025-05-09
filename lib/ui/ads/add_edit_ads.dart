import 'package:flutter/material.dart';
import 'package:odigo_vendor/ui/ads/mobile/add_edit_ads_mobile.dart';
import 'package:odigo_vendor/ui/ads/web/add_edit_ads_web.dart';
import 'package:odigo_vendor/ui/utils/helper/base_widget.dart';
import 'package:responsive_builder/responsive_builder.dart';

class AddEditAds extends StatelessWidget with BaseStatelessWidget {
  const AddEditAds({Key? key}) : super(key: key);

  ///Build Override
  @override
  Widget buildPage(BuildContext context) {
    return ScreenTypeLayout.builder(
      breakpoints: const ScreenBreakpoints(desktop: 600, tablet: 600, watch: 0),
      mobile: (BuildContext context) {
        return const AddEditAdsMobile();
      },
      desktop: (BuildContext context) {
        return const AddEditAdsWeb();
      },
      // tablet: (BuildContext context) {
      //   return OrientationBuilder(
      //     builder: (BuildContext context, Orientation orientation) {
      //       return orientation == Orientation.landscape
      //           ? const AddEditAdsWeb()
      //           : const AddEditAdsMobile();
      //     },
      //   );
      // },
    );
  }
}

