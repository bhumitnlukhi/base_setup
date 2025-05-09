import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigo_vendor/framework/controller/package/package_controller.dart';
import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/ui/package/mobile/package_mobile.dart';
import 'package:odigo_vendor/ui/package/web/package_web.dart';
import 'package:responsive_builder/responsive_builder.dart';

class Package extends ConsumerStatefulWidget {
  final int? tabIndex;
  const Package({Key? key,this.tabIndex}) : super(key: key);

  @override
  ConsumerState<Package> createState() => _PackageState();
}

class _PackageState extends ConsumerState<Package> {
  ///Build Override
  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
      breakpoints: const ScreenBreakpoints(desktop: 600, tablet: 600, watch: 0),
      mobile: (BuildContext context) {
          return const PackageMobile();
        },
        desktop: (BuildContext context) {
          return PackageWeb(tabIndex:widget.tabIndex);
        },
      //   tablet: (BuildContext context){
      // return OrientationBuilder(builder: (BuildContext context, Orientation orientation){
      //   return orientation == Orientation.landscape ? const PackageWeb() : const PackageMobile();
      // });
    // },
    );
  }

  @override
  void didChangeDependencies() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      if (mounted) {
        if (context.isWebScreen) {
          // EasyDebounce.debounce(showStoreDetailsDialogDebounce, const Duration(milliseconds: 100), () {
          //   final storeWatch = ref.read(storesController);
          //   if (widget.storeUuid != null) {
          //     storeWatch.showStoreDetailsDialog(context, ref, storeUuid: widget.storeUuid!);
          //   }
          // });
        } else {
          EasyDebounce.debounce('PackageDebouse', const Duration(milliseconds: 50), () {
            final packageWatch = ref.watch(packageController);
            if (packageWatch.agencyPurchaseDialogKey.currentContext != null) {
              Navigator.pop(packageWatch.agencyPurchaseDialogKey.currentContext!);
            }
          });
        }
      }
    });
    super.didChangeDependencies();
  }
}

