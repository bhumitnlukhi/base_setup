import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigo_vendor/framework/controller/stores/stores_controller.dart';
import 'package:odigo_vendor/framework/repository/store/model/store_details_response_model.dart';
import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/framework/utils/extension/extension.dart';
import 'package:odigo_vendor/framework/utils/extension/string_extension.dart';
import 'package:odigo_vendor/ui/routing/navigation_stack_item.dart';
import 'package:odigo_vendor/ui/routing/stack.dart';
import 'package:odigo_vendor/ui/utils/helper/base_widget.dart';
import 'package:odigo_vendor/ui/utils/theme/app_strings.g.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_svg.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_text.dart';

class StoreDetailsDialogWidget extends ConsumerWidget with BaseConsumerWidget {
  const StoreDetailsDialogWidget({super.key});

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) {
    final storeWatch = ref.watch(storesController);
    OdigoStoreData? storeData = storeWatch.storeDetailsState.success?.data;
    return storeData == null
        ? const Offstage()
        : SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: CommonText(
                        title: LocaleKeys.keyStoreDetail.localized,
                        fontSize: 20.sp,
                        clrfont: AppColors.black,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        ref.read(navigationStackController).pushRemove(const NavigationStackItem.stores());
                        Navigator.pop(context);
                      },
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: CommonSVG(strIcon: Assets.svgs.svgClose.keyName),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: context.height * 0.020,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _widgetHeaderValue(context: context, header: LocaleKeys.keyStoreName.localized, value: storeData.odigoStoreName ?? ''),
                    SizedBox(width:  context.width * 0.010),
                    // Flexible(
                    //   flex: 4,
                    //   child: _widgetHeaderValue(context: context, header: LocaleKeys.keyCategory.localized, value: storeData.businessCategoryLanguageResponseDtOs?.map((e) => e.name).join(', ')??''),
                    // ).paddingOnly(right: context.width * 0.010),
                    Flexible(
                      flex: 6,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommonText(
                            title: LocaleKeys.keyCategory.localized,
                            textStyle: TextStyles.regular.copyWith(color:  AppColors.grey8F8F8F, fontSize: 16.sp),
                          ),
                          SizedBox(
                            height: context.height * 0.015,
                          ),
                          CommonText(
                            title: storeData.businessCategoryLanguageResponseDtOs?.map((e) => e.name).join(', ')??'',
                            maxLines: 3,
                            textOverflow: TextOverflow.ellipsis,
                            textStyle: TextStyles.regular.copyWith(color: AppColors.black171717, fontSize: 18.sp),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommonText(
                          title: LocaleKeys.keyStatus.localized,
                          textStyle: TextStyles.regular.copyWith(color: AppColors.grey8F8F8F, fontSize: 16.sp),
                        ),
                        SizedBox(height: context.height * 0.010),
                        Builder(
                          builder: (context) {
                            var (bgColor, textColor) = storeWatch.getStatusColor(storeData.verificationResultResponseDto?.status == 'ACCEPTED' ? (storeData.active == true ? 'ACTIVE':'INACTIVE') :storeData.verificationResultResponseDto?.status ?? 'PENDING');
                            return Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(45.r),
                                color: bgColor,
                              ),
                              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
                              child: CommonText(
                                title: storeData.verificationResultResponseDto?.status == 'ACCEPTED' ? (storeData.active == true ? 'ACTIVE':'INACTIVE') :storeData.verificationResultResponseDto?.status ?? 'PENDING' ,
                                textStyle: TextStyles.regular.copyWith(fontSize: 12.sp, color: textColor),
                              ),
                            );
                          },
                        ),
                      ],
                    ).paddingSymmetric(horizontal: 10.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommonText(
                          title: LocaleKeys.keyStoreUuid.localized,
                          textStyle: TextStyles.regular.copyWith(color: AppColors.grey8F8F8F, fontSize: 16.sp),
                        ),
                        SizedBox(height: context.height * 0.010),
                        CommonText(
                          maxLines: 2,
                          title: storeData.uuid ?? '-',
                          textStyle: TextStyles.regular.copyWith(fontSize: 18.sp),
                        ),
                      ],
                    ),
                    const Expanded(
                      flex: 6,
                      child: Offstage(),
                    ),
                  ],
                ),
                SizedBox(
                  height: context.height * 0.05,
                ),
                _widgetHeaderValue(
                  context: context,
                  header: LocaleKeys.keyAddress.localized,
                  value:
                      '${storeData.destination?.houseNumber}, ${storeData.destination?.streetName}, ${storeData.destination?.addressLine1}, ${storeData.destination?.addressLine2}, ${storeData.destination?.landmark}, ${storeData.destination?.cityName}, ${storeData.destination?.stateName}, ${storeData.destination?.postalCode}, ${storeData.destination?.countryName}',
                  maxLines: 3,
                ),
                if (storeData.verificationResultResponseDto?.status == 'REJECTED')
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: context.height * 0.02),
                      Divider(color: AppColors.clr707070.withOpacity(0.1)),
                      SizedBox(height: context.height * 0.02),
                      _widgetHeaderValue(
                        context: context,
                        headerColor: AppColors.clrEB1F1F,
                        header: LocaleKeys.keyReasonForRejection.localized,
                        value: storeData.verificationResultResponseDto?.rejectReason,
                        maxLines: 3,
                      ),
                    ],
                  )
              ],
            ).paddingAll(context.height * 0.040),
        );
  }

  _widgetHeaderValue({required BuildContext context, required String header, Color? headerColor, required String value, int? maxLines}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonText(
          title: header,
          textStyle: TextStyles.regular.copyWith(color: headerColor ?? AppColors.grey8F8F8F, fontSize: 16.sp),
        ),
        SizedBox(
          height: context.height * 0.015,
        ),
        CommonText(
          title: value,
          maxLines: 3,
          textOverflow: TextOverflow.ellipsis,
          textStyle: TextStyles.regular.copyWith(color: AppColors.black171717, fontSize: 18.sp),
        ),
      ],
    );
  }
}
