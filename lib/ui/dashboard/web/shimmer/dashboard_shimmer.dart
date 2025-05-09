import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/framework/utils/extension/extension.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';
import 'package:shimmer/shimmer.dart';

class DashboardShimmer extends StatelessWidget {
  const DashboardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        enabled: true,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      width: context.width,
                      height: context.height*0.25,
                      decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(20.r)
                      ),
                    ).paddingOnly(right: context.width*0.015),
                  ),
                  Expanded(
                    child: Container(
                      width: context.width,
                      height: context.height*0.25,
                      decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(20.r)
                      ),
                    ),
                  )
                ],
              ),
          
              SizedBox(
                height: 30.h,
              ),
          
              Row(
                children: [
                  Expanded(
                    child: Container(
                      width: context.width,
                      height: context.height*0.25,
                      decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(20.r)
                      ),
                    ).paddingOnly(right: context.width*0.015),
                  ),
                  Expanded(
                    child: Container(
                      width: context.width,
                      height: context.height*0.25,
                      decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(20.r)
                      ),
                    ),
                  )
                ],
              ),
          
            ],
          ),
        )
    );
  }
}
