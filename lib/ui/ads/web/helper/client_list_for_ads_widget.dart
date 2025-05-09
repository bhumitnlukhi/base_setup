import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigo_vendor/framework/controller/ads/ads_controller.dart';
import 'package:odigo_vendor/framework/controller/package/select_client_controller.dart';
import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/framework/utils/extension/extension.dart';
import 'package:odigo_vendor/framework/utils/extension/string_extension.dart';
import 'package:odigo_vendor/framework/utils/session.dart';
import 'package:odigo_vendor/ui/routing/navigation_stack_item.dart';
import 'package:odigo_vendor/ui/routing/stack.dart';
import 'package:odigo_vendor/ui/utils/anim/fade_box_transition.dart';
import 'package:odigo_vendor/ui/utils/helper/base_widget.dart';
import 'package:odigo_vendor/ui/utils/theme/app_strings.g.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_list_tile.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_svg.dart';
import 'package:odigo_vendor/ui/utils/widgets/dialog_progressbar.dart';
import 'package:odigo_vendor/ui/utils/widgets/empty_state_widget.dart';
import 'package:odigo_vendor/ui/utils/widgets/shimmer/common_master_shimmer.dart';
import 'package:odigo_vendor/ui/utils/widgets/table_child_text_widget_master.dart';
import 'package:odigo_vendor/ui/utils/widgets/table_header_text_widget_master.dart';

class ClientListForAdWidget extends ConsumerWidget with BaseConsumerWidget {
  const ClientListForAdWidget({super.key});

  @override
  Widget buildPage(BuildContext context,WidgetRef ref) {
    final selectClientWatch = ref.watch(selectClientController);
    final adsWatch = ref.watch(adsController);

    return Column(
      children: [
        /// ads list header
        Table(
          textDirection: Session.isRTL ? TextDirection.rtl : TextDirection.ltr,
          columnWidths: const {


            0: FlexColumnWidth(2),

            1: FlexColumnWidth(4),

            2: FlexColumnWidth(1),



          },
          children: [
            TableRow(children: [
              // TableHeaderTextWidget(text: LocaleKeys.keyDefault.localized),
              TableHeaderTextWidget(text: LocaleKeys.keyClientName.localized),
              TableHeaderTextWidget(text: LocaleKeys.keyAdsCount.localized),
              const Offstage()
            ]),
          ],
        ).paddingOnly(bottom: context.height * 0.022, left: context.width * 0.010),

        /// ads listing
        ///todo: uncomment
        Expanded(
          child:
          selectClientWatch.clientListState.isLoading?
          const CommonListShimmer():
          adsWatch.clientDataList.isEmpty?
          EmptyStateWidget(imgName:Assets.svgs.svgNoData.keyName,title: LocaleKeys.keyNoDataFound.localized,):
          FadeBoxTransition(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: adsWatch.clientDataList.length,
              controller: adsWatch.clientAdsCtr,
              itemBuilder: (context, index) {

                final data = adsWatch.clientDataList[index];
                return CommonListTile(
                  childWidget:
                  Table(
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    textDirection: Session.isRTL ? TextDirection.rtl : TextDirection.ltr,
                    columnWidths: const {

                      0: FlexColumnWidth(2),

                      1: FlexColumnWidth(4),

                      2: FlexColumnWidth(1),



                    },
                    children: [
                      TableRow(children: [
                        TableChildTextWidget(text: data?.name??''),
                        TableChildTextWidget(text: (data?.adsCount??'').toString()),

                        /// details
                        InkWell(
                            onTap: () {
                              adsWatch.clearFilters(context);
                              ref.read(navigationStackController).push( NavigationStackItem.clientAdList(id: data?.uuid));
                            },
                            child: CommonSVG(strIcon: Assets.svgs.svgForwardArrow.keyName,  width: context.width * 0.045, height: context.height * 0.045,isRotate: true,))

                      ]),
                    ],
                  ).paddingSymmetric(horizontal: context.width * 0.010, vertical: context.height * 0.01),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return SizedBox(
                  height: 25.h,
                );
              },
            ),
          ),
        ),
        DialogProgressBar(isLoading: selectClientWatch.clientListState.isLoadMore, forPagination: true,)

      ],
    );
  }
}
