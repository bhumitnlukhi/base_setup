import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigo_vendor/framework/controller/package/all_locations_controller.dart';
import 'package:odigo_vendor/framework/controller/package/package_controller.dart';
import 'package:odigo_vendor/framework/controller/package/select_client_controller.dart';
import 'package:odigo_vendor/framework/controller/package/select_destination_controller.dart';
import 'package:odigo_vendor/framework/controller/package/select_store_controller.dart';
import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/framework/utils/extension/extension.dart';
import 'package:odigo_vendor/framework/utils/extension/string_extension.dart';
import 'package:odigo_vendor/framework/utils/session.dart';
import 'package:odigo_vendor/ui/utils/const/app_enums.dart';
import 'package:odigo_vendor/ui/utils/helper/base_widget.dart';
import 'package:odigo_vendor/ui/utils/theme/app_strings.g.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_button.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_text.dart';

class CommonBillingVertical extends ConsumerWidget with BaseConsumerWidget {
  final Function()? onPayButtonTap;
  final bool? isForOwn;
  final int estimatedAdCount;
  const CommonBillingVertical({Key? key, this.onPayButtonTap,this.isForOwn, required this.estimatedAdCount}) : super(key: key);

  @override
  Widget buildPage(BuildContext context,WidgetRef ref) {
    final selectDestinationWatch = ref.watch(selectDestinationController);
    final allLocationsWatch = ref.read(allLocationsController);
    final selectStoreWatch = ref.read(selectStoreController);
    final selectClientWatch = ref.read(selectClientController);
    final packageWatch = ref.watch(packageController);

    String address = '${selectDestinationWatch.selectedDestination?.houseNumber??''},'
        ' ${selectDestinationWatch.selectedDestination?.stateName??''}, ${selectDestinationWatch.selectedDestination?.addressLine1??''},'
        ' ${selectDestinationWatch.selectedDestination?.addressLine2??''}, ${selectDestinationWatch.selectedDestination?.landmark??''}, ${selectDestinationWatch.selectedDestination?.cityName??''},'
        ' ${selectDestinationWatch.selectedDestination?.stateName??''} ${selectDestinationWatch.selectedDestination?.postalCode??''}, ${selectDestinationWatch.selectedDestination?.countryName ?? ''}';
    
    return Container(
      width: context.width *0.4,
      // height: context.height*0.75,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        color: AppColors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ///Store Name/Client Name & Destination
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    /// Client name
                    CommonText(
                      title: Session.getUserType() == userTypeValue.reverse[UserType.VENDOR] ?LocaleKeys.keyStoreName.localized:LocaleKeys.keyClientName.localized,
                      textStyle: TextStyles.regular.copyWith(
                        color: AppColors.grey8F8F8F,
                        fontSize: 16.sp,
                      ),
                      maxLines: 3,
                    ).paddingOnly(bottom: context.height*0.007),

                    /// Client name value
                    CommonText(
                      title: Session.getUserType() == userTypeValue.reverse[UserType.VENDOR] ? selectStoreWatch.selectedStore?.odigoStoreName ?? '' : selectClientWatch.selectedClient?.name ?? '',
                      textStyle: TextStyles.regular.copyWith(
                        color: AppColors.black171717,
                        fontSize: 16.sp,
                      ),
                      maxLines: 3,
                    ).paddingOnly(bottom: context.height*0.031),

                    /// Email Id
                    CommonText(
                      title: Session.getUserType() == userTypeValue.reverse[UserType.VENDOR] ?LocaleKeys.keyVendorEmailId.localized:LocaleKeys.keyAgencyEmailId.localized,
                      textStyle: TextStyles.regular.copyWith(
                        color: AppColors.grey8F8F8F,
                        fontSize: 16.sp,
                      ),
                      maxLines: 3,
                    ).paddingOnly(bottom: context.height*0.007),
                    CommonText(
                      title: Session.getEmailId(),
                      textStyle: TextStyles.regular.copyWith(
                        color: AppColors.black171717,
                        fontSize: 16.sp,
                      ),
                      maxLines: 3,
                    ).paddingOnly(bottom: context.height*0.031),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Vendor/Agency Name
                    CommonText(
                      title: Session.getUserType() == userTypeValue.reverse[UserType.VENDOR] ?LocaleKeys.keyVendorName.localized:LocaleKeys.keyAgencyName.localized,
                      textStyle: TextStyles.regular.copyWith(
                        color: AppColors.grey8F8F8F,
                        fontSize: 16.sp,
                      ),
                      maxLines: 3,
                    ).paddingOnly(bottom: context.height*0.007),
                    CommonText(
                      title: Session.getName(),
                      textStyle: TextStyles.regular.copyWith(
                        color: AppColors.black171717,
                        fontSize: 16.sp,
                      ),
                      maxLines: 3,
                    ).paddingOnly(bottom: context.height*0.031),

                    /// Vendor/Agency Contact Number
                    CommonText(
                      title: Session.getUserType() == userTypeValue.reverse[UserType.VENDOR] ?LocaleKeys.keyVendorContactNumber.localized:LocaleKeys.keyAgencyContactNumber.localized,
                      textStyle: TextStyles.regular.copyWith(
                        color: AppColors.grey8F8F8F,
                        fontSize: 16.sp,
                      ),
                      maxLines: 3,
                    ).paddingOnly(bottom: context.height*0.007),
                    CommonText(
                      title: Session.getContactNumber(),
                      textStyle: TextStyles.regular.copyWith(
                        color: AppColors.black171717,
                        fontSize: 16.sp,
                      ),
                      maxLines: 5,
                    )
                  ],
                ),
              ),
              const Spacer()
            ],
          ),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Destination Name
                    CommonText(
                      title:LocaleKeys.keyDestinationName.localized,
                      textStyle: TextStyles.regular.copyWith(
                        color: AppColors.grey8F8F8F,
                        fontSize: 16.sp,
                      ),
                      maxLines: 3,
                    ).paddingOnly(bottom: context.height*0.007),
                    CommonText(
                      title: selectDestinationWatch.selectedDestination?.name ?? '',
                      textStyle: TextStyles.regular.copyWith(
                        color: AppColors.black171717,
                        fontSize: 16.sp,
                      ),
                      maxLines: 3,
                    ).paddingOnly(bottom: context.height*0.031),

                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Destination address
                    CommonText(
                      title: LocaleKeys.keyDestinationAddress.localized,
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
                      maxLines: 5,
                    ).paddingOnly(bottom: context.height*0.031)

                  ],
                ),
              ),
              const Spacer()
            ],
          ),

          ///Date Period and Budget
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonText(
                      title:  LocaleKeys.keyDatePeriod.localized,
                      textStyle: TextStyles.regular.copyWith(
                        color: AppColors.grey8F8F8F,
                        fontSize: 16.sp,
                      ),
                      maxLines: 3,
                    ).paddingOnly(bottom: context.height*0.007),
                    CommonText(
                      title: '${allLocationsWatch.startDateCtr.text} To ${allLocationsWatch.endDateCtr.text}',
                      textStyle: TextStyles.regular.copyWith(
                        color: AppColors.black171717,
                        fontSize: 16.sp,
                      ),
                      maxLines: 3,
                    ).paddingOnly(bottom: context.height*0.031),

                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Budget
                    CommonText(
                      title:  LocaleKeys.keyBudget.localized,
                      textStyle: TextStyles.regular.copyWith(
                        color: AppColors.grey8F8F8F,
                        fontSize: 16.sp,
                      ),
                      maxLines: 3,
                    ).paddingOnly(bottom: context.height*0.007),
                    CommonText(
                      title: '${Session.getCurrency()} ${allLocationsWatch.priceCtr.text.toString()}',
                      textStyle: TextStyles.regular.copyWith(
                        color: AppColors.black171717,
                        fontSize: 16.sp,
                      ),
                      maxLines: 3,
                    ).paddingOnly(bottom: context.height*0.031),

                  ],
                ),
              ),
              const Spacer()
            ],
          ),

          const Spacer(),

          CommonButton(
            height: 49.h,
            width: 130.w,
            buttonTextStyle: TextStyles.regular.copyWith(
              color: AppColors.white,
              fontSize: 16.sp,
            ),
            isLoading: packageWatch.purchasePackageState.isLoading,
            buttonText: LocaleKeys.keyPayNow.localized,
            isButtonEnabled: true,
            onTap: onPayButtonTap,
          ),

        ],
      ).paddingAll(context.height*0.035),
    );
  }
}
