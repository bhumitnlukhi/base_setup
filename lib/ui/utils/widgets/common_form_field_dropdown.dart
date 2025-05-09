
import 'package:flutter_base_setup/ui/utils/theme/theme.dart';

class CommonDropdownInputFormField<T> extends StatelessWidget {
  final String? placeholderImage;
  final double? placeholderImageHeight;
  final double? placeholderImageWidth;
  final double? placeholderImageHorizontalPadding;
  final String? placeholderText;
  final TextStyle? placeholderTextStyle;
  final String? hintText;
  final TextStyle? hintTextStyle;
  final double? fieldWidth;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? borderWidth;
  final BorderRadius? borderRadius;
  final bool? isEnable;
  final Widget? prefixWidget;
  final Widget? suffixWidget;
  final TextStyle? fieldTextStyle;
  final TextStyle? dropDownTextItemStyle;
  final String? Function(T? value)? validator;

  final InputDecoration? inputDecoration;

  final double? bottomFieldMargin;
  final List<T> menuItems;
  final T? defaultValue;
  final void Function(T? value)? onChanged;
  final List<Widget> Function(BuildContext context)? selectedItemBuilder;

  const CommonDropdownInputFormField(
      {Key? key,
      this.placeholderImage,
      this.placeholderImageHeight,
      this.placeholderImageWidth,
      this.placeholderImageHorizontalPadding,
      this.placeholderText,
      this.placeholderTextStyle,
      this.hintText,
      this.hintTextStyle,
      this.fieldWidth,
      this.backgroundColor,
      this.borderColor,
      this.borderWidth,
      this.borderRadius,
      this.isEnable,
      this.prefixWidget,
      this.suffixWidget,
      this.inputDecoration,
      this.bottomFieldMargin,
      this.fieldTextStyle,
      required this.menuItems,
      this.defaultValue,
      required this.onChanged,
      this.selectedItemBuilder,
      this.dropDownTextItemStyle,
      this.validator})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (((placeholderImage ?? '').isNotEmpty) ||
            ((placeholderText ?? '').isNotEmpty))
          Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if ((placeholderImage ?? '').isNotEmpty)
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: placeholderImageHorizontalPadding ?? 0.w),
                    child: Image.asset(
                      placeholderImage!,
                      height: placeholderImageHeight ?? 32,
                      width: placeholderImageWidth ?? 32,
                    ),
                  ),
                if ((placeholderText ?? '').isNotEmpty)
                  Text(
                    placeholderText!,
                    style: placeholderTextStyle ??
                        TextStyles.regular.copyWith(
                            fontSize: 12.sp, color: AppColors.primary),
                  ),
              ],
            ),
          ),
        SizedBox(
          width: fieldWidth ?? double.infinity,
          child: Padding(
            padding: EdgeInsets.only(bottom: bottomFieldMargin ?? 0),
            child: ButtonTheme(
              alignedDropdown: true,
              padding: const EdgeInsets.all(0),
              child: DropdownButtonFormField<T>(
                isExpanded: true,
                style: fieldTextStyle ?? TextStyles.regular,
                value: defaultValue,
                iconSize: 14.h,
                validator: validator,
                icon: suffixWidget ??
                    Icon(
                      Icons.keyboard_arrow_down,
                      size: 30.sp,
                      color: AppColors.textByTheme(),
                    ),
                items: menuItems.map<DropdownMenuItem<T>>((T value) {
                  // if (value is Choices) {
                  //   return DropdownMenuItem<T>(
                  //     value: value,
                  //     child: Padding(
                  //       padding: EdgeInsets.symmetric(horizontal: 4.w),
                  //       child: Text(value.label ?? '',
                  //           style: dropDownTextItemStyle ??
                  //               TextStyles.regular.copyWith(
                  //                   color: AppColors.textWhiteByNewBlack2(),
                  //                   fontSize: 14.sp)),
                  //     ),
                  //   );
                  // } else {
                    return DropdownMenuItem<T>(
                      value: value,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.w),
                        child: Text(value.toString(),
                            style: dropDownTextItemStyle ??
                                TextStyles.regular.copyWith(
                                    color: AppColors.textWhiteByNewBlack2(),
                                    fontSize: 14.sp)),
                      ),
                    );
                  // }
                }).toList(),
                onChanged: onChanged,
                selectedItemBuilder: selectedItemBuilder,
                decoration: InputDecoration(
                    enabled: isEnable ?? true,
                    counterText: '',
                    filled: true,
                    fillColor: backgroundColor ?? AppColors.transparent,
                    suffixIcon: suffixWidget != null
                        ? Padding(
                            padding: const EdgeInsets.all(2),
                            child: suffixWidget)
                        : null,
                    prefixIcon: prefixWidget,
                    contentPadding: EdgeInsets.fromLTRB(8.w, 12.h, 8.w, 12.h),
                    disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.grey5B5B5B,
                        width: borderWidth ?? 1,
                        style: BorderStyle.solid,
                      ),
                      borderRadius: borderRadius ?? BorderRadius.circular(10.r),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: borderColor ?? AppColors.grey5B5B5B,
                        width: borderWidth ?? 1,
                        style: BorderStyle.solid,
                      ),
                      borderRadius: borderRadius ?? BorderRadius.circular(10.r),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.red,
                        width: borderWidth ?? 1,
                        style: BorderStyle.solid,
                      ),
                      borderRadius: borderRadius ?? BorderRadius.circular(10.r),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: borderColor ?? AppColors.grey5B5B5B,
                        width: borderWidth ?? 1,
                        style: BorderStyle.solid,
                      ),
                      borderRadius: borderRadius ?? BorderRadius.circular(10.r),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.red,
                        width: borderWidth ?? 1,
                        style: BorderStyle.solid,
                      ),
                      borderRadius: borderRadius ?? BorderRadius.circular(10.r),
                    ),
                    border: InputBorder.none,
                    hintText: hintText,
                    alignLabelWithHint: true,
                    hintStyle: hintTextStyle),
              ),
            ),
          ),
        )
      ],
    );
  }
}
/*
Widget Usage

CommonInputFormField(
  textEditingController: _mobileController,
  suffixWidget: Image.asset(Assets.imagesIcApple),
  validator: validateEmail,
  backgroundColor: AppColors.pinch,
  prefixWidget: Image.asset(Assets.imagesIcApple),
  placeholderImage: Assets.imagesIcApple,
  placeholderText: 'Mobile Number',
)
*/
