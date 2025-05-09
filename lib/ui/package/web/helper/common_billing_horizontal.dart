import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigo_vendor/framework/controller/package/all_locations_controller.dart';
import 'package:odigo_vendor/framework/controller/package/package_controller.dart';
import 'package:odigo_vendor/framework/controller/package/select_destination_controller.dart';
import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/framework/utils/extension/extension.dart';
import 'package:odigo_vendor/framework/utils/extension/string_extension.dart';
import 'package:odigo_vendor/framework/utils/session.dart';
import 'package:odigo_vendor/ui/utils/helper/base_widget.dart';
import 'package:odigo_vendor/ui/utils/theme/app_strings.g.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_button.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_text.dart';

class CommonBillingHorizontal extends ConsumerWidget with BaseConsumerWidget{
  final Function()? onPayButtonTap;
  const CommonBillingHorizontal({Key? key, this.onPayButtonTap}) : super(key: key);

  @override
  Widget buildPage(BuildContext context,WidgetRef ref) {
    final selectDestinationWatch = ref.watch(selectDestinationController);
    final allLocationsWatch = ref.read(allLocationsController);
    final packageWatch = ref.watch(packageController);

    String address = '${selectDestinationWatch.selectedDestination?.houseNumber??''},'
        ' ${selectDestinationWatch.selectedDestination?.stateName??''}, ${selectDestinationWatch.selectedDestination?.addressLine1??''},'
        ' ${selectDestinationWatch.selectedDestination?.addressLine2??''}, ${selectDestinationWatch.selectedDestination?.landmark??''}, ${selectDestinationWatch.selectedDestination?.cityName??''},'
        ' ${selectDestinationWatch.selectedDestination?.stateName??''}-${selectDestinationWatch.selectedDestination?.postalCode??''}, ${selectDestinationWatch.selectedDestination?.countryName??''}';

    return Container(
      width: context.width *0.4,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        color: AppColors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ///Name and email id
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Agency Name
                    CommonText(
                      title:LocaleKeys.keyAgencyName.localized,
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

                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Email Id
                    CommonText(
                      title: LocaleKeys.keyAgencyEmailId.localized,
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
                      maxLines: 5,
                    ).paddingOnly(bottom: context.height*0.031)

                  ],
                ),
              ),
              const Spacer()
            ],
          ),

          ///Agency contact number and Destination name
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                flex:3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Contact Number name
                    CommonText(
                      title:  LocaleKeys.keyAgencyContactNumber.localized,
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
                      maxLines: 3,
                    ).paddingOnly(bottom: context.height*0.031)
                  ],
                ),
              ),
              Expanded(
                flex:3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    /// Destination name
                    CommonText(
                      title: LocaleKeys.keyDestinationName.localized,
                      textStyle: TextStyles.regular.copyWith(
                        color: AppColors.grey8F8F8F,
                        fontSize: 16.sp,
                      ),
                      maxLines: 3,
                    ).paddingOnly(bottom: context.height*0.007),
                    CommonText(
                      title: selectDestinationWatch.selectedDestination?.name??'-',
                      textStyle: TextStyles.regular.copyWith(
                        color: AppColors.black171717,
                        fontSize: 16.sp,
                      ),
                      maxLines: 5,
                    ).paddingOnly(bottom: context.height*0.031)
                  ],
                ),
              ),
              const Spacer(),

            ],
          ),

          ///Destination Address and Date period
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                flex:3,
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
              Expanded(
                flex:3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Date period
                    CommonText(
                      title: LocaleKeys.keyDatePeriod.localized,
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
                    ).paddingOnly(bottom: context.height*0.031)
                  ],
                ),
              ),
              const Spacer()
            ],
          ),

          ///Budget
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                flex:3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    /// Budget
                    CommonText(
                      title: LocaleKeys.keyBudget.localized,
                      textStyle: TextStyles.regular.copyWith(
                        color: AppColors.grey8F8F8F,
                        fontSize: 16.sp,
                      ),
                    ).paddingOnly(bottom: context.height*0.007),
                    CommonText(
                      title: '${Session.getCurrency()} ${allLocationsWatch.priceCtr.text.toString()}',
                      textStyle: TextStyles.regular.copyWith(
                        color: AppColors.black,
                        fontSize: 16.sp,
                      ),
                    ).paddingOnly(bottom: context.height*0.031)
                  ],
                ),
              ),
              const Spacer()
            ],
          ),

          const Spacer(),

          /// Pay now button
          CommonButton(
            height: 45.h,
            width: 130.w,
            buttonTextStyle: TextStyles.regular.copyWith(
              color: AppColors.white,
              fontSize: 16.sp,
            ),
            buttonText: LocaleKeys.keyPayNow.localized,
            isButtonEnabled: true,
            onTap: onPayButtonTap,
            isLoading: packageWatch.purchasePackageState.isLoading,
          ),
        ],
      ).paddingSymmetric(horizontal: context.width*0.023,vertical: context.height*0.03),
    );
  }
}
