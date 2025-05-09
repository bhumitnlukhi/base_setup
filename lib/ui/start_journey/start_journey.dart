import 'package:flutter/material.dart';
import 'package:odigo_vendor/ui/start_journey/mobile/start_journey_mobile.dart';
import 'package:odigo_vendor/ui/start_journey/web/start_journey_web.dart';
import 'package:odigo_vendor/ui/utils/helper/base_widget.dart';
import 'package:responsive_builder/responsive_builder.dart';


class StartJourney extends StatelessWidget with BaseStatelessWidget {
  const StartJourney({Key? key}) : super(key: key);

  ///Build Override
  @override
  Widget buildPage(BuildContext context) {
    return ScreenTypeLayout.builder(
      breakpoints: const ScreenBreakpoints(desktop: 600, tablet: 600, watch: 0),

      mobile: (BuildContext context) {
        return const StartJourneyMobile();
      },
      desktop: (BuildContext context) {
        return const StartJourneyWeb();
      },
    );
  }
}

