import 'package:flutter/material.dart';
import 'package:odigo_vendor/ui/faq/mobile/faq_screen_mobile.dart';
import 'package:odigo_vendor/ui/faq/web/faq_screen_web.dart';
import 'package:responsive_builder/responsive_builder.dart';

class FaqScreen extends StatelessWidget {
  final int? tabIndex;

  const FaqScreen({Key? key, required this.tabIndex}) : super(key: key);

  ///Build Override
  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
        breakpoints: const ScreenBreakpoints(desktop: 600, tablet: 600, watch: 0),
        mobile: (BuildContext context) {
          return const FaqScreenMobile();
        },
        desktop: (BuildContext context) {
          return const FaqScreenWeb();
        });
  }
}
