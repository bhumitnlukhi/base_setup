import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigo_vendor/framework/controller/ads/add_edit_ads_controller.dart';
import 'package:odigo_vendor/framework/controller/auth/vendor_registration_form_controller.dart';
import 'package:odigo_vendor/framework/controller/package/select_store_controller.dart';
import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/framework/utils/extension/extension.dart';
import 'package:odigo_vendor/framework/utils/extension/string_extension.dart';
import 'package:odigo_vendor/framework/utils/session.dart';
import 'package:odigo_vendor/ui/ads/web/helper/create_ads_web_form.dart';
import 'package:odigo_vendor/ui/routing/stack.dart';
import 'package:odigo_vendor/ui/utils/anim/fade_box_transition.dart';
import 'package:odigo_vendor/ui/utils/const/app_enums.dart';
import 'package:odigo_vendor/ui/utils/helper/base_drawer_page_widget.dart';
import 'package:odigo_vendor/ui/utils/helper/base_widget.dart';
import 'package:odigo_vendor/ui/utils/theme/app_strings.g.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_text.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_top_back_widget.dart';
import 'package:odigo_vendor/ui/utils/widgets/dialog_progressbar.dart';

class AddEditAdsWeb extends ConsumerStatefulWidget {
  const AddEditAdsWeb({Key? key}) : super(key: key);

  @override
  ConsumerState<AddEditAdsWeb> createState() => _AddEditAdsWebState();
}

class _AddEditAdsWebState extends ConsumerState<AddEditAdsWeb> with BaseConsumerStatefulWidget, BaseDrawerPageWidget {

  ///Init Override
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      final addEditAdsWatch = ref.watch(addEditAdsController);
      final vendorRegistrationFormWatch = ref.watch(vendorRegistrationFormController);
      // final selectStoreWatch = ref.watch(selectStoreController);
      addEditAdsWatch.disposeController(isNotify : true);
      vendorRegistrationFormWatch.disposeController(isNotify: true);
      // selectStoreWatch.disposeController(isNotify : true);

      await vendorRegistrationFormWatch.destinationListApi(context, forVendor: Session.getUserType() == UserType.VENDOR.name ? true : null, isFromSignUp: true);
      addEditAdsWatch.getImageSizeList();
      addEditAdsWatch.onRadioUpdateMediaType(MediaTypeEnum.image);
    });
  }

  ///Dispose Override
  @override
  void dispose() {
    super.dispose();
  }

  ///Build Override
  @override
  Widget buildPage(BuildContext context) {
    return _bodyWidget();
  }

  ///Body Widget
  Widget _bodyWidget() {
    final selectStoreWatch = ref.watch(selectStoreController);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        color: AppColors.white,
      ),
      child: FadeBoxTransition(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonBackTopWidget(
                  title: LocaleKeys.keyCreateAds.localized,
                  onTap: () {
                    ref.read(navigationStackController).pop();
                  },
                ).paddingOnly(bottom: context.height * 0.034),

                SizedBox(height: context.height * 0.023),

                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommonText(title: LocaleKeys.keyCreateAdsDesc.localized,textStyle: TextStyles.regular.copyWith(
                          fontSize: 20.sp
                        ),),

                        SizedBox(height: context.height * 0.040),

                        const CreateAdsWebForm(),

                      ],
                    ),
                  ),
                ),
              ],
            ).paddingSymmetric(horizontal: context.width * 0.020, vertical: context.height * 0.030),
            DialogProgressBar(isLoading: selectStoreWatch.storeListState.isLoading)
          ],
        ),
      ),
    );
  }


}
