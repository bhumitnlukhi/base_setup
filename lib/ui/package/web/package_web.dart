import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:odigo_vendor/framework/controller/ads/ads_controller.dart';
import 'package:odigo_vendor/framework/controller/package/package_controller.dart';
import 'package:odigo_vendor/framework/controller/package/select_client_controller.dart';
import 'package:odigo_vendor/framework/controller/stores/stores_controller.dart';
import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/framework/utils/extension/extension.dart';
import 'package:odigo_vendor/framework/utils/extension/string_extension.dart';
import 'package:odigo_vendor/framework/utils/session.dart';
import 'package:odigo_vendor/ui/package/web/helper/agency_purchase_new_dialog.dart';
import 'package:odigo_vendor/ui/package/web/helper/agency_tab_list_widget.dart';
import 'package:odigo_vendor/ui/package/web/helper/vendor_tab_list_wiget.dart';
import 'package:odigo_vendor/ui/routing/navigation_stack_item.dart';
import 'package:odigo_vendor/ui/routing/stack.dart';
import 'package:odigo_vendor/ui/utils/anim/fade_box_transition.dart';
import 'package:odigo_vendor/ui/utils/const/app_constants.dart';
import 'package:odigo_vendor/ui/utils/const/app_enums.dart';
import 'package:odigo_vendor/ui/utils/helper/base_drawer_page_widget.dart';
import 'package:odigo_vendor/ui/utils/helper/base_widget.dart';
import 'package:odigo_vendor/ui/utils/theme/app_colors.dart';
import 'package:odigo_vendor/ui/utils/theme/app_strings.g.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_dialogs.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_top_row_web.dart';

class PackageWeb extends ConsumerStatefulWidget {
  final int? tabIndex;

  const PackageWeb({Key? key, this.tabIndex}) : super(key: key);

  @override
  ConsumerState<PackageWeb> createState() => _PackageWebState();
}

class _PackageWebState extends ConsumerState<PackageWeb> with BaseConsumerStatefulWidget, BaseDrawerPageWidget {
  ///Init Override
  @override
  void initState() {
    super.initState();
    ref.read(packageController).agencyUserTabIndex = 0;
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      final adsWatch = ref.watch(adsController);
      final selectClientWatch = ref.watch(selectClientController);

      /// Ads List Api Call if no Ads Created purchase package button should be disable
      if(Session.getUserType() == UserType.AGENCY.name) {
        selectClientWatch.clientListApi(context, false, isAdsAvailable: true);
      }
      await adsWatch.adsListApi(context, false, agencyUuid: Session.getUuid()).then((value) async {
        if (adsWatch.adsList.isNotEmpty) {
          /// Package Module Apis
          final packageWatch = ref.watch(packageController);
          packageWatch.disposeController(isNotify: true);
          packageWatch.packageSearchCtr.clear();
          if (widget.tabIndex != null) {
            if (widget.tabIndex == 0) {
              packageWatch.changeAgencyDetailsTab(0);
            } else {
              packageWatch.changeAgencyDetailsTab(1);
            }
          }

          /// Package List
          await packageWatch.packageListApi(context, false);
          final storesWatch = ref.watch(storesController);
          // storesWatch.disposeController(isNotify: true);
          if (mounted) {
            await storesWatch.destinationListApi(
              context,
              pageSize: pageSize100000,
              hasPurchased: (packageWatch.agencyUserTabIndex == 0 || Session.getUserType() == UserType.VENDOR.name) ? true : null,
              hasPurchasedForClient: packageWatch.agencyUserTabIndex == 1 ? true : null,
            );

            // await storesWatch.destinationListApiCall(context);
          }

          packageWatch.packageScrollController.addListener(() async {
            if (packageWatch.packageListState.success?.hasNextPage == true) {
              if (packageWatch.packageScrollController.position.maxScrollExtent == packageWatch.packageScrollController.position.pixels) {
                if (!packageWatch.packageListState.isLoadMore) {
                  await packageWatch.packageListApi(context, true);
                }
              }
            }
          });
        }
      });
    });
  }

  bool get isPurchasedEnabled => ref.read(adsController).adsList.isNotEmpty || ref.read(selectClientController).clientList.isNotEmpty;

  ///Dispose Override
  @override
  void dispose() {
    super.dispose();
  }

  ///Build Override
  @override
  Widget buildPage(BuildContext context) {
    return _bodyWidget();
  }

  ///Body Widget
  Widget _bodyWidget() {
    final packageWatch = ref.watch(packageController);
    final storesWatch = ref.watch(storesController);
    return InkWell(
      onTap: () {
        if (storesWatch.tooltipDestinationController?.isShowing ?? false) {
          storesWatch.tooltipDestinationController?.toggle();
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          color: AppColors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// Top widget
            FadeBoxTransition(
              child: CommonTopRowWeb(
                masterTitle: LocaleKeys.keyPackage.localized,
                searchController: packageWatch.packageSearchCtr,
                searchPlaceHolder: LocaleKeys.keySearchHere.localized,
                showSearchBar: false,
                showExport: false,
                extraSpace: context.width * 0.054,
                onCreateTap: () {
                  if (Session.getUserType() == UserType.AGENCY.name) {
                    showCommonWebDialog(width: 0.4, keyBadge: packageWatch.agencyPurchaseDialogKey, context: context, dialogBody: const AgencyPurchaseNewDialog().paddingAll(20.h));
                  } else {
                    ref.read(navigationStackController).push(const NavigationStackItem.selectDestinations(isForOwn: false));
                  }
                },
                onExportTap: () {},
                onImportTap: () {},
                isButtonEnabled: isPurchasedEnabled,
                buttonText: LocaleKeys.keyPurchase.localized,
                showImport: false,
              ),
            ),
            Expanded(child: Session.getUserType() == UserType.AGENCY.name ? const AgencyTabListWidget() : const VendorTabListWidget())
          ],
        ).paddingAll(context.height * 0.02),
      ).paddingAll(context.height * 0.025),
    );
  }
}
