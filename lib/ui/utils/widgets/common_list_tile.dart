import 'package:odigo_vendor/ui/utils/helper/base_widget.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';
class CommonListTile extends StatelessWidget with BaseStatelessWidget {
  final Widget? childWidget;
  final double? height;
  final double? width;
  final Function(PointerDownEvent)? onTapOutside;
  final Color? clrSplash;
  final Color? clrSearchIcon;
  final double? borderRadius;
  final String placeholder;
  final Color? borderColor;
  final Color? bgColor;
  final double? borderWidth;
  final Function()? onTap;
  final double? circularValue;
  CommonListTile({
    Key? key,
    required this.childWidget,
    this.onTap,
    this.width,
    this.height,
    this.clrSplash,
    this.clrSearchIcon,
    this.borderRadius,
    this.placeholder = '',
    this.bgColor,
    this.borderColor,
    this.borderWidth,
    this.onTapOutside,
    this.circularValue
  }) : super(key: key);

  @override
  Widget buildPage(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor ?? AppColors.whiteF7F7FC,
        borderRadius: BorderRadius.circular(borderRadius ?? 20.r),
        // border: Border.all(color: borderColor ?? AppColors.transparent, width: (borderWidth ?? 0.5).w),
      ),
      width: width ?? double.infinity,
      // constraints: BoxConstraints(
      //   maxHeight: height ?? 76.h,
      // ),
      // height: height ?? 76.h,
      child: InkWell(
        splashColor: clrSplash ?? AppColors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(circularValue ?? 7.r),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.only(left: 10.w, right: 0.w),
          child: childWidget,
        ),
      ),
    );
  }
}