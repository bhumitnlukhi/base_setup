import 'package:flutter/material.dart';
import 'package:odigo_vendor/ui/ads/mobile/ads_details_mobile.dart';
import 'package:odigo_vendor/ui/ads/web/ads_details_web.dart';
import 'package:odigo_vendor/ui/utils/helper/base_widget.dart';
import 'package:responsive_builder/responsive_builder.dart';

class AdsDetails extends StatelessWidget with BaseStatelessWidget {
  final String adUuid;
  const AdsDetails({Key? key, required this.adUuid}) : super(key: key);

  ///Build Override
  @override
  Widget buildPage(BuildContext context) {
    return ScreenTypeLayout.builder(
      breakpoints: const ScreenBreakpoints(desktop: 600, tablet: 600, watch: 0),

      mobile: (BuildContext context) {
        return const AdsDetailsMobile();
      },
      desktop: (BuildContext context) {
        return AdsDetailsWeb(adUuid: adUuid);
      },
    );
  }
}

