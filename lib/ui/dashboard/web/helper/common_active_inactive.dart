import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:odigo_vendor/framework/utils/extension/extension.dart';
import 'package:odigo_vendor/framework/utils/session.dart';
import 'package:odigo_vendor/ui/utils/helper/base_widget.dart';
import 'package:odigo_vendor/ui/utils/theme/app_colors.dart';
import 'package:odigo_vendor/ui/utils/theme/text_style.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_text.dart';

class CommonActiveInactive extends StatelessWidget with BaseStatelessWidget {
  final String title;
  final Color containerColor;
  final String? countText;
  final int count;
  final bool? currencyRequired;

  const CommonActiveInactive({
    super.key,
    required this.title,
    required this.containerColor,
    required this.countText,
    required this.count,
    this.currencyRequired,
  });

  @override
  Widget buildPage(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.zero,
              decoration: BoxDecoration(
                  color: containerColor,
                  borderRadius: BorderRadius.circular(8.r)),
              height: 8.h,
              width: 35.w,
            ).paddingOnly(right: 15.w),
            CommonText(
              title: title,
              textStyle: TextStyles.regular
                  .copyWith(color: AppColors.clrD0D1D2, fontSize: 18.sp),
            ).paddingOnly(bottom: 3.h),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 35.w,
            ).paddingOnly(right: 15.w),
            CommonText(
              title: (currencyRequired ?? false)
             ? '${Session.getCurrency()} ${(count) < 10 ? '0$count' : (count)}'
             : (count) < 10 ? '0$count $countText' : '$count $countText',
              //title: currencyRequired??false?'\$$count':'$count $countText',
              textStyle: TextStyles.semiBold
                  .copyWith(color: AppColors.clr11263C, fontSize: 18.sp),
            ),
          ],
        )
      ],
    );
  }
}
