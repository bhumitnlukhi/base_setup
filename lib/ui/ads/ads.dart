import 'package:flutter/material.dart';
import 'package:odigo_vendor/ui/ads/mobile/ads_mobile.dart';
import 'package:odigo_vendor/ui/ads/web/ads_web.dart';
import 'package:odigo_vendor/ui/utils/helper/base_widget.dart';
import 'package:responsive_builder/responsive_builder.dart';

class Ads extends StatelessWidget with BaseStatelessWidget {
  final int? tabIndex;
  const Ads({Key? key,this.tabIndex}) : super(key: key);

  ///Build Override
  @override
  Widget buildPage(BuildContext context) {
    return ScreenTypeLayout.builder(
      breakpoints: const ScreenBreakpoints(desktop: 600, tablet: 600, watch: 0),
      mobile: (BuildContext context) {
        return const AdsMobile();
      },
      desktop: (BuildContext context) {
        return  AdsWeb(tabIndex:tabIndex);
      },
    );
  }
}

