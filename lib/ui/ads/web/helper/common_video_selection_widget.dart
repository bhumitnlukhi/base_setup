import 'dart:io';

import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/framework/utils/extension/string_extension.dart';
import 'package:odigo_vendor/ui/utils/theme/app_strings.g.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_svg.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_text.dart';

class CommonVideoSelectionWidget extends StatelessWidget {
  final File? thumbnailImage;
  final Function()? onTap;
  final Function()? onThumbnailImageTap;
  final Function()? onRemovedTap;
  final double? height;
  final double? width;
  const CommonVideoSelectionWidget({super.key, this.thumbnailImage, this.onTap, this.onRemovedTap, this.height, this.width, this.onThumbnailImageTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: context.height * 0.450,
      width: context.width * 0.200,
      decoration: BoxDecoration(border: Border.all(color: AppColors.textFieldBorderColor, width: 1), borderRadius: BorderRadius.circular(10.r)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          thumbnailImage != null ? InkWell(
            onTap: onThumbnailImageTap,
            child: SizedBox(
                height: context.height * 0.350,
                width: context.width * 0.150,
                child: SizedBox(
                  height: context.height * 0.13,
                  width: context.height * 0.13,
                  child: Stack(
                    children: [
                      Center(
                        child: Image.network(
                          thumbnailImage!.path,
                          fit: BoxFit.fill,
                        ),
                      ),
                      Center(child: Icon(Icons.play_circle_filled_outlined,color: AppColors.white,size: context.height * 0.05,))
                    ],
                  ),
                )),
          ):CommonSVG(
            strIcon: Assets.svgs.svgSelectImage.keyName,
            height: context.height * 0.07,
            width: context.width * 0.07,
          ),

          SizedBox(height: context.width * 0.01),

          InkWell(
            onTap: thumbnailImage == null ? onTap : onRemovedTap,
            child: CommonText(
              title: thumbnailImage == null ? LocaleKeys.keyUploadVideo.localized : LocaleKeys.keyRemove.localized,
              textStyle: TextStyles.regular.copyWith(color:thumbnailImage == null ? AppColors.blue0083FC :  AppColors.darkRed, fontSize: 16.sp),
            ),
          )

        ],
      ),
    );
  }
}
