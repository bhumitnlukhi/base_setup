import 'package:flutter/foundation.dart';
import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/framework/utils/extension/extension.dart';
import 'package:odigo_vendor/framework/utils/extension/string_extension.dart';
import 'package:odigo_vendor/ui/utils/const/app_constants.dart';
import 'package:odigo_vendor/ui/utils/theme/app_strings.g.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_dialogs.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_svg.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_text.dart';

class CommonImageSelectionWidget extends StatelessWidget {
  final bool? imageRemoved;
  final Uint8List? pickedImage;
  final Function()? onTap;
  final Function()? onRemovedTap;
  final double? height;
  final double? width;

  const CommonImageSelectionWidget({super.key, this.imageRemoved, required this.onTap, required this.pickedImage, required this.onRemovedTap, this.height, this.width});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        height: height ?? context.height * 0.250,
        width: width ?? context.width * 0.250,
        decoration: BoxDecoration(border: Border.all(color: AppColors.textFieldBorderColor, width: 1), borderRadius: BorderRadius.circular(10.r)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            pickedImage != null
                ? checkIsPdfOrNot(pickedImage!)
                    ? Icon(
                        Icons.picture_as_pdf_outlined,
                        size: 100.h,
                        color: AppColors.grey8A8A8A,
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(15.r),
                        child: Image.memory(
                          pickedImage ?? Uint8List(0),
                          height: height ?? context.height * 0.300,
                          width: width ?? context.width * 0.500,
                          fit: BoxFit.contain,
                        ),
                      )
                : CommonSVG(
                    strIcon: Assets.svgs.svgSelectImage.keyName,
                    height: context.height * 0.07,
                    width: context.width * 0.07,
                  ),
            SizedBox(height: context.width * 0.01),
            InkWell(
              onTap: pickedImage != null
                  ? () {
                      /// remove image
                      if (pickedImage != null) {
                        showConfirmationDialogWeb(
                          context: context,
                          title: LocaleKeys.keyAreYouSure.localized,
                          message: LocaleKeys.keyAreYouSureYouWantToRemoveThisImage.localized,
                          dialogWidth: context.width * 0.3,
                          onTap: onRemovedTap,
                        );
                      }
                    }
                  : onTap,
              child: CommonText(
                title: pickedImage != null ? LocaleKeys.keyRemove.localized : LocaleKeys.keyUploadImage.localized,
                textStyle: TextStyles.regular.copyWith(color: (pickedImage == null) ? AppColors.blue0083FC : AppColors.darkRed, fontSize: 16.sp),
              ),
            ),
          ],
        ).paddingSymmetric(horizontal: context.width * 0.020),
      ),
    );
  }
}
