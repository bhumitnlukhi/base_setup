import 'package:odigo_vendor/framework/utils/extension/extension.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';
import 'package:shimmer/shimmer.dart';

class CommonListShimmer extends StatelessWidget {
  final double? height;
  const CommonListShimmer({super.key, this.height});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      enabled: true,
      child: ListView.builder(
        itemCount: 10,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics() ,
        itemBuilder: (context, index) {
          return Container(
            height: height ?? 60.h,
            decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20.r)), color: AppColors.white),
          ).paddingOnly(bottom: 30.h);
        },
      ),
    );
  }
}
