import 'package:flutter/material.dart';
import 'package:odigo_vendor/ui/dashboard/mobile/dashboard_mobile.dart';
import 'package:odigo_vendor/ui/dashboard/web/dashboard_web.dart';
import 'package:responsive_builder/responsive_builder.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({Key? key}) : super(key: key);

  ///Build Override
  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
        breakpoints: const ScreenBreakpoints(desktop: 600, tablet: 600, watch: 0),
        mobile: (BuildContext context) {
          return const DashboardMobile();
        },
        desktop: (BuildContext context) {
          return const DashboardWeb();
        }
    );
  }
}

