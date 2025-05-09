import 'package:flutter/material.dart';
import 'package:odigo_vendor/ui/notification/mobile/notification_screen_mobile.dart';
import 'package:odigo_vendor/ui/notification/web/notification_screen_web.dart';
import 'package:odigo_vendor/ui/utils/helper/base_widget.dart';
import 'package:responsive_builder/responsive_builder.dart';


class NotificationScreen extends StatelessWidget with BaseStatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  ///Build Override
  @override
  Widget buildPage(BuildContext context) {
    return ScreenTypeLayout.builder(
        breakpoints: const ScreenBreakpoints(desktop: 600, tablet: 600, watch: 0),
        mobile: (BuildContext context) {
          return const NotificationScreenMobile();
        },
        desktop: (BuildContext context) {
          return const NotificationScreenWeb();
        }
    );
  }
}

