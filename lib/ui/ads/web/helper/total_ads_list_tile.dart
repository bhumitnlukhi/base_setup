import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigo_vendor/framework/controller/ads/ads_details_controller.dart';
import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/framework/utils/extension/extension.dart';
import 'package:odigo_vendor/ui/ads/web/helper/image_dialog.dart';
import 'package:odigo_vendor/ui/ads/web/helper/video_images_combine_demo_one_controller.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';
import 'package:odigo_vendor/ui/utils/widgets/cache_image.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_dialogs.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_text.dart';

class TotalAdsListTile extends StatelessWidget {
  final int index;
  const TotalAdsListTile({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.height * 0.168,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          color: AppColors.clrF7F7FC
      ),
      child: Consumer(
          builder: (context, ref, child) {
            final adsDetailsWatch = ref.watch(adsDetailsController);

            final data = adsDetailsWatch.contentList[index];
            return Row(
            children: [
              Expanded(
                child: Row(
                  children: [

                    /// ads media
                    InkWell(
                      onTap: () {
                        if(data?.originalAdsFile?.split('.').last != 'jpg' &&
                            data?.originalAdsFile?.split('.').last != 'jpeg' && data?.originalAdsFile?.split('.').last != 'png') {
                          showCommonWebDialog(
                            context: context,
                            height: 0.5,
                            width: 0.5,
                            barrierDismissible: false,
                            keyBadge: adsDetailsWatch.totalAdsDialogKey,
                            dialogBody:
                            VideoImageCombineDemoWithSingleController(
                              videoUrl: data?.adsFileUrl ?? '',
                            ).paddingSymmetric(
                              // horizontal: context.width * 0.01,
                              // vertical: context.height * 0.01,
                            ),
                          );
                        }else{
                          showCommonWebDialog(
                            keyBadge: adsDetailsWatch.totalAdsDialogKey,
                            context: context,
                            height: 0.5,
                            width: 0.3,
                            barrierDismissible: true,
                            dialogBody:
                            ImageDialog(imageUrl: (data?.adsFileUrl ?? '')).paddingSymmetric(
                              // horizontal: context.width * 0.01,
                              // vertical: context.height * 0.01,
                            ),
                          );
                        }

                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CacheImage(
                            placeholderImage: data?.originalAdsFile?.split('.').last == 'jpg' || data?.originalAdsFile?.split('.').last == 'jpeg' || data?.originalAdsFile?.split('.').last == 'png'? Assets.svgs.svgImagePlaceholder.keyName : Assets.svgs.svgVideoPlaceholder.keyName,
                            imageURL: data?.originalAdsFile?.split('.').last == 'jpg' || data?.originalAdsFile?.split('.').last == 'jpeg' || data?.originalAdsFile?.split('.').last == 'png'?
                            (data?.adsFileUrl ?? '') :
                            (adsDetailsWatch.adContentState.success?.data?[index].thumbnailFile ?? ''),
                            height: 111.w,
                            width: 62.w,
                            topRightRadius: 20.r,
                            contentMode: BoxFit.cover,
                            bottomRightRadius: 20.r,
                            bottomLeftRadius: 20.r,
                            topLeftRadius: 20.r,
                          ),
                          (data?.originalAdsFile?.split('.').last == 'jpg' ||
                              data?.originalAdsFile?.split('.').last == 'jpeg' ||
                              data?.originalAdsFile?.split('.').last == 'png')? const Offstage():
                          Icon(Icons.play_arrow_rounded,size: 50.h,color: AppColors.white,)
                        ],
                      ),
                    ),

                    SizedBox(width: context.width * 0.018),

                    /// ads name, date, time
                    Column(
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CommonText(title: data?.originalAdsFile??'', textStyle: TextStyles.semiBold.copyWith(color: AppColors.black,fontSize: 16.sp),),

                        // CommonText(title: 'October 30, 2023-07:00 Pm', textStyle: TextStyles.regular.copyWith(color: AppColors.clrA5A5A5,fontSize: 12.sp),),
                        // CommonText(title: DateTime.fromMillisecondsSinceEpoch(data?.createdAt??0).dateOnly, textStyle: TextStyles.regular.copyWith(color: AppColors.clrA5A5A5,fontSize: 16.sp),),
                      ],
                    ).paddingSymmetric(vertical: context.height * 0.014),

                  ],
                ),
              ),

              /// reject reason, ads status
              // Expanded(
              //   child: Row(
              //     mainAxisSize: MainAxisSize.max,
              //     crossAxisAlignment: CrossAxisAlignment.end,
              //     mainAxisAlignment: MainAxisAlignment.end,
              //     children: [
              //
              //       data?.verificationDetails?.rejectReason!=null ? Column(
              //         mainAxisSize: MainAxisSize.min,
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //           CommonText(title: LocaleKeys.keyReason.localized, textStyle: TextStyles.semiBold.copyWith(color: AppColors.black,fontSize: 12.sp),),
              //
              //           SizedBox(height: context.height * 0.01),
              //
              //           CommonText(title: data?.verificationDetails?.rejectReason??'', textStyle: TextStyles.regular.copyWith(color: AppColors.black,fontSize: 12.sp),),
              //         ],
              //       ).paddingSymmetric(vertical: context.height * 0.014).alignAtCenter() : const SizedBox(),
              //
              //       SizedBox(width: context.width * 0.05,),
              //
              //       Container(
              //         height: context.height * 0.054,
              //         width: context.width * 0.08,
              //         decoration: BoxDecoration(
              //             borderRadius: BorderRadius.circular(25.r),
              //             color: data?.adsContentStatus == "PENDING" ? AppColors.clrFF5858 : AppColors.green35C658
              //         ),
              //         alignment: Alignment.center,
              //         child: CommonText(
              //           title: data?.adsContentStatus??'',clrfont: AppColors.white,
              //         ),
              //       ).alignAtCenter(),
              //
              //       SizedBox(width: context.width * 0.03,)
              //     ],
              //   ),
              // )
            ],
          ).paddingAll(context.height * 0.008);
        }
      ),
    );
  }
}
