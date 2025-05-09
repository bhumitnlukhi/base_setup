import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigo_vendor/framework/controller/package/select_destination_controller.dart';
import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/ui/package/mobile/select_destination_mobile.dart';
import 'package:odigo_vendor/ui/package/web/select_destination_web.dart';
import 'package:responsive_builder/responsive_builder.dart';

class SelectDestination extends ConsumerStatefulWidget {
  final bool? isForOwn;

  const SelectDestination({Key? key, this.isForOwn}) : super(key: key);

  @override
  ConsumerState<SelectDestination> createState() => _SelectDestinationState();
}

class _SelectDestinationState extends ConsumerState<SelectDestination> {
  ///Init
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {});
  }

  ///Dispose
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  ///Build
  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
      breakpoints: const ScreenBreakpoints(desktop: 600, tablet: 600, watch: 0),
      mobile: (BuildContext context) {
        return const SelectDestinationMobile();
      },
      desktop: (BuildContext context) {
        return SelectDestinationWeb(isForOwn:widget.isForOwn);
      },
      // tablet: (BuildContext context){
      //   return OrientationBuilder(builder: (BuildContext context, Orientation orientation){
      //     return orientation == Orientation.landscape ? SelectDestinationWeb(isForOwn:isForOwn) : const SelectDestinationMobile();
      //   });
      // },
    );
  }

  @override
  void didChangeDependencies() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      if (mounted) {
        if (context.isWebScreen) {
          // EasyDebounce.debounce(showStoreDetailsDialogDebounce, const Duration(milliseconds: 100), () {

          //   if (widget.storeUuid != null) {
          //     storeWatch.showStoreDetailsDialog(context, ref, storeUuid: widget.storeUuid!);
          //   }
          // });
        } else {
          EasyDebounce.debounce('usersDebounce', const Duration(milliseconds: 50), () {
            final destinationWatch = ref.read(selectDestinationController);
            if(destinationWatch.destinationDialogKey.currentContext != null) {Navigator.pop(destinationWatch.destinationDialogKey.currentContext!);}

          });
        }
      }
    });
    super.didChangeDependencies();
  }
}


