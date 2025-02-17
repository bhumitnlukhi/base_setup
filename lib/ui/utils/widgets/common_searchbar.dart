import 'package:flutter_base_setup/framework/utility/extension/string_extension.dart';
import 'package:flutter/services.dart';
import 'package:flutter_base_setup/ui/utils/theme/theme.dart';

class CommonSearchBar extends StatelessWidget {
  final double? height;
  final String? label;
  final String iconName;
  final bool? isHomeSearch;
  final Function()? onTap;
  final ValueChanged<String>? onChanged;
  final double? elevation;
  final double? circularValue;
  final Color? clrSplash;
  final Color? clrBG;
  final Color? clrSearchIcon;

  final bool? isRemoveMargin;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final double? borderRadius;
  final String? hintText;
  final String icSearchIcon;
  final bool? isClearSearchRequired;
  final Function()? onClearSearch;

  const CommonSearchBar({
    Key? key,
    this.onTap,
    this.onClearSearch,
    this.height,
    this.label,
    this.iconName = '',
    this.isHomeSearch,
    required this.icSearchIcon,
    this.onChanged,
    this.elevation,
    this.circularValue,
    this.clrSplash,
    this.clrBG,
    this.clrSearchIcon,
    this.isRemoveMargin,
    this.borderRadius,
    required this.controller,
    this.focusNode,
    this.hintText,
    this.isClearSearchRequired,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isHomeSearch ?? false
        ? InkWell(
            onTap: onTap,
            child: Container(
              height: height ?? 48.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: AppColors.greyCFCFCF),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      icSearchIcon,
                      height: 18.h,
                      width: 18.w,
                      color: AppColors.primary,
                    ),
                    SizedBox(
                      width: 20.w,
                    ),
                    Text(label ?? 'Key_searchHere'.localized,
                        style: TextStyle(
                            fontWeight: TextStyles.fwRegular,
                            fontSize: 12.sp,
                            color: AppColors.black)),
                  ],
                ),
              ),
            ),
          )
        : Container(
            decoration: BoxDecoration(
                color: AppColors.cardBGByTheme(),
                borderRadius: BorderRadius.circular(borderRadius ?? 10.r),
                border: Border.all(color: AppColors.greyCFCFCF, width: 0.5.w)),
            height: height ?? 48.h,
            child: InkWell(
              splashColor: clrSplash ?? AppColors.grey5B5B5B.withOpacity(0.3),
              borderRadius: BorderRadius.circular(circularValue ?? 7.r),
              onTap: onTap,
              child: Padding(
                padding: EdgeInsets.only(left: 10.w, right: 0.w),
                child: Center(
                  child: TextFormField(
                    controller: controller,
                    focusNode: focusNode,
                    cursorColor: AppColors.primary,
                    textAlignVertical: TextAlignVertical.center,
                    style: TextStyles.regular.copyWith(color: AppColors.black),
                    textInputAction: TextInputAction.search,
                    onChanged: onChanged,
                    maxLines: 1,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(60),
                    ],
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        isDense: true,
                        border: InputBorder.none,
                        hintStyle: TextStyles.regular
                            .copyWith(color: AppColors.greyCFCFCF),
                        prefixIcon: Padding(
                          padding: EdgeInsets.only(
                              top: 10.h, bottom: 10.h, right: 16.w),
                          child: Image.asset(
                            icSearchIcon,
                            height: 18.h,
                            width: 18.w,
                            color: clrSearchIcon ?? AppColors.primary,
                          ),
                        ),
                        prefixIconConstraints:
                            BoxConstraints(minHeight: 10.h, minWidth: 20.w),
                        hintText: hintText,
                        suffixIcon: isClearSearchRequired == true
                            ? InkWell(
                                onTap: onClearSearch,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      top: 10.h, bottom: 10.h, right: 0.w),
                                  child: (iconName.isEmpty) ? Icon(
                                    Icons.search,
                                    color: AppColors.greyCFCFCF,
                                    size: 18.h,
                                  ) : Image.asset(
                                    iconName,
                                    height: 18.h,
                                    width: 18.w,
                                  ),
                                ),
                              )
                            : null),
                  ),
                ),
              ),
            ),
          );
  }
}
