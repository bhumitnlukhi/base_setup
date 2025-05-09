import 'package:odigo_vendor/framework/utils/extension/extension.dart';
import 'package:odigo_vendor/framework/utils/extension/string_extension.dart';
import 'package:odigo_vendor/ui/utils/helper/base_widget.dart';
import 'package:odigo_vendor/ui/utils/theme/app_strings.g.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_button.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_svg.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_text.dart';

class ProfileTopWidget extends StatelessWidget with BaseStatelessWidget{
  const ProfileTopWidget({Key? key}) : super(key: key);

  @override
  Widget buildPage(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CommonText(
            title: LocaleKeys.keyProfile.localized,
          textStyle: TextStyles.regular.copyWith(
            fontSize: 22.sp,
            color: AppColors.black171717
          ),
        ),
        Row(
          children: [
            CommonButton(
              height: 45.h,
              width: 126.w,
              buttonText: LocaleKeys.keyChangePassword.localized,
              buttonEnabledColor: AppColors.blue009AF1,
              buttonTextStyle: TextStyles.regular.copyWith(
                  fontSize: 15.sp,
                  color: AppColors.white
              ),
              onTap: (){

              },
              isButtonEnabled: true,
            ).paddingOnly(right: 20.w),
            CommonButton(
              height: 45.h,
              width: 126.w,
              leftIcon:CommonSVG(
                strIcon: Assets.svgs.svgEdit.keyName,
                svgColor: AppColors.white,
              ) ,
              buttonText: LocaleKeys.keyEditProfile.localized,
              buttonEnabledColor: AppColors.black171717,
              buttonTextStyle: TextStyles.regular.copyWith(
                  fontSize: 15.sp,
                  color: AppColors.white
              ),
              onTap: (){

              },
              isButtonEnabled: true,
            )
          ],
        ),
      ]
    );
  }
}
