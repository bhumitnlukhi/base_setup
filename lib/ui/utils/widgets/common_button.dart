import 'package:flutter_base_setup/ui/utils/theme/theme.dart';
import 'package:flutter_base_setup/ui/utils/widgets/safe_on_tap_button.dart';


class CommonButton extends StatelessWidget {
  final double? height;
  final double? width;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? borderWidth;
  final BorderRadius? borderRadius;
  final String? leftImage;
  final double? leftImageHeight;
  final double? leftImageWidth;
  final double? leftImageHorizontalPadding;
  final String? rightImage;
  final double? rightImageHeight;
  final double? rightImageWidth;
  final double? rightImageHorizontalPadding;
  final String? buttonText;
  final int? buttonMaxLine;
  final TextStyle? buttonTextStyle;
  final double? buttonHorizontalPadding;
  final GestureTapCallback? onTap;
  final TextAlign? buttonTextAlignment;
  final Color? buttonTextColor;

  const CommonButton({
    Key? key,
    this.height,
    this.width,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth,
    this.borderRadius,
    this.leftImage,
    this.leftImageHeight,
    this.leftImageWidth,
    this.leftImageHorizontalPadding,
    this.rightImage,
    this.rightImageHeight,
    this.rightImageWidth,
    this.rightImageHorizontalPadding,
    this.buttonText,
    this.buttonMaxLine,
    this.buttonTextStyle,
    this.buttonHorizontalPadding,
    this.onTap,
    this.buttonTextAlignment,
    this.buttonTextColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeOnTap(
      onSafeTap: () {
        onTap?.call();
      },
      child: Container(
        height: height ?? 48.h,
        width: width ?? double.infinity,
        decoration: BoxDecoration(
            color: backgroundColor ?? AppColors.primary,
            borderRadius: borderRadius ?? BorderRadius.circular(10.r),
            border: Border.all(
                color: borderColor ?? AppColors.transparent,
                width: borderWidth ?? 0)),
        child: Row(
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if ((leftImage ?? '').isNotEmpty)
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: leftImageHorizontalPadding ?? 12.w),
                child: Image.asset(
                  leftImage!,
                  height: leftImageHeight,
                  width: leftImageWidth,
                ),
              ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: buttonHorizontalPadding ?? 0),
                child: Text(
                  buttonText ?? '',
                  textAlign: buttonTextAlignment ?? TextAlign.center,
                  maxLines: buttonMaxLine ?? 1,
                  style: buttonTextStyle ??
                      TextStyles.medium.copyWith(
                          fontSize: 14.sp,
                          color: buttonTextColor ?? AppColors.white),
                ),
              ),
            ),
            if ((rightImage ?? '').isNotEmpty)
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: rightImageHorizontalPadding ?? 12.w),
                child: Image.asset(
                  rightImage!,
                  height: rightImageHeight,
                  width: rightImageWidth,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/*
Widget Usage
CommonButton(
          buttonText: "Login",
          onTap: () {

          },
        )
* */
