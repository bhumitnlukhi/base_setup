import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigo_vendor/framework/controller/package/package_controller.dart';
import 'package:odigo_vendor/framework/controller/stores/stores_controller.dart';
import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/framework/utils/extension/extension.dart';
import 'package:odigo_vendor/framework/utils/extension/string_extension.dart';
import 'package:odigo_vendor/ui/package/web/helper/client_package_list_web.dart';
import 'package:odigo_vendor/ui/package/web/helper/common_own_past_package_list_widget.dart';
import 'package:odigo_vendor/ui/utils/const/app_constants.dart';
import 'package:odigo_vendor/ui/utils/helper/base_widget.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_text.dart';

class AgencyTabListWidget extends ConsumerWidget with BaseConsumerWidget{
  const AgencyTabListWidget({Key? key}) : super(key: key);

  @override
  Widget buildPage(BuildContext context,ref) {
    final packageWatch = ref.watch(packageController);
    final storesWatch = ref.watch(storesController);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: context.height * 0.070,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ///Tab List
              ListView.separated(
                itemCount: packageWatch.agencyUserPackageTabList.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  ///Tab Container
                  return IgnorePointer(
                    ignoring: packageWatch.packageListState.isLoading,
                    child: InkWell(
                      onTap: () async {
                        // packageWatch.destinationData = null;

                        packageWatch.disposeController(isNotify: true);
                        packageWatch.changeAgencyDetailsTab(index);
                        packageWatch.screenNavigationOnTabChange(ref);
                        await packageWatch.packageListApi(context, false);
                        if(context.mounted){
                          await storesWatch.destinationListApi(context,
                              pageSize: pageSize100000,
                              hasPurchased: packageWatch.agencyUserTabIndex == 0
                                  ? true
                                  : null,
                              hasPurchasedForClient:
                                  packageWatch.agencyUserTabIndex == 1
                                      ? true
                                      : null,
                              activeRecords: true);
                        }
                      },
                      child: Container(
                        height: context.height * 0.055,
                        width: context.width * 0.1,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40.r),
                            border: Border.all(color: packageWatch.agencyUserTabIndex == index ? AppColors.primary2 : AppColors.clrD6D6D6),
                            color: packageWatch.agencyUserTabIndex == index ? AppColors.primary2 :(packageWatch.packageListState.isLoading ?AppColors.greyC9CED5 : AppColors.clrF7F7FC)),
                        child: Center(
                          child: CommonText(
                            title: packageWatch.agencyUserPackageTabList[index].localized,
                            textStyle: TextStyles.regular.copyWith(fontSize: 14.sp, color: packageWatch.agencyUserTabIndex == index ? AppColors.white : AppColors.clr626262),
                          ),
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(
                    width: context.width * 0.015,
                  );
                },
              ),
            ],
          ),
        ).paddingOnly(top: context.height*0.03),

        /// List widget
        Expanded(child: packageWatch.agencyUserTabIndex == 0
            ? const CommonOwnPastPackageListWidget()
            : const ClientPackageListWeb())
      ],
    );
  }
}
