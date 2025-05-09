import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/framework/utils/extension/extension.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';
import 'package:odigo_vendor/ui/utils/widgets/cache_image.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_text.dart';

class StoreListTileWidget extends StatelessWidget {
  final String image;
  final String name;
  final String city;
  const StoreListTileWidget({super.key, required this.image, required this.name, required this.city});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18.sp),
          border: Border.all(
            color: AppColors.clr707070.withOpacity(0.3),
          )
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// Image
          Stack(
            alignment: Alignment.center,
            children: [
              ClipOval(
                child: CacheImage(imageURL: image,
                  width: context.height*0.1,
                  height: context.height*0.1,
                  shape: BoxShape.circle,
                  placeholderName: name[0],
                ),
              ),
              // Positioned(
              //   top: 2.h,
              //   right: 4.w,
              //   child: Container(
              //     decoration: const BoxDecoration(
              //       shape: BoxShape.circle,
              //       color: AppColors.green35C658,
              //     ),
              //     height: 20.h,
              //     width: 20.h,
              //   ),
              // )
            ],
          ),

          CommonText(
            title: name,
            maxLines: 3,
            textOverflow: TextOverflow.ellipsis,
            textStyle: TextStyles.semiBold.copyWith(
              fontSize: 17.sp,
            ),
            textAlign: TextAlign.center,
          ).paddingOnly(bottom: context.height*0.02,top: context.height*0.02 ),
          CommonText(
            title: city,
            textOverflow: TextOverflow.ellipsis,
            maxLines: 3,
            textStyle: TextStyles.regular.copyWith(
              fontSize: 14.sp,
            ),
          )
        ],
      ).paddingAll(15.h),
    );
  }
}
