import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:odigo_vendor/framework/controller/ads/ads_controller.dart';
import 'package:odigo_vendor/framework/controller/clients/clients_controller.dart';
import 'package:odigo_vendor/framework/controller/stores/stores_controller.dart';
import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/framework/utils/extension/extension.dart';
import 'package:odigo_vendor/ui/ads/web/helper/client_ads_list_widget.dart';
import 'package:odigo_vendor/ui/routing/stack.dart';
import 'package:odigo_vendor/ui/utils/const/app_constants.dart';
import 'package:odigo_vendor/ui/utils/helper/base_drawer_page_widget.dart';
import 'package:odigo_vendor/ui/utils/helper/base_widget.dart';
import 'package:odigo_vendor/ui/utils/theme/app_colors.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_top_back_widget.dart';

class ClientAdListWeb extends ConsumerStatefulWidget {
  final String? clientUuid;

  const ClientAdListWeb({Key? key, this.clientUuid}) : super(key: key);

  @override
  ConsumerState<ClientAdListWeb> createState() => _ClientAdListWebState();
}

class _ClientAdListWebState extends ConsumerState<ClientAdListWeb> with BaseConsumerStatefulWidget, BaseDrawerPageWidget {
  ///Init Override
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      // print("CLIENT DATA");
      // print(widget.clientData?.name??'');
      // final clientListWatch = ref.watch(clientListController);

      final clientWatch = ref.watch(clientsController);
      final adsWatch = ref.watch(adsController);
      adsWatch.disposeApiData();

      await clientWatch.clientDetailsApi(context, widget.clientUuid ?? '');
      final storeWatch = ref.read(storesController);

      if(mounted){
        await storeWatch.destinationListApi(context,
            pageSize: pageSize100000,
            hasAdsForClient: true,
            activeRecords: true);
      }
      if(mounted){
        adsWatch.adsListApi(context, false,
            isGetOnlyClient: true, cilentMasterUuid: widget.clientUuid);
      }
      adsWatch.clientAdsCtr.addListener(() async {
        if (adsWatch.adsListState.success?.hasNextPage == true) {
          if (adsWatch.clientAdsCtr.position.maxScrollExtent == adsWatch.clientAdsCtr.position.pixels) {
            if (!adsWatch.adsListState.isLoadMore) {
              adsWatch.adsListApi(context, true, isGetOnlyClient: true, cilentMasterUuid: widget.clientUuid);
            }
          }
        }
      });
    });
  }

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
    final clientWatch = ref.watch(clientsController);
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
            children: [
              CommonBackTopWidget(
                title: '${clientWatch.clientDetailsState.success?.data?.name ?? ''}\'s Ads',
                onTap: () {
                  ref.read(navigationStackController).pop();
                },
              ).paddingOnly(bottom: context.height * 0.034),
              const Expanded(child: ClientAdsListWidget()),
            ],
          ).paddingSymmetric(horizontal: context.width * 0.020, vertical: context.height * 0.030)),
    );
  }
}
