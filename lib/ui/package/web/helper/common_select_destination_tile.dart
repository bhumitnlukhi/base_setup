import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigo_vendor/framework/controller/package/select_destination_controller.dart';
import 'package:odigo_vendor/framework/repository/package/model/destination_list_response_model.dart';
import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/framework/utils/extension/extension.dart';
import 'package:odigo_vendor/ui/package/web/helper/destination_details_dialog_body.dart';
import 'package:odigo_vendor/ui/utils/helper/base_widget.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';
import 'package:odigo_vendor/ui/utils/widgets/cache_image.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_dialogs.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_svg.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_text.dart';

class CommonPurchaseAdsTile extends ConsumerWidget with BaseConsumerWidget {
  final bool? isIconRequired;
  final DestinationData? destinationData;
  const CommonPurchaseAdsTile({Key? key,this.isIconRequired, this.destinationData}) : super(key: key);

  @override
  Widget buildPage(BuildContext context,WidgetRef ref) {

    return Consumer(
      builder: (context, ref, child) {
        final destinationWatch = ref.watch(selectDestinationController);

        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18.sp),
            border: Border.all(
              color: AppColors.clr707070.withOpacity(0.3),
            )
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              isIconRequired??false?InkWell(
                  onTap: () async {
                    showCommonWebDialog(
                      keyBadge: destinationWatch.destinationDialogKey,
                        // height: context.height * 0.66,
                        width: 0.7,
                        context: context,
                        dialogBody: DestinationDetailsDialogBody(data: destinationData));
                  },
                  child: CommonSVG(strIcon: Assets.svgs.svgPackageInfo.keyName,height: context.height*0.040,width: context.width*0.040,).alignAtCenterRight()):const Offstage(),
              /// Iamge
              Stack(
                alignment: Alignment.center,
                children: [
                  ClipOval(
                    child: CacheImage(imageURL: destinationData?.imageUrl ?? '',
                      width: context.height*0.1,
                      height: context.height*0.1,
                      shape: BoxShape.circle,
                      placeholderName: destinationData?.name?[0]??'',
                    ),
                  ),
                  // Positioned(
                  //   top: 2.h,
                  //   right: 4.w,
                  //   child: Container(
                  //     decoration: const BoxDecoration(
                  //       shape: BoxShape.circle,
                  //       color: AppColors.green35C658,
                  //     ),
                  //     height: 20.h,
                  //     width: 20.h,
                  //   ),
                  // )
                ],
              ),

              CommonText(
                title: destinationData?.name ?? '',
                maxLines: 2,
                textOverflow: TextOverflow.ellipsis,
                textStyle: TextStyles.semiBold.copyWith(
                  fontSize: 17.sp,
                ),
                textAlign: TextAlign.center,
              ).paddingOnly(bottom: context.height*0.02,top: context.height*0.02 ),
              CommonText(
                title: destinationData?.cityName ?? '',
                textOverflow: TextOverflow.ellipsis,
                maxLines: 3,
                textStyle: TextStyles.regular.copyWith(
                  fontSize: 14.sp,
                ),
              )
            ],
          ).paddingAll(context.height*0.01),
        );
      }
    );
  }
}
