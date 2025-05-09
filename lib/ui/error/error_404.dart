import 'package:flutter/material.dart';
import 'package:odigo_vendor/ui/error/mobile/error_404_mobile.dart';
import 'package:odigo_vendor/ui/error/web/error_404_web.dart';
import 'package:odigo_vendor/ui/utils/const/app_enums.dart';
import 'package:odigo_vendor/ui/utils/helper/base_widget.dart';
import 'package:responsive_builder/responsive_builder.dart';



class Error extends StatelessWidget with BaseStatelessWidget {
  final ErrorType? errorType;

  const Error({Key? key, this.errorType}) : super(key: key);

  ///Build Override
  @override
  Widget buildPage(BuildContext context) {
    return ScreenTypeLayout.builder(
      breakpoints: const ScreenBreakpoints(desktop: 600, tablet: 600, watch: 0),

      mobile: (BuildContext context) {
        return const Error404Mobile();
      },
      desktop: (BuildContext context) {
        return ErrorWeb(errorType: errorType);
      },
      tablet: (BuildContext context) {
        return OrientationBuilder(
          builder: (BuildContext context, Orientation orientation) {
            return orientation == Orientation.landscape ? ErrorWeb(errorType: errorType) : const Error404Mobile();
          },
        );
      },
    );
  }
}
