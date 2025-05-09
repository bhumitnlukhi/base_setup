import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigo_vendor/framework/controller/ticket_management/ticket_management_controller.dart';
import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/framework/utils/extension/extension.dart';
import 'package:odigo_vendor/framework/utils/extension/string_extension.dart';
import 'package:odigo_vendor/ui/ticket_management/web/helper/all_ticket_management_list.dart';
import 'package:odigo_vendor/ui/ticket_management/web/helper/ticket_management_list.dart';
import 'package:odigo_vendor/ui/ticket_management/web/helper/ticket_management_top_row_widget.dart';
import 'package:odigo_vendor/ui/utils/anim/fade_box_transition.dart';
import 'package:odigo_vendor/ui/utils/helper/base_drawer_page_widget.dart';
import 'package:odigo_vendor/ui/utils/helper/base_widget.dart';
import 'package:odigo_vendor/ui/utils/theme/app_strings.g.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_text.dart';
import 'package:odigo_vendor/ui/utils/widgets/dialog_progressbar.dart';

class TicketManagementWeb extends ConsumerStatefulWidget {
  final BuildContext context;
  final String? ticketUuid;
  const TicketManagementWeb(this.context, {Key? key,this.ticketUuid}) : super(key: key);

  @override
  ConsumerState<TicketManagementWeb> createState() =>
      _TicketManagementWebState();
}

class _TicketManagementWebState extends ConsumerState<TicketManagementWeb> with BaseConsumerStatefulWidget , BaseDrawerPageWidget {

  ///Init Override
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      final ticketManagementWatch = ref.watch(ticketManagementController);
      ticketManagementWatch.disposeController(isNotify : true);
      ticketManagementWatch.ctrSearch.clear();

    });
  }

  ///Search popUp controllers
  final link = LayerLink();
  OverlayEntry? overlayEntry;

  ///Dispose Override
  @override
  void dispose() {
    overlayEntry?.remove();
    overlayEntry?.dispose();
    overlayEntry = null;
    super.dispose();
  }

  ///Build Override
  @override
  Widget buildPage(BuildContext context) {
    return _bodyWidget();
  }

  ///Body Widget
  Widget _bodyWidget() {
    final ticketManagementWatch = ref.watch(ticketManagementController);
    return Stack(
      children: [
        Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(29.r),
              color: AppColors.white,
            ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              /// Top Widget
              FadeBoxTransition(
                child: TicketManagementTopRowWidget(
                  widget.context,
                    link: link,
                  ),
              ),
              ( ticketManagementWatch.startDate != null&& ticketManagementWatch.endDate !=null) || ticketManagementWatch.selectedFilterList.isNotEmpty? InkWell(
                onTap: (){
                  ticketManagementWatch.clearFilters();
                  ticketManagementWatch.ticketListApi(context, false);

                  ticketManagementWatch.ticketListScrollController.addListener(() async{
                    if (ticketManagementWatch.ticketListState.success?.hasNextPage == true) {
                      if (ticketManagementWatch.ticketListScrollController.position.maxScrollExtent == ticketManagementWatch.ticketListScrollController.position.pixels) {
                        if(!ticketManagementWatch.ticketListState.isLoadMore) {
                          await ticketManagementWatch.ticketListApi(context,true,);
                        }
                      }
                    }
                  });
                },
                child: CommonText(
                  title: LocaleKeys.keyClearFilters.localized,
                  textStyle: TextStyles.regular.copyWith(
                    decoration: TextDecoration.underline,
                    decorationColor: AppColors.blue009AF1,
                    fontSize: 13.sp,
                    color: AppColors.blue009AF1,
                  ),
                ).alignAtCenterRight(),
              ).paddingOnly(right: context.width * 0.035,top: context.height*0.02 ):const Offstage(),
                SizedBox(height: context.height * 0.035),
              /// Headings
              SizedBox(
                height: context.height * 0.050,
                child: const TicketManagementList(),
              ).paddingSymmetric(horizontal: context.width * 0.020),

              /// Data
              const Expanded(
                child: AllTicketManagementList(),
              ),
            ],
          ),
        ).paddingAll(context.height*0.025),
        DialogProgressBar(isLoading: ticketManagementWatch.ticketDetailState.isLoading),
      ],
    );
  }

}
