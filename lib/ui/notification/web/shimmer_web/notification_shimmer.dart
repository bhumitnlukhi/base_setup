import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:odigo_vendor/framework/provider/network/network.dart';
import 'package:odigo_vendor/framework/utils/extension/extension.dart';
import 'package:odigo_vendor/ui/utils/theme/app_colors.dart';

class ShimmerNotification extends StatelessWidget {
  const ShimmerNotification({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        ListView.separated(
          itemCount: 5,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {

           return  Container(height: 50.h,
             width: MediaQuery.of(context).size.width,
             decoration: BoxDecoration(
                 color:  Colors.grey.shade300,
               border: Border.all(
               ),
               borderRadius:  BorderRadius.all(Radius.circular(20.r)
               )
           ),
           ).paddingSymmetric(vertical: 12.h);
            // return Row(
            //   children: [
            //     Container(
            //       height: 44.h,
            //       width: 44.h,
            //       decoration: const BoxDecoration(
            //           color: AppColors.white, shape: BoxShape.circle),
            //       child: CommonSVG(
            //         strIcon: Assets.svgs.svgNotificationWeb.keyName,
            //         height: 44.h,
            //         width: 44.h,
            //       ).paddingAll(12),
            //     ),
            //     SizedBox(
            //       width: 15.w,
            //     ),
            //     Expanded(
            //       child: Column(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           Container(
            //             width: 120.w,
            //             height: 20.h,
            //             color:  Colors.grey.shade300,
            //           ).paddingOnly(left: 20.w,top: 20.h),
            //           SizedBox(height: 5.h,),
            //           Row(
            //             children: [
            //
            //               Expanded(
            //                 child: Container(
            //                   width: 120.w,
            //                   height: 30.h,
            //                   color:  Colors.grey.shade300,
            //                 ).paddingOnly(left: 20.w),
            //                 // child: SizedBox(
            //                 //   width: 100.w,
            //                 //   height: 20.h,
            //                 // ),
            //               ),
            //               IconButton(
            //                   onPressed: () {},
            //                   icon: const Icon(
            //                     Icons.delete_forever_outlined,
            //                     size: 25,
            //                     color: AppColors.red,
            //                   ))
            //             ],
            //           ),
            //           SizedBox(
            //             height: 5.h,
            //           ),
            //           SizedBox(
            //             width: MediaQuery.sizeOf(context).width,
            //             height: 20.h,
            //           ),
            //         ],
            //       ),
            //     )
            //   ],
            // );
          },
          separatorBuilder: (BuildContext context, int index) {
            return Divider(
              height: 0.h,
              color: AppColors.greyBEBEBE.withOpacity(.2),
            ).paddingSymmetric(horizontal: 20.w,);
          },
        ).paddingSymmetric(horizontal: 20.w,)
      ],
    );
  }
}
