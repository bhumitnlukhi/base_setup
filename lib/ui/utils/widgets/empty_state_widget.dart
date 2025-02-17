import 'package:flutter_base_setup/framework/utility/extension/string_extension.dart';
import 'package:flutter_base_setup/ui/utils/widgets/show_up_transition.dart';
import 'package:flutter_base_setup/ui/utils/theme/theme.dart';

class EmptyStateWidget extends StatelessWidget {
  final EmptyState emptyStateFor;

  const EmptyStateWidget({
    Key? key,
    required this.emptyStateFor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String imgName = '';
    String title = '';
    String subTitle = '';

    switch (emptyStateFor) {
      case EmptyState.noInternet:
        // imgName = AppAssets.imgNoActivity;
        title = 'Key_noActivityFound'.localized;
        subTitle = 'Key_noActivityDoneByYou'.localized;
        break;
      case EmptyState.somethingWentWrong:
        // imgName = AppAssets.imgNoConnection;
        title = 'Key_connectionLost'.localized;
        subTitle = 'Key_checkConnection'.localized;
        break;
      case EmptyState.noData:
        // imgName = AppAssets.imgNoFavourites;
        title = 'Key_noFavourites'.localized;
        subTitle = 'Key_startAddingWhatYouLike'.localized;
        break;
      default:
        // imgName = AppAssets.imgNoErrorKnown;
        title = 'Key_thereIsSomeError'.localized;
        subTitle = 'Key_someErrorHoldTight'.localized;
        break;
    }

    return Container(
      // color_assessment_running_test: Colors.red,
      margin: EdgeInsets.symmetric(horizontal: 30.w),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if(imgName.isNotEmpty)
              ShowUpTransition(
                delay: 300,
                child: InkWell(onTap: () {}, child: Image.asset(imgName))),
            if(imgName.isNotEmpty) SizedBox(height: 30.h),
            if(title.isNotEmpty) ShowUpTransition(
                delay: 500,
                child: Text(title,
                    textAlign: TextAlign.center,
                    style: TextStyles.semiBold.copyWith(fontSize: 16.sp))),
            SizedBox(height: 10.h),
            if(subTitle.isNotEmpty) ShowUpTransition(
              delay: 700,
              child: Text(subTitle,
                  textAlign: TextAlign.center,
                  style: TextStyles.regular.copyWith(fontSize: 12.sp)),
            )
          ],
        ),
      ),
    );
  }
}

enum EmptyState {
  noInternet,
  somethingWentWrong,
  noData
}
