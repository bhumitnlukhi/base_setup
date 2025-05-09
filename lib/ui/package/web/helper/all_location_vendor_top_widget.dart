import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigo_vendor/framework/controller/package/select_destination_controller.dart';
import 'package:odigo_vendor/framework/controller/package/select_store_controller.dart';
import 'package:odigo_vendor/framework/repository/package/model/destination_list_response_model.dart';
import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/framework/utils/extension/extension.dart';
import 'package:odigo_vendor/framework/utils/extension/string_extension.dart';
import 'package:odigo_vendor/ui/utils/helper/base_widget.dart';
import 'package:odigo_vendor/ui/utils/theme/app_strings.g.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';
import 'package:odigo_vendor/ui/utils/widgets/cache_image.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_text.dart';

class AllLocationVendorTopWidget extends ConsumerWidget with BaseConsumerWidget {
  const AllLocationVendorTopWidget({Key? key}) : super(key: key);

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) {
    final selectDestinationWatch = ref.watch(selectDestinationController);
    final selectStoreWatch = ref.watch(selectStoreController);
    DestinationData? destinationData = selectDestinationWatch.selectedDestination;
    String address = '${addressDetails(destinationData?.houseNumber ?? '', isInitial: true)}'
        '${addressDetails(destinationData?.streetName ?? '')}${addressDetails(destinationData?.addressLine1 ?? '')}'
        '${addressDetails(destinationData?.addressLine2 ?? '')}${addressDetails(destinationData?.landmark ?? '')}${addressDetails(destinationData?.cityName ?? '')}'
        '${addressDetails(destinationData?.stateName ?? '')}${addressDetails(destinationData?.postalCode ?? '', isPinCode: true)}${addressDetails(destinationData?.countryName ?? '')}';
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
                    placeholderName: selectDestinationWatch.selectedDestination?.name?[0] ?? '',
                    imageURL: selectDestinationWatch.selectedDestination?.imageUrl ?? '',
                    width: context.height * 0.12,
                    height: context.height * 0.12,
                    // bo: BoxFit.cover,/
                  ),
                ),
                // Positioned(
                //   top: context.height*0.002,
                //   right: context.width*0.001,
                //   child: Container(
                //     decoration: const BoxDecoration(
                //       shape: BoxShape.circle,
                //       color: AppColors.green35C658,
                //     ),
                //     width: context.width*0.02,
                //     height: context.height*0.02,
                //   ),
                // )
              ],
            ).paddingOnly(right: context.width * 0.03),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// store name
                        CommonText(
                          title: LocaleKeys.keyStoreName.localized,
                          textStyle: TextStyles.regular.copyWith(
                            color: AppColors.grey8F8F8F,
                            fontSize: 16.sp,
                          ),
                          maxLines: 3,
                        ).paddingOnly(bottom: context.height * 0.007),
                        CommonText(
                          title: selectStoreWatch.selectedStore?.odigoStoreName ?? '',
                          textStyle: TextStyles.regular.copyWith(
                            color: AppColors.black171717,
                            fontSize: 16.sp,
                          ),
                          maxLines: 3,
                        ).paddingOnly(bottom: context.height * 0.02),

                        /// Destination name
                        CommonText(
                          title: LocaleKeys.keyDestinationName.localized,
                          textStyle: TextStyles.regular.copyWith(
                            color: AppColors.grey8F8F8F,
                            fontSize: 16.sp,
                          ),
                          maxLines: 3,
                        ).paddingOnly(bottom: context.height * 0.007),
                        CommonText(
                          title: selectDestinationWatch.selectedDestination?.name ?? '',
                          textStyle: TextStyles.regular.copyWith(
                            color: AppColors.black171717,
                            fontSize: 16.sp,
                          ),
                          maxLines: 3,
                        )
                      ],
                    ).paddingOnly(right: context.width * 0.03),
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// email
                        CommonText(
                          title: LocaleKeys.keyEmaiID.localized,
                          textStyle: TextStyles.regular.copyWith(
                            color: AppColors.grey8F8F8F,
                            fontSize: 16.sp,
                          ),
                          maxLines: 3,
                        ).paddingOnly(bottom: context.height * 0.007),
                        CommonText(
                          title: selectDestinationWatch.selectedDestination?.email ?? '',
                          textStyle: TextStyles.regular.copyWith(
                            color: AppColors.black171717,
                            fontSize: 16.sp,
                          ),
                          maxLines: 3,
                        ).paddingOnly(bottom: context.height * 0.02),

                        /// Destination address
                        CommonText(
                          title: LocaleKeys.keyDestinationAddress.localized,
                          textStyle: TextStyles.regular.copyWith(
                            color: AppColors.grey8F8F8F,
                            fontSize: 16.sp,
                          ),
                          maxLines: 3,
                        ).paddingOnly(bottom: context.height * 0.007),
                        CommonText(
                          title: address,
                          textStyle: TextStyles.regular.copyWith(
                            color: AppColors.black171717,
                            fontSize: 16.sp,
                          ),
                          maxLines: 3,
                        )
                      ],
                    ).paddingOnly(right: context.width * 0.03),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Contact
                        CommonText(
                          title: LocaleKeys.keyContact.localized,
                          textStyle: TextStyles.regular.copyWith(
                            color: AppColors.grey8F8F8F,
                            fontSize: 16.sp,
                          ),
                          maxLines: 3,
                        ).paddingOnly(bottom: context.height * 0.007),
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
              ),
            )
          ],
        ),
        Divider(
          color: AppColors.clr707070.withOpacity(0.4),
        ).paddingSymmetric(vertical: context.height * 0.015),
      ],
    );
  }

  String addressDetails(String value, {bool isInitial = false, bool isPinCode = false}) {
    String val = value;
    if (val != 'null' && val != '') {
      return isInitial
          ? val
          : isPinCode
              ? '-$val'
              : ',$val';
    }
    return val;
  }
}
