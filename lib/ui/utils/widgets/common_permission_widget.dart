import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:odigo_vendor/framework/utils/extension/extension.dart';
import 'package:odigo_vendor/framework/utils/extension/string_extension.dart';
import 'package:odigo_vendor/ui/utils/helper/base_widget.dart';
import 'package:odigo_vendor/ui/utils/theme/app_strings.g.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_button.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_text.dart';


class CommonPermissionWidget extends ConsumerWidget with BaseConsumerWidget {
  final Function() onPositiveButtonTap;
  const CommonPermissionWidget({super.key,required this.onPositiveButtonTap,});

  @override
  Widget buildPage(BuildContext context,ref) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Lottie.asset(
          Assets.anim.animCameraStorage.keyName,
          height: 145.h,
          width: 145.h,
          fit: BoxFit.scaleDown,
      ).paddingOnly(top: 30.h),

        ///title
        CommonText(
        title: LocaleKeys.keyCameraStoragePermissionRequiredMessage.localized,
          textStyle: TextStyles.medium.copyWith(
              color: AppColors.black171717,fontSize: 18.sp
          ),
          textAlign: TextAlign.center,
          maxLines: 3,
        ).paddingOnly(bottom: 15.h,left: 40.h,right: 40.h),

        ///Sub title
        CommonText(
          title:  LocaleKeys.keyCameraStoragePermissionGrantMessage.localized,
          textStyle: TextStyles.regular.copyWith(
              color: AppColors.grey828282,fontSize: 14.sp),
          maxLines: 3,
          textAlign: TextAlign.center,
        ).paddingOnly(left: 40.h,right: 40.h,bottom: 30.h),

        ///Bottom Buttons
        Row(
          children: [
            Expanded(
              child: CommonButton(
                  height: 55.h,
                  buttonText: LocaleKeys.keyNotNow.localized,
                  onTap: () {
                    Navigator.pop(context);
                  },
                  buttonEnabledColor: AppColors.lightPinkF7F7FC,
                  buttonTextColor: AppColors.black171717),
            ),

            SizedBox(
              width: 15.w,
            ),
            Expanded(
              child: CommonButton(
                  height: 55.h,
                  buttonText: LocaleKeys.keyContinue.localized,
                  onTap: onPositiveButtonTap,
                  buttonEnabledColor: AppColors.black171717,
                  buttonTextColor: AppColors.white),
            ),
          ],
        ).paddingSymmetric(horizontal: 15.w,vertical: 15.h)

      ],
    );
  }

}


