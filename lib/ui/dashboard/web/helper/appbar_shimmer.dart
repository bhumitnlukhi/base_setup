import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/framework/utils/extension/extension.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';
import 'package:shimmer/shimmer.dart';

class AppbarShimmer extends StatelessWidget {
  const AppbarShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        enabled: true,
        child: Row(
          children: [
            Container(
              height: 57.h,
              width: 57.h,
              decoration: const BoxDecoration(
                  color: AppColors.white,
                shape: BoxShape.circle
              ),
            ).paddingOnly(right: context.width*0.015),

            Container(
              width: context.width*0.075,
              height: context.height*0.03,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(20.r)
              ),
            ),

            const Spacer(),
            Container(
              height: 57.h,
              width: 57.h,
              decoration: const BoxDecoration(
                  color: AppColors.white,
                  shape: BoxShape.circle
              ),
            ),
          ],
        )
    );
  }
}
