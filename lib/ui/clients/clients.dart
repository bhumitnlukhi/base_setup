import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigo_vendor/framework/controller/clients/clients_controller.dart';
import 'package:odigo_vendor/framework/controller/package/select_client_controller.dart';
import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/ui/clients/mobile/clients_mobile.dart';
import 'package:odigo_vendor/ui/clients/web/clients_web.dart';
import 'package:odigo_vendor/ui/utils/helper/base_widget.dart';
import 'package:responsive_builder/responsive_builder.dart';

class Clients extends ConsumerStatefulWidget {
  final String? clientUuid;
  const Clients({Key? key,this.clientUuid}) : super(key: key);

  @override
  ConsumerState<Clients> createState() => _ClientsState();
}

class _ClientsState extends ConsumerState<Clients> with BaseConsumerStatefulWidget{
  ///Build Override
  @override
  Widget buildPage(BuildContext context) {
    return ScreenTypeLayout.builder(
      breakpoints: const ScreenBreakpoints(desktop: 600, tablet: 600, watch: 0),

      mobile: (BuildContext context) {
        return const ClientsMobile();
      },
      desktop: (BuildContext context) {
        return  ClientsWeb(clientUuid:widget.clientUuid);
      },
      // tablet: (BuildContext context) {
      //   return OrientationBuilder(
      //     builder: (BuildContext context, Orientation orientation) {
      //       return orientation == Orientation.landscape
      //           ? const ClientsWeb()
      //           : const ClientsMobile();
      //     },
      //   );
      // },
    );
  }

  @override
  void didChangeDependencies() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      if (mounted) {

        if(widget.clientUuid != null){
          if (context.isWebScreen) {
            EasyDebounce.debounce('showClientDetailDialog', const Duration(milliseconds: 100), () {
              final clientsWatch = ref.read(clientsController);
              if (widget.clientUuid != null) {
                clientsWatch.showClientDetailsDialog(context, ref, clientUuid: widget.clientUuid!);
              }
            });
          } else{
            EasyDebounce.debounce('showClientDetailDialog', const Duration(milliseconds: 50), () {
              final clientsWatch = ref.read(clientsController);
              Navigator.pop(clientsWatch.clientDetailDialogKey.currentContext!);
            });
          }
        }else{
          if (context.isWebScreen) {
            // EasyDebounce.debounce(showStoreDetailsDialogDebounce, const Duration(milliseconds: 100), () {
            //   final storeWatch = ref.read(storesController);
            //   if (widget.storeUuid != null) {
            //     storeWatch.showStoreDetailsDialog(context, ref, storeUuid: widget.storeUuid!);
            //   }
            // });
          } else {
            EasyDebounce.debounce('ClientBouce', const Duration(milliseconds: 50), () {
              final selectClientWatch = ref.watch(selectClientController);
              final clientsWatch = ref.watch(clientsController);
              if (selectClientWatch.importDialog.currentContext != null) {
                Navigator.pop(selectClientWatch.importDialog.currentContext!);
              }
              if (clientsWatch.clientDetailDialogKey.currentContext != null) {
                Navigator.pop(clientsWatch.clientDetailDialogKey.currentContext!);
              }
            });
          }
        }

      }
    });
    super.didChangeDependencies();
  }
}

