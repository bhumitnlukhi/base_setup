import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigo_vendor/framework/controller/ads/ads_details_controller.dart';
import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/framework/utils/extension/datetime_extension.dart';
import 'package:odigo_vendor/framework/utils/extension/extension.dart';
import 'package:odigo_vendor/framework/utils/extension/string_extension.dart';
import 'package:odigo_vendor/ui/ads/web/helper/common_header_title_widget.dart';
import 'package:odigo_vendor/ui/ads/web/helper/total_ads_widget.dart';
import 'package:odigo_vendor/ui/utils/const/app_constants.dart';
import 'package:odigo_vendor/ui/utils/const/app_enums.dart';
import 'package:odigo_vendor/ui/utils/theme/app_strings.g.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_text.dart';
import 'package:odigo_vendor/ui/utils/widgets/shimmer/common_shimmer.dart';

class AdsDetailsWidget extends StatelessWidget {
  const AdsDetailsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final adsDetailsWatch = ref.watch(adsDetailsController);

      final data = adsDetailsWatch.adDetailState.success?.data;
      var (bgColor, textColor) = getAllStatusColor(data?.status);
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          adsDetailsWatch.adDetailState.isLoading
              ? destinationDetailShimmer(context)
              : Column(
                  children: [
                    /// ads details
                    Row(
                      children: [
                        /// ADS ID
                        Expanded(flex: 3, child: CommonHeaderTitleWidget(header: LocaleKeys.keyAdsId.localized, value: data?.uuid ?? '')),

                        ///agency/store name
                        // Expanded(flex: 2, child: CommonHeaderTitleWidget(header: Session.getUserType() == UserType.AGENCY.name  ? LocaleKeys.keyClientName.localized : LocaleKeys.keyStoreAgencyName.localized, value: data?.adsByName ?? '')),
                        Expanded(flex: 2, child: CommonHeaderTitleWidget(header: data?.adsByType ==  UserType.AGENCY.name ? LocaleKeys.keyAgencyName.localized : (data?.adsByType == UserType.STORE.name ? LocaleKeys.keyStoreName.localized : LocaleKeys.keyClientName.localized) , value: data?.adsByName ?? '')),

                        ///destination name
                        Expanded(flex: 2, child: CommonHeaderTitleWidget(header: LocaleKeys.keyDestinationName.localized, value: data?.destination?.name ?? '')),

                        /// type
                        Expanded(flex: 1, child: CommonHeaderTitleWidget(header: LocaleKeys.keyType.localized, value: data?.adsByType ?? '')),

                        /// date
                        Expanded(flex: 2, child: CommonHeaderTitleWidget(header: LocaleKeys.keyDate.localized, value: DateTime.fromMillisecondsSinceEpoch(data?.createdAt ?? 0).dateOnly)),

                        Expanded(flex: 3, child: Container())
                      ],
                    ),

                    SizedBox(
                      height: context.height * 0.030,
                    ),

                    ///address
                    Row(
                      children: [
                        Expanded(child: CommonHeaderTitleWidget(header: LocaleKeys.keyAddress.localized, value: "${getAddressString(data?.destination?.houseNumber ?? '')}${getAddressString(data?.destination?.streetName ?? '')}\n${getAddressString(data?.destination?.addressLine1 ?? '')}${getAddressString(data?.destination?.addressLine2 ?? '')}${getAddressString(data?.destination?.landmark ?? '')}${getAddressString(data?.destination?.cityName ?? '')}${getAddressString(data?.destination?.stateName ?? '', isState: true)}- ${getAddressString(data?.destination?.postalCode ?? '')}\n${getAddressString(data?.destination?.countryName ?? '', isState: true)}")),
                        Expanded(child: Container()),
                        Container(
                          height: 50.h,
                          width: 150.w,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(25.r), color: bgColor),
                          child: Center(
                            child: CommonText(
                              title: (data?.status == 'PENDING'
                                  ? LocaleKeys.keyPending.localized.toUpperCase()
                                  : (data?.rejectReason != null
                                      ? LocaleKeys.keyRejected.localized
                                      : data?.status == 'ACTIVE'
                                          ? LocaleKeys.keyActive.localized.toUpperCase()
                                          : data?.status ?? '')),
                              textAlign: TextAlign.center,
                              textStyle: TextStyles.regular.copyWith(
                                fontSize: 12.sp,
                                color: textColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(
                      height: context.height * 0.030,
                    ),

                    Divider(
                      height: context.height * 0.010,
                      color: AppColors.grey4B465C14,
                    ),

                    SizedBox(
                      height: context.height * 0.030,
                    ),
                  ],
                ),
          const Expanded(child: TotalAdsWidget())
        ],
      );
    });
  }

  Widget destinationDetailShimmer(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(child: CommonShimmer(height: context.height * 0.15, width: context.height * 0.15, borderRadius: BorderRadius.circular(context.height * 0.09))).paddingOnly(right: context.width * 0.020),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CommonShimmer(
                  height: context.height * 0.08,
                  width: context.width * 0.15,
                  borderRadius: BorderRadius.circular(context.height * 0.12),
                ).paddingOnly(right: context.width * 0.020),
                CommonShimmer(height: context.height * 0.08, width: context.width * 0.15, borderRadius: BorderRadius.circular(context.height * 0.12)).paddingOnly(right: context.width * 0.020),
                CommonShimmer(height: context.height * 0.08, width: context.width * 0.15, borderRadius: BorderRadius.circular(context.height * 0.12)),
              ],
            ).paddingOnly(bottom: context.height * 0.020),
            CommonShimmer(height: context.height * 0.10, width: context.width * 0.50, borderRadius: BorderRadius.circular(context.height * 0.12)),
          ],
        )
      ],
    );
  }

  String getAddressString(String? val, {bool isState = false}) {
    if (isState) {
      if (val != null && val != '' && val != 'null') {
        return '$val ';
      }
    } else if (val != null && val != '' && val != 'null') {
      return '$val, ';
    }
    return '';
  }
}
