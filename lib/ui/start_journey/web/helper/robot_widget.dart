import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';

class RobotWidget extends StatelessWidget {
  const RobotWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.black,
      alignment: Alignment.center,
      child:
      Image.asset(
        Assets.images.icRobotImage.keyName,
        height: context.height * 0.6,
        width:  context.width * 0.2,
        fit: BoxFit.cover,
      ),
      // Lottie.asset(
      //   height: context.height * 0.50,
      //   width: context.width * 0.30,
      //   Assets.anim.animStartJourneyRobot.keyName,
      // ),
    );
  }
}
