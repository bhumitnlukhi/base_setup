
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigo_vendor/framework/controller/package/select_client_controller.dart';
import 'package:odigo_vendor/framework/controller/package/select_destination_controller.dart';
import 'package:odigo_vendor/framework/repository/package/model/destination_list_response_model.dart';
import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/framework/utils/extension/extension.dart';
import 'package:odigo_vendor/framework/utils/extension/string_extension.dart';
import 'package:odigo_vendor/ui/utils/helper/base_widget.dart';
import 'package:odigo_vendor/ui/utils/theme/app_strings.g.dart';

import 'package:odigo_vendor/ui/utils/theme/theme.dart';
import 'package:odigo_vendor/ui/utils/widgets/cache_image.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_text.dart';

class AllLocationClientTopWidget extends ConsumerWidget with BaseConsumerWidget {
  const AllLocationClientTopWidget({Key? key}) : super(key: key);

  @override
  Widget buildPage(BuildContext context,WidgetRef ref) {
    final selectDestinationWatch = ref.watch(selectDestinationController);
    final selectClientWatch = ref.watch(selectClientController);
    DestinationData? destinationData = selectDestinationWatch.selectedDestination;
    String address = '${destinationData?.houseNumber??''},'
        ' ${destinationData?.stateName??''}, ${destinationData?.addressLine1??''},'
        ' ${destinationData?.addressLine2??''}, ${destinationData?.landmark??''}, ${destinationData?.cityName??''},'
        ' ${destinationData?.stateName??''}-${destinationData?.postalCode??''}, ${destinationData?.countryName ?? ''}';
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                ClipOval(
                  child: CacheImage(
                    imageURL: selectDestinationWatch.selectedDestination?.imageUrl ?? '',
                    width: context.height*0.10,
                    height: context.height*0.10,
                    placeholderName: selectDestinationWatch.selectedDestination?.name ?? '',
                    // bo: BoxFit.cover,/
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
            ).paddingOnly(right: context.width*0.03),
            Expanded(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Client name
                      CommonText(
                        title:  LocaleKeys.keyClientName.localized,
                        textStyle: TextStyles.regular.copyWith(
                          color: AppColors.grey8F8F8F,
                          fontSize: 16.sp,
                        ),
                        maxLines: 3,
                      ).paddingOnly(bottom: context.height*0.007),
                      CommonText(
                        title: selectClientWatch.selectedClient?.name ?? '',
                        textStyle: TextStyles.regular.copyWith(
                          color: AppColors.black171717,
                          fontSize: 16.sp,
                        ),
                        maxLines: 3,
                      ).paddingOnly(bottom: context.height*0.02),
                  
                      /// Destination name
                      CommonText(
                        title:  LocaleKeys.keyDestinationName.localized,
                        textStyle: TextStyles.regular.copyWith(
                          color: AppColors.grey8F8F8F,
                          fontSize: 16.sp,
                        ),
                        maxLines: 3,
                      ).paddingOnly(bottom: context.height*0.007),
                      CommonText(
                        title: selectDestinationWatch.selectedDestination?.name??'',
                        textStyle: TextStyles.regular.copyWith(
                          color: AppColors.black171717,
                          fontSize: 16.sp,
                        ),
                        maxLines: 3,
                      )
                    ],
                  ).paddingOnly(right: context.width*0.03),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Email
                      CommonText(
                        title:  LocaleKeys.keyEmaiID.localized,
                        textStyle: TextStyles.regular.copyWith(
                          color: AppColors.grey8F8F8F,
                          fontSize: 16.sp,
                        ),
                        maxLines: 3,
                      ).paddingOnly(bottom: context.height*0.007),
                      CommonText(
                        title: selectDestinationWatch.selectedDestination?.email ?? '',
                        textStyle: TextStyles.regular.copyWith(
                          color: AppColors.black171717,
                          fontSize: 16.sp,
                        ),
                        maxLines: 3,
                      ).paddingOnly(bottom: context.height*0.02),
                  
                      /// Destination address
                      CommonText(
                        title:  LocaleKeys.keyDestinationAddress.localized,
                        textStyle: TextStyles.regular.copyWith(
                          color: AppColors.grey8F8F8F,
                          fontSize: 16.sp,
                        ),
                        maxLines: 3,
                      ).paddingOnly(bottom: context.height*0.007),
                      CommonText(
                        title: address,
                  
                        textStyle: TextStyles.regular.copyWith(
                          color: AppColors.black171717,
                          fontSize: 16.sp,
                        ),
                        maxLines: 3,
                      )
                    ],
                  ).paddingOnly(right: context.width*0.03),
                ),
                /// Contact
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonText(
                        title:  LocaleKeys.keyContact.localized,
                        textStyle: TextStyles.regular.copyWith(
                          color: AppColors.grey8F8F8F,
                          fontSize: 16.sp,
                        ),
                        maxLines: 3,
                      ).paddingOnly(bottom: context.height*0.007),
                      CommonText(
                        title: selectDestinationWatch.selectedDestination?.contactNumber ?? '',
                        textStyle: TextStyles.regular.copyWith(
                          color: AppColors.black171717,
                          fontSize: 16.sp,
                        ),
                        maxLines: 3,
                      )
                    ],
                  ),
                )
              ],
            ))

          ],
        ),
        Divider(
          color: AppColors.clr707070.withOpacity(0.4),
        ).paddingSymmetric(vertical: 15.h),
      ],
    );
  }
}