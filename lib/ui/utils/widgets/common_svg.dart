// ignore_for_file: deprecated_member_use
import 'dart:math';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:odigo_vendor/framework/utils/session.dart';
import 'package:odigo_vendor/ui/utils/helper/base_widget.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';

class CommonSVG extends StatelessWidget with BaseStatelessWidget {
  final String strIcon;
  final ColorFilter? colorFilter;
  final Color? svgColor;
  final double? height;
  final double? width;
  final BoxFit? boxFit;
  final bool isRotate;

  const CommonSVG({super.key, required this.strIcon, this.svgColor, this.height, this.width, this.boxFit, this.colorFilter, this.isRotate = false});

  @override
  Widget buildPage(BuildContext context) {
    return Transform.rotate(
      angle: (Session.isRTL && isRotate) ? pi : 0,
      child: SvgPicture.asset(
        strIcon,
        colorFilter: colorFilter,
        color: svgColor,
        height: height,
        width: width,
        fit: boxFit ?? BoxFit.contain,
      ),
    );
  }
}
