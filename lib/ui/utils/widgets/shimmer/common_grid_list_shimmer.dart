import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/framework/utils/extension/extension.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';
import 'package:shimmer/shimmer.dart';

class CommonGridListShimmer extends StatelessWidget {
  final double? height;
  const CommonGridListShimmer({super.key, this.height});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      enabled: true,
      child: GridView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemCount: 30,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            // height: height ?? 60.h,
            decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20.r)), color: AppColors.white),
          ).paddingOnly(bottom: 30.h);
        },
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          mainAxisExtent: context.height*0.28,
          mainAxisSpacing: context.height * 0.02,
          crossAxisSpacing: context.width * 0.02,
        )
    ));
  }
}
