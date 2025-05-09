import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:odigo_vendor/framework/controller/clients/clients_controller.dart';
import 'package:odigo_vendor/framework/controller/package/select_client_controller.dart';
import 'package:odigo_vendor/framework/provider/network/api_end_points.dart';
import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/framework/utils/extension/extension.dart';
import 'package:odigo_vendor/framework/utils/extension/string_extension.dart';
import 'package:odigo_vendor/framework/utils/session.dart';
import 'package:odigo_vendor/ui/clients/web/helper/client_details_dialog_widget.dart';
import 'package:odigo_vendor/ui/routing/navigation_stack_item.dart';
import 'package:odigo_vendor/ui/routing/stack.dart';
import 'package:odigo_vendor/ui/utils/anim/fade_box_transition.dart';
import 'package:odigo_vendor/ui/utils/helper/base_widget.dart';
import 'package:odigo_vendor/ui/utils/theme/app_strings.g.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_cupertino_switch.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_dialogs.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_list_tile.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_svg.dart';
import 'package:odigo_vendor/ui/utils/widgets/dialog_progressbar.dart';
import 'package:odigo_vendor/ui/utils/widgets/empty_state_widget.dart';
import 'package:odigo_vendor/ui/utils/widgets/shimmer/common_master_shimmer.dart';
import 'package:odigo_vendor/ui/utils/widgets/table_child_text_widget_master.dart';
import 'package:odigo_vendor/ui/utils/widgets/table_header_text_widget_master.dart';

class ClientsListWidget extends ConsumerWidget with BaseConsumerWidget {
  const ClientsListWidget({super.key});

  @override
  Widget buildPage(BuildContext context,WidgetRef ref) {
    final clientsWatch = ref.watch(clientsController);
    final selectClientWatch = ref.watch(selectClientController);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// client list header
        Table(
          textDirection: Session.isRTL ? TextDirection.rtl : TextDirection.ltr,
          columnWidths: const {
            /// status
            0: FlexColumnWidth(1),

            /// client name
            1: FlexColumnWidth(2),

            /// category name
            2: FlexColumnWidth(3),

            /// client address
            3: FlexColumnWidth(6.5),

            /// edit name
            4: FlexColumnWidth(0.5),

            /// detail
            5: FlexColumnWidth(1),

          },
          children: [
            TableRow(children: [
              TableHeaderTextWidget(text: LocaleKeys.keyStatus.localized),
              TableHeaderTextWidget(text: LocaleKeys.keyClientName.localized),
              TableHeaderTextWidget(text: LocaleKeys.keyCategory.localized),
              TableHeaderTextWidget(text: LocaleKeys.keyClientAddress.localized),
              TableHeaderTextWidget(text: LocaleKeys.keyEdit.localized),
              const TableHeaderTextWidget(text: ''),
            ]),
          ],
        ).paddingOnly(bottom: context.height * 0.022, left: context.width * 0.007),

        /// store listing
        selectClientWatch.clientListState.isLoading ?  const Expanded(child: CommonListShimmer()) :
            selectClientWatch.clientList.isEmpty ?  Expanded(
              child: Center(
                child: EmptyStateWidget(
                  imgHeight: 150.h,
                  imgWidth: 150.w,
                  imgName: Assets.svgs.svgNoData.keyName,
                  title: LocaleKeys.keyNoDataFound.localized,
                  ),
              ),
            ):
        Expanded(
          child: FadeBoxTransition(
            child: Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: selectClientWatch.clientList.length,
                    controller: selectClientWatch.scrollController,
                    itemBuilder: (context, index) {
                      final listItem = selectClientWatch.clientList[index];
                      return CommonListTile(
                        childWidget:
                        Table(
                          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                          textDirection: Session.isRTL ? TextDirection.rtl : TextDirection.ltr,
                          columnWidths: const {
                            /// status
                            0: FlexColumnWidth(1),
                  
                            /// store name
                            1: FlexColumnWidth(2),
                  
                            /// category name
                            2: FlexColumnWidth(3),
                  
                            /// client address
                            3: FlexColumnWidth(6.5),
                  
                            /// edit
                            4: FlexColumnWidth(0.5),
                  
                            /// detail
                            5: FlexColumnWidth(1),
                  
                  
                          },
                          children: [
                            TableRow(children: [
                              Align(
                                alignment: (Session.isRTL ? Alignment.centerRight : Alignment.centerLeft),
                                child: selectClientWatch.clientStatusUpdateState.isLoading && selectClientWatch.currentIndex ==index?
                                LoadingAnimationWidget.waveDots(color: AppColors.black, size: 22.h).alignAtCenterLeft().paddingOnly(left: 5.w):
                                CommonCupertinoSwitch(
                                  switchValue: listItem?.active ?? false,
                                  onChanged: (val) {
                                    selectClientWatch.clientStatusUpdateApi(context, index, clientId: listItem?.uuid??'', active: val).then((value) {
                                      if(value.success?.status == ApiEndPoints.apiStatus_200){
                                        selectClientWatch.changeClientStatus(index);
                                      }
                                    },);
                                  },
                                ),
                              ),
                              TableChildTextWidget(text: listItem?.name??''),
                              TableChildTextWidget(text: listItem?.businessCategory?.name??''),
                              TableChildTextWidget(text: listItem?.stateName??''),
                  
                              /// edit icon
                              InkWell(
                                  onTap:(){
                                    ref.read(navigationStackController).push( NavigationStackItem.addEditClients(isEdit: true,clientId: listItem?.uuid??'',index: index));
                                  },
                                  child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: CommonSVG(strIcon: Assets.svgs.svgEdit.keyName, width: context.width * 0.04, height: context.height * 0.04))),
                  
                              /// details
                              InkWell(
                                  onTap: () {
                                    ref.read(navigationStackController).pushRemove(NavigationStackItem.clients(clientUuid: listItem?.uuid));
                                    if (listItem?.uuid != null) {
                                      clientsWatch.showClientDetailsDialog(context, ref, clientUuid: listItem?.uuid??'');
                                    }
                                  },
                                  child: CommonSVG(strIcon: Assets.svgs.svgForwardArrow.keyName,  width: context.width * 0.045, height: context.height * 0.045,isRotate: true,))
                  
                            ]),
                          ],
                        ).paddingOnly( top: 10.h, bottom: 10.h),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(
                        height: 25.h,
                      );
                    },
                  ),
                ),
                DialogProgressBar(isLoading: selectClientWatch.clientListState.isLoadMore,forPagination: true)

              ],
            ),
          ),
        )
      ],
    );
  }

  void showClientDetailsDialog(BuildContext context,WidgetRef ref) {
    final clientsWatch = ref.watch(clientsController);
    showCommonWebDialog(
        // height: 0.4,
        width: 0.5,
        context: context,
        keyBadge: clientsWatch.clientDetailDialogKey,
        dialogBody: const ClientDetailsDialogWidget()
    );
  }
}
