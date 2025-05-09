import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigo_vendor/framework/utils/extension/extension.dart';
import 'package:odigo_vendor/ui/utils/helper/base_widget.dart';
import 'package:odigo_vendor/ui/utils/helper/date_picker/calendar_controller.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';

class PreviousNextButtonWidget extends StatelessWidget with BaseStatelessWidget {
  const PreviousNextButtonWidget({super.key});

  @override
  Widget buildPage(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        final calendarWatch = ref.watch(calendarController);
        return Row(
          children: [
            Opacity(
              opacity: calendarWatch.isPreviousButtonVisible() ? 1 : 0.4,
              child: InkWell(
                onTap: () {
                  calendarWatch.goToPreviousMonth();
                },
                child: const Icon(
                  CupertinoIcons.left_chevron,
                  color: AppColors.blue0083FC,
                ),
              ).paddingAll(5.w),
            ),
            SizedBox(width: 10.w),
            Opacity(
              opacity: calendarWatch.isForwardButtonVisible() ? 1 : 0.4,
              child: InkWell(
                onTap: () {
                  calendarWatch.goToNextMonth();
                },
                child: const Icon(
                  CupertinoIcons.right_chevron,
                  color: AppColors.blue0083FC,
                ),
              ).paddingAll(5.w),
            ),
          ],
        );
      },
    );
  }
}
