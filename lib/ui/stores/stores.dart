import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigo_vendor/framework/controller/stores/stores_controller.dart';
import 'package:odigo_vendor/framework/provider/network/network.dart';
import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/ui/stores/mobile/stores_mobile.dart';
import 'package:odigo_vendor/ui/stores/web/stores_web.dart';
import 'package:odigo_vendor/ui/utils/const/app_constants.dart' show showStoreDetailsDialogDebounce;
import 'package:responsive_builder/responsive_builder.dart';

class Stores extends ConsumerStatefulWidget {
  final String? storeUuid;

  const Stores({Key? key, this.storeUuid}) : super(key: key);

  @override
  ConsumerState<Stores> createState() => _StoresState();
}

class _StoresState extends ConsumerState<Stores> {
  ///Build Override
  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
      breakpoints: const ScreenBreakpoints(desktop: 600, tablet: 600, watch: 0),
      mobile: (BuildContext context) {
        return const StoresMobile();
      },
      desktop: (BuildContext context) {
        return const StoresWeb();
      },
    );
  }

  @override
  void didChangeDependencies() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      if (mounted) {
        if (widget.storeUuid != null) {
          if (context.isWebScreen) {
            EasyDebounce.debounce(showStoreDetailsDialogDebounce, const Duration(milliseconds: 100), () {
              final storeWatch = ref.read(storesController);
              if (widget.storeUuid != null) {
                storeWatch.showStoreDetailsDialog(context, ref, storeUuid: widget.storeUuid!);
              }
            });
          } else {
            EasyDebounce.debounce(showStoreDetailsDialogDebounce, const Duration(milliseconds: 50), () {
              final storeWatch = ref.read(storesController);
              if (storeWatch.detailsDialogKey.currentContext != null) {
                Navigator.pop(storeWatch.detailsDialogKey.currentContext!);
              }
              if (storeWatch.storeImportDialogKey.currentContext != null) {
                Navigator.pop(storeWatch.storeImportDialogKey.currentContext!);
              }
            });
          }
        }
      }
    });
    super.didChangeDependencies();
  }

}
