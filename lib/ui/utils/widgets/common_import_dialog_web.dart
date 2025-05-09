import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/framework/utils/extension/extension.dart';
import 'package:odigo_vendor/framework/utils/extension/string_extension.dart';
import 'package:odigo_vendor/ui/utils/helper/base_widget.dart';
import 'package:odigo_vendor/ui/utils/theme/app_strings.g.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_button.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_svg.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_text.dart';

class CommonImportDialogWeb extends StatelessWidget with BaseStatelessWidget{
  final String title;
  final GestureTapCallback? onSaveTap;
  final Function()? onBrowseTap;
  final GestureTapCallback? onDownLoadSampleTap;
  const CommonImportDialogWeb({Key? key, required this.title, this.onSaveTap, this.onBrowseTap, this.onDownLoadSampleTap}) : super(key: key);

  @override
  Widget buildPage(BuildContext context) {
    return Column(
      children: [

        /// Ttile and cross icon
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CommonText(
                title: title,
              textStyle: TextStyles.regular.copyWith(
                fontSize: 20.sp,
              ),
            ),
            InkWell(
              onTap: (){
                Navigator.of(context).pop();
              },
              child: CommonSVG(
                  strIcon: Assets.svgs.svgCrossRounded.keyName,
              ),
            ),
          ],
        ).paddingOnly(bottom: context.height*0.03),

        Container(
          width: context.width,
          decoration: BoxDecoration(
            border:Border.all(color: AppColors.clr8D8D8D),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              /// Icon
              CommonSVG(strIcon: Assets.svgs.svgFileUpload.keyName).paddingOnly(top: context.height*0.05,bottom:  context.height*0.03),

              /// Drag message
              CommonText(
                  title: LocaleKeys.keyDragAndDropFile.localized,
                textStyle: TextStyles.regular.copyWith(
                  color: AppColors.clr8D8D8D,
                  fontSize: 14.sp,
                ),
              ).paddingOnly(bottom: 8.h),

              CommonText(
                title:LocaleKeys.keyOr.localized,
                textStyle: TextStyles.regular.copyWith(
                  color: AppColors.clr8D8D8D,
                  fontSize: 14.sp,
                ),
              ).paddingOnly(bottom: 8.h),

              /// Browse message
              InkWell(
                onTap: onBrowseTap??(){},
                child: CommonText(
                  title: LocaleKeys.keyBrowseFile.localized,
                  textStyle: TextStyles.regular.copyWith(
                    color: AppColors.blue009AF1,
                    fontSize: 14.sp,
                  ),
                ).paddingOnly(bottom: context.height*0.02),
              ),
            ],
          ),
        ).paddingOnly(bottom: context.height*0.03,left: context.width*0.01,right: context.width*0.01),

        /// bottom buttons
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// Download sample
            CommonButton(
              width: context.width*0.13,
              height: 50.h,
              leftIcon: CommonSVG(
                strIcon: Assets.svgs.svgDownloadSample.keyName,
              ).paddingOnly(right: 8.w),
              buttonText:LocaleKeys.keyDownloadSample.localized,
              buttonTextStyle: TextStyles.regular.copyWith(
                color: AppColors.white,
                fontSize: 14.sp,
              ),
              buttonEnabledColor: AppColors.black,
              isButtonEnabled:true,
              onTap: onDownLoadSampleTap,
            ).paddingOnly(right: 20.w),

            /// Save button
            CommonButton(
              width: context.width*0.1,
              height: 50.h,
              buttonText: LocaleKeys.keySave.localized,
              buttonTextStyle: TextStyles.regular.copyWith(
                color: AppColors.white,
                fontSize: 14.sp,
              ),
              buttonEnabledColor: AppColors.blue009AF1,
              isButtonEnabled:true,
              onTap: onSaveTap,
            ),
          ],
        ).paddingOnly(left: context.width*0.07,right: context.width*0.07),
        // Row(
        //   children: [
        //     Row(
        //       children: [
        //
        //         /// Download sample
        //         CommonButton(
        //           height: 50.h,
        //           leftIcon: CommonSVG(
        //             strIcon: Assets.svgs.svgImport.keyName,
        //           ),
        //           buttonText: 'Download sample',
        //           buttonTextStyle: TextStyles.regular.copyWith(
        //             color: AppColors.white,
        //             fontSize: 14.sp,
        //           ),
        //           buttonEnabledColor: AppColors.black,
        //           isButtonEnabled:true,
        //           onTap: onSaveTap,
        //         ),
        //
        //         /// Save button
        //         CommonButton(
        //           height: 50.h,
        //           buttonText: LocaleKeys.keySave.localized,
        //           buttonTextStyle: TextStyles.regular.copyWith(
        //             color: AppColors.white,
        //             fontSize: 14.sp,
        //           ),
        //           buttonEnabledColor: AppColors.blue009AF1,
        //           isButtonEnabled:true,
        //           onTap: onSaveTap,
        //         )
        //       ],
        //     ),
        //     const Spacer(),
        //   ],
        // )

      ],
    ).paddingAll(context.height*0.02);
  }
}
