import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:odigo_vendor/framework/provider/network/network.dart';
import 'package:odigo_vendor/ui/utils/helper/base_widget.dart';
import 'package:odigo_vendor/ui/utils/theme/app_colors.dart';
import 'package:odigo_vendor/ui/utils/theme/assets.gen.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_svg.dart';

class CommonBubbleWidget extends StatelessWidget with BaseStatelessWidget {
  final bool isBubbleFromLeft;
  final double? height;
  final double? width;
  final double? borderRadius;
  final double? positionFromLeft;
  final double? positionFromRight;
  final double? positionFromTop;
  final Widget child;
  final Color? bubbleColor;

  const CommonBubbleWidget({super.key, required this.isBubbleFromLeft, this.height, required this.child, this.positionFromLeft, this.positionFromRight, this.width, this.borderRadius, this.positionFromTop, this.bubbleColor});

  @override
  Widget buildPage(BuildContext context) {
    return Container(
      color: Colors.transparent,
      height: height != null ? ((height ?? 0) + 0.02.sh) : null,
      width: width,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            top: positionFromTop ?? 0.02.sh,
            child: Container(
              height: height,
              width: width,
              decoration: BoxDecoration(
                color: bubbleColor??AppColors.white,
                borderRadius: BorderRadius.circular(borderRadius ?? 15.r),
              ),
              child: child,
            ),
          ),
          isBubbleFromLeft
              ? Positioned(
                  left: positionFromLeft ?? 50.w,
                  child:  CommonSVG(
                    strIcon: Assets.svgs.svgLeftTriangle.keyName,
                    svgColor:bubbleColor,
                  ),
                )
              : Positioned(
                  right: positionFromRight ?? 50.w,
                  child: CommonSVG(
                    strIcon: Assets.svgs.svgRightTriangle.keyName,
                    svgColor: bubbleColor,
                  ),
                ),
        ],
      ),
    );
  }
}
