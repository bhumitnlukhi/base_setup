// import 'package:odigo_vendor/framework/utils/extension/extension.dart';
// import 'package:odigo_vendor/ui/utils/const/app_constants.dart';
// import 'package:odigo_vendor/ui/utils/widgets/common_svg.dart';
// import 'package:dropdown_button2/dropdown_button2.dart';
// import 'package:odigo_vendor/ui/utils/theme/theme.dart';
//
// class CommonDropDown<T> extends StatelessWidget {
//   final String? placeholderImage;
//   final double? placeholderImageHeight;
//   final double? placeholderImageWidth;
//   final double? placeholderImageHorizontalPadding;
//   final String? placeholderText;
//   final TextStyle? placeholderTextStyle;
//   final String? hintText;
//   final TextStyle? hintTextStyle;
//   final double? fieldWidth;
//   final Color? backgroundColor;
//   final Color? borderColor;
//   final double? borderWidth;
//   final BorderRadius? borderRadius;
//   final bool? isEnable;
//   // final bool borderEnable;
//   final Widget? prefixWidget;
//   final Widget? suffixWidget;
//   final TextStyle? fieldTextStyle;
//   final TextStyle? dropDownTextItemStyle;
//   final String? Function(T? value)? validator;
//   final String? imageUrl;
//   final Color? dropDownBackground;
//   final InputDecoration? inputDecoration;
//   final double? bottomFieldMargin;
//   final List<T?> menuItems;
//   final T? defaultValue;
// //  final void Function(T?)? onChanged;
//   final void Function(T? value)? onChanged;
//   final double? maxDropdownHeight;
//   final double? maxDropdownWidth;
//   final List<DropdownMenuItem<T>> menuItemsDropDown;
//   // final void Function(T? value)? onChanged;
//   final List<Widget> Function(BuildContext context)? selectedItemBuilder;
//   final int? elevation;
//   final Color? selectedColor;
//   final IconStyleData? iconStyleData;
//   final EdgeInsets? hintTextPadding;
//   const CommonDropDown(
//       {Key? key,
//         this.placeholderImage,
//         this.placeholderImageHeight,
//         this.placeholderImageWidth,
//         this.placeholderImageHorizontalPadding,
//         this.placeholderText,
//         this.placeholderTextStyle,
//         this.hintText,
//         this.hintTextStyle,
//         this.fieldWidth,
//         this.backgroundColor,
//         this.borderColor,
//         this.borderWidth,
//         this.borderRadius,
//         this.isEnable,
//         // required this.borderEnable,
//         this.prefixWidget,
//         this.suffixWidget,
//         this.inputDecoration,
//         this.bottomFieldMargin,
//         this.fieldTextStyle,
//         required this.menuItems,
//         this.defaultValue,
//         required this.onChanged,
//         this.selectedItemBuilder,
//         this.dropDownTextItemStyle,
//         this.imageUrl,
//         this.dropDownBackground,
//         this.validator,
//         this.maxDropdownHeight,
//         this.maxDropdownWidth,
//         required  this.menuItemsDropDown,
//         this.elevation,
//         this.selectedColor,
//         this.iconStyleData,
//         this.hintTextPadding
//       })
//       : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         if (((placeholderImage ?? '').isNotEmpty) ||
//             ((placeholderText ?? '').isNotEmpty))
//           Padding(
//             padding: EdgeInsets.only(bottom: 0.h),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 if ((placeholderImage ?? '').isNotEmpty)
//                   Padding(
//                     padding: EdgeInsets.symmetric(
//                         horizontal: placeholderImageHorizontalPadding ?? 0.w),
//                     child: Image.asset(
//                       placeholderImage!,
//                       height: placeholderImageHeight ?? 32,
//                       width: placeholderImageWidth ?? 32,
//                     ),
//                   ),
//                 if ((placeholderText ?? '').isNotEmpty)
//                   Text(
//                     placeholderText!,
//                     style: placeholderTextStyle ??
//                         TextStyles.regular.copyWith(
//                             fontSize: 12.sp, color: AppColors.black),
//                   ),
//               ],
//             ),
//           ),
//         SizedBox(
//           width: fieldWidth ?? double.infinity,
//           child: Padding(
//             padding: EdgeInsets.only(bottom: bottomFieldMargin ?? 0),
//             child: DropdownButtonFormField2(
//               onMenuStateChange: (isOpen) {
//                 if (!isOpen) {
//                   hideKeyboard(context);
//                 }
//               },
//
//               menuItemStyleData:  MenuItemStyleData(
//                 height: 40.h,
//                 selectedMenuItemBuilder: (ctx, child) {
//                   return Container(
//                     color: selectedColor ?? AppColors.white,
//                     child: child,
//                   );
//                 },
//
//               ),
//
//               validator: validator,
//               alignment:  AlignmentDirectional.centerStart,
//               decoration: InputDecoration(
//
//                 isDense: true,
//                 // errorPadding: EdgeInsets.only(left: borderEnable ? 8.w : 0),
//                 // contentPadding :EdgeInsets.zero,
//
//                 //Add isDense true and zero Padding.
//                 //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
//                 contentPadding:  EdgeInsets.only(left: 3.w),
//
//                 //  contentPadding: EdgeInsets.symmetric(horizontal: 1==1? 10.w: 0.w),
//                 border: null,
//                 // border: OutlineInputBorder(
//                 //
//                 //   borderRadius: BorderRadius.circular(10),
//                 // ),
//                 //Add more decoration as you want here
//                 //Add label If you want but add hint outside the decoration to be aligned in the button perfectly.
//                 focusedBorder:   OutlineInputBorder(
//                   borderSide: BorderSide(
//                     color: borderColor ?? AppColors.black010101,
//                     width: borderWidth ?? 1,
//                     style: BorderStyle.solid,
//                   ),
//                   borderRadius: borderRadius ?? BorderRadius.circular(10.r),
//                 ),
//                 disabledBorder: OutlineInputBorder(
//                   borderSide: BorderSide(
//                     color: borderColor ?? AppColors.black010101,
//                     width: borderWidth ?? 1,
//                     style: BorderStyle.solid,
//                   ),
//                   borderRadius: borderRadius ?? BorderRadius.circular(10.r),
//                 ),
//                 enabledBorder:  OutlineInputBorder(
//                   borderSide: BorderSide(
//                     color: borderColor ?? AppColors.black010101,
//                     width: borderWidth ?? 1,
//                     style: BorderStyle.solid,
//                   ),
//                   borderRadius: borderRadius ?? BorderRadius.circular(10.r),
//                 ),
//                 focusedErrorBorder: OutlineInputBorder(
//                   borderSide: BorderSide(
//                     color: borderColor ?? AppColors.black010101,
//                     width: borderWidth ?? 1,
//                     style: BorderStyle.solid,
//                   ),
//                   borderRadius: borderRadius ?? BorderRadius.circular(10.r),
//                 ),
//                 errorBorder: OutlineInputBorder(
//                   borderSide: BorderSide(
//                     color: borderColor ?? AppColors.black010101,
//                     width: borderWidth ?? 1,
//                     style: BorderStyle.solid,
//                   ),
//                   borderRadius: borderRadius ?? BorderRadius.circular(10.r),
//                 ),
//                 suffixIcon: suffixWidget
//               ),
//               isExpanded: true,
//               hint: Row(
//                 children: [
//                   Expanded(
//                     child: Padding(
//                       padding: hintTextPadding??EdgeInsets.only(left: 16.w),
//                       child: Text(
//                         hintText ?? 'Select Value',
//                         style: hintTextStyle ??
//                             TextStyle(
//                                 fontSize: 14.sp,
//                                 fontWeight: FontWeight.normal,
//                                 color: Colors.grey,
//                                 fontFamily: TextStyles.fontFamily),
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               items:menuItemsDropDown,
//
//               value: defaultValue,
//               onChanged: onChanged,
//               selectedItemBuilder: selectedItemBuilder,
//               iconStyleData: iconStyleData ?? IconStyleData(
//
//                 openMenuIcon: const Icon(Icons.arrow_drop_up_sharp).paddingOnly(right: 14.w),
//                 icon: const Icon(Icons.arrow_drop_down).paddingOnly(right: 14.w),
//                 iconSize: 24,
//                 iconEnabledColor: AppColors.black,
//                 iconDisabledColor: Colors.black,
//               ),
//               dropdownStyleData: DropdownStyleData(
//                   width: maxDropdownWidth ,
//                   padding: EdgeInsets.symmetric(vertical: 10.h),
//                   // maxHeight: maxDropdownHeight ?? 200.h,
//                   elevation: elevation ?? 6,
//
//                   scrollbarTheme: ScrollbarThemeData(
//                       radius: Radius.circular(40.r),
//                       thickness: MaterialStateProperty.all(6),
//                       trackVisibility: MaterialStateProperty.all(true)),
//                   decoration: BoxDecoration(
//                     //  color: dropDownBackground ??AppColors.clrFAFAFA,
//                     border: const Border(
//                       bottom: BorderSide(
//                         color: AppColors.black010101
//                       ),
//                       left: BorderSide(
//                           color: AppColors.black010101
//                       ),
//                       right: BorderSide(
//                           color: AppColors.black010101
//                       ),
//                     ),
//                     color: dropDownBackground ??AppColors.white,
//                   )),
//               isDense: true,
//               buttonStyleData: ButtonStyleData(
//                 height: 51,
//                 width: 180,
//
//                 padding: EdgeInsets.only(right: 5.w),
//                 decoration:  BoxDecoration(
//                   // color: borderColor ?? AppColors.transparent,
//                   border: Border(
//                     bottom: BorderSide(color: borderColor ?? AppColors.transparent),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         )
//       ],
//     );
//   }
// }