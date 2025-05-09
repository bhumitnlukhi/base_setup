import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigo_vendor/framework/controller/ticket_management/ticket_management_controller.dart';
import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/ui/ticket_management/mobile/ticket_management_mobile.dart';
import 'package:odigo_vendor/ui/ticket_management/web/ticket_management_web.dart';
import 'package:odigo_vendor/ui/utils/helper/base_widget.dart';
import 'package:responsive_builder/responsive_builder.dart';

class TicketManagement extends ConsumerStatefulWidget {
  final String? ticketUuid;
  const TicketManagement({Key? key, this.ticketUuid}) : super(key: key);

  @override
  ConsumerState<TicketManagement> createState() => _TicketManagementState();
}

class _TicketManagementState extends ConsumerState<TicketManagement> with BaseConsumerStatefulWidget{
  ///Build Override
  @override
  Widget buildPage(BuildContext context) {
    return ScreenTypeLayout.builder(
      breakpoints: const ScreenBreakpoints(desktop: 600, tablet: 600, watch: 0),
      mobile: (BuildContext cntx) {
          return const TicketManagementMobile();
        },
        desktop: (BuildContext cntx) {
          return  TicketManagementWeb(context,ticketUuid: widget.ticketUuid,);
        },
    //     tablet:  (BuildContext xntc){
    //       return  TicketManagementWeb(context);
    // },
    );
  }

  @override
  void didChangeDependencies() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      if (mounted) {
        if(widget.ticketUuid != null){
          if (context.isWebScreen) {
            EasyDebounce.debounce('showTicketDetailDialog', const Duration(milliseconds: 100), () {
              final ticketsWatch = ref.read(ticketManagementController);
              if (widget.ticketUuid != null) {
                ticketsWatch.showTicketDetailDialog(context, ref, ticketUuid: widget.ticketUuid!);
              }
            });
          } else{
            EasyDebounce.debounce('showTicketDetailDialog', const Duration(milliseconds: 50), () {
              final ticketsWatch = ref.read(ticketManagementController);
              Navigator.pop(ticketsWatch.ticketDetailDialogKey.currentContext!);
            });
          }
        }else{
          if (context.isWebScreen) {

          } else {
            EasyDebounce.debounce('stateTicketDebounce', const Duration(milliseconds: 50), () {
              final ticketWatch = ref.read(ticketManagementController);
              if(ticketWatch.ticketDetailDialogKey.currentContext != null) {Navigator.pop(ticketWatch.ticketDetailDialogKey.currentContext!);}
              if(ticketWatch.dailog1Key.currentContext != null) {Navigator.pop(ticketWatch.dailog1Key.currentContext!);}
              if(ticketWatch.dailog2Key.currentContext != null) {Navigator.pop(ticketWatch.dailog2Key.currentContext!);}
              if(ticketWatch.dailog3Key.currentContext != null) {Navigator.pop(ticketWatch.dailog3Key.currentContext!);}


            });
          }
        }
       
      }
    });
    super.didChangeDependencies();
  }
}

