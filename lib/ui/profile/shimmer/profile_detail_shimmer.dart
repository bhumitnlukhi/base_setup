import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/framework/utils/extension/extension.dart';
import 'package:odigo_vendor/framework/utils/extension/string_extension.dart';
import 'package:odigo_vendor/ui/utils/helper/base_widget.dart';
import 'package:odigo_vendor/ui/utils/theme/app_colors.dart';
import 'package:odigo_vendor/ui/utils/theme/app_strings.g.dart';
import 'package:odigo_vendor/ui/utils/theme/text_style.dart';
import 'package:shimmer/shimmer.dart';

class ProfileDetailShimmer extends ConsumerWidget with BaseConsumerWidget {
  const ProfileDetailShimmer({
    super.key,
  });

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Shimmer.fromColors(
        baseColor: AppColors.shimmerBaseColor,
        highlightColor: AppColors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30.h,),
            ///Profile Top Widget
              Row(
            children: [
              Row(
                children: [
                  SizedBox.fromSize(
                    size: Size.fromRadius(45.r),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(45.r),
                      child: Container(
                        color: AppColors.white,
                        height: 50.h,
                        width: 50.h,
                      ),
                    ),
                  ).paddingOnly(right: context.width * 0.02),

                  ///Name And Email
                  SizedBox(
                    width: context.width * 0.2,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        ///Name
                        Container(
                          color: AppColors.white,
                          height: context.height*0.015,
                          width: context.width*0.060,
                        ).paddingOnly(bottom: context.height * 0.010),

                        ///Email and Phone Number
                        Container(
                          color: AppColors.white,
                          height: context.height*0.015,
                          width: context.width*0.100,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ).paddingOnly(bottom: context.height * 0.030, right: context.width * 0.030, left: context.width * 0.030),
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 40.h),

                  ///Title
                  Text(
                    LocaleKeys.keyUserInformation.localized,
                    style: TextStyles.medium.copyWith(
                      fontSize: 20.sp,
                      color: AppColors.black171717,
                    ),
                  ),
                  SizedBox(height: 30.h),

                  ///Common Personal information Tile - Operator Name
                  Text(
                  '',
                    style: TextStyles.medium.copyWith(
                      fontSize: 20.sp,
                      color: AppColors.black171717,
                    ),
                  ),

                  Divider(
                    height: 40.h,
                  ),

                  ///Common Personal information Tile - Operator Name
                  Text(
                    '',
                    style: TextStyles.medium.copyWith(
                      fontSize: 20.sp,
                      color: AppColors.black171717,
                    ),
                  ),

                  SizedBox(
                    height: 13.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ///Change Email button
                      Text(
                        LocaleKeys.keyChangeEmail.localized,
                        style: TextStyles.regular.copyWith(
                          fontSize: 16.sp,
                          decorationColor: AppColors.blue009AF1,
                          decoration: TextDecoration.underline,
                          color: AppColors.blue009AF1,
                        ),
                      )
                    ],
                  ),
                  Divider(
                    height: 40.h,
                  ),

                  ///Common Personal information Tile - Operator Name
                  Text(
                    '',
                    style: TextStyles.medium.copyWith(
                      fontSize: 20.sp,
                      color: AppColors.black171717,
                    ),
                  ),

                  SizedBox(
                    height: 50.h,
                  ),


                ],
              ).paddingSymmetric(horizontal: 38.w),
            ).paddingSymmetric(horizontal: 50.w),
          ],
        ),
      ),
    );
  }
}
