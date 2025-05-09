import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigo_vendor/ui/package/web/helper/common_own_past_package_list_widget.dart';
import 'package:odigo_vendor/ui/utils/helper/base_widget.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';

class VendorTabListWidget extends ConsumerWidget with BaseConsumerWidget{
  const VendorTabListWidget({Key? key}) : super(key: key);

  @override
  Widget buildPage(BuildContext context,ref) {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        /// Title button widget
        // Container(
        //   height: 48.h,
        //   width: 166.w,
        //   decoration: BoxDecoration(
        //       borderRadius: BorderRadius.circular(40.r),
        //       color:  AppColors.primary2),
        //   child: Center(
        //     child: CommonText(
        //       title:  LocaleKeys.keyPastPackages.localized,
        //       textStyle: TextStyles.regular.copyWith(fontSize: 14.sp, color:AppColors.white ),
        //     )
        //   ),
        // ).paddingOnly(top: context.height*0.07),

        /// List
        Expanded(child: CommonOwnPastPackageListWidget())
      ],
    );
  }
}
