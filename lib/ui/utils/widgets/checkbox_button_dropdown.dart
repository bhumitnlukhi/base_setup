import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:odigo_vendor/framework/provider/network/network.dart';
import 'package:odigo_vendor/framework/utils/extension/extension.dart';
import 'package:odigo_vendor/ui/utils/theme/app_colors.dart';
import 'package:odigo_vendor/ui/utils/theme/text_style.dart';

class CheckBoxButtonDropdown<T> extends StatelessWidget {
  final String? hintText;
  final List<T> menuItems;
  final T? selectedValue;
  final void Function(T?)? onChanged;
  final List<DropdownMenuItem<T>> menuItemsDropDown;

  const CheckBoxButtonDropdown(
      {super.key,
      required this.menuItemsDropDown,
      required this.menuItems,
      this.selectedValue,
      this.onChanged,
      this.hintText});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<T>(
          isExpanded: true,
          hint: Text(
            hintText ?? '',
            style: TextStyles.regular.copyWith(
              fontSize: 14.sp,
              color: AppColors.black,
            ),
          ),
          items: menuItemsDropDown,
          // items: menuItems.map((T) => DropdownMenuItem<List<String>>(
          //   value: item,
          //   child: Container(
          //     width: double.infinity,
          //     height: double.infinity,
          //     decoration: BoxDecoration(
          //       border: selectedValue == item ? null : Border(left: BorderSide(color: AppColors.black, width: 1.w,), right: BorderSide(color: AppColors.black, width: 1.w,), top: BorderSide(color: AppColors.black, width: 1.w,), bottom: (menuItems.last == item) ? BorderSide(color: AppColors.black, width: 1.w,) : BorderSide.none),
          //     ),
          //     padding: selectedValue == item ? null : EdgeInsets.symmetric(horizontal: 14.w),
          //     child: Row(
          //       children: [
          //         // Container(
          //         //   width: 22.h,
          //         //   height: 22.h,
          //         //   decoration: BoxDecoration(
          //         //       border: Border.all(width: 1.w, color: AppColors.black010101),
          //         //       shape: BoxShape.circle
          //         //   ),
          //         //   padding: EdgeInsets.all(4.h),
          //         //   child: selectedValue==item ? Icon(Icons.circle, color: AppColors.black,size: 12.h,) : null,
          //         // ).paddingOnly(right: 12.w),
          //         Expanded(child: Text(item, style: TextStyles.regular.copyWith(fontSize: 14.sp, color: AppColors.black),)),
          //
          //         CommonSVG(strIcon: selectedValue == item ? Assets.svg.svgChechboxSelected2.keyName : Assets.svg.svgCheckboxUnselected.keyName, width: 22.h,
          //             height: 22.h,)
          //       ],
          //     ),
          //   ),
          // ))
          //     .toList(),
          value: selectedValue,
          onChanged: onChanged,
          buttonStyleData: ButtonStyleData(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              height: 56.h,
              width: double.infinity,
              decoration: BoxDecoration(
                  border:
                      Border.all(color: AppColors.black010101, width: 1.w))),
          menuItemStyleData: MenuItemStyleData(
            height: 56.h,
            padding: EdgeInsets.zero,
            selectedMenuItemBuilder: (context, child) {
              return Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border(
                      left: BorderSide(
                        color: AppColors.black,
                        width: 1.w,
                      ),
                      right: BorderSide(
                        color: AppColors.black,
                        width: 1.w,
                      ),
                      top: BorderSide(
                        color: AppColors.black,
                        width: 1.w,
                      ),
                      bottom: (menuItems.last == selectedValue)
                          ? BorderSide(
                              color: AppColors.black,
                              width: 1.w,
                            )
                          : BorderSide.none),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: child,
              );
            },
          ),
          iconStyleData: IconStyleData(
            openMenuIcon: const Icon(Icons.arrow_drop_up_sharp).paddingOnly(right: 14.w),
            icon: const Icon(Icons.arrow_drop_down).paddingOnly(right: 14.w),
            iconSize: 24.h,
            iconEnabledColor: AppColors.black,
            iconDisabledColor: Colors.black,
          ),
        ),
      ),
    );
  }
}

