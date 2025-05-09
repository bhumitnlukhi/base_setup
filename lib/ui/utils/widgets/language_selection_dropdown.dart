
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigo_vendor/framework/controller/auth/login_controller.dart';
import 'package:odigo_vendor/framework/controller/drawer/drawer_controller.dart';
import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/framework/utils/extension/extension.dart';
import 'package:odigo_vendor/framework/utils/extension/string_extension.dart';
import 'package:odigo_vendor/framework/utils/session.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_form_field_dropdown.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_svg.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_text.dart';
import 'package:shimmer/shimmer.dart';

class LanguageSelectionDropdown extends ConsumerStatefulWidget {
  const LanguageSelectionDropdown({super.key});

  @override
  ConsumerState<LanguageSelectionDropdown> createState() => _LanguageSelectionDropdownState();
}

class _LanguageSelectionDropdownState extends ConsumerState<LanguageSelectionDropdown> {
  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      final loginWatch = ref.read(loginController);
      await loginWatch.getLanguageApi(context);
      loginWatch.updateSelectedLocale(Session.appLanguageUuid);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final drawerWatch = ref.watch(drawerController);
    final loginWatch = ref.watch(loginController);
    final languageList = loginWatch.languageList;
    return loginWatch.languageState.isLoading
        ? _dropdownShimmer()
        : CommonDropdownInputFormField<String>(
            // width: context.width * 0.14,
            // backgroundColor: AppColors.white,
            borderRadius: 18.r,
            borderColor: AppColors.clrD9D9D9,
            contentPadding: EdgeInsets.only(left: context.width * 0.01, top: 19.h, bottom: 19.h),
            defaultValue: loginWatch.languageData?.uuid ?? (languageList.isNotEmpty ? languageList.firstWhere((element) => element.code == EasyLocalization.of(context)?.locale.languageCode).uuid : null),
            isEnabled: true,
            menuItems: languageList,
            textEditingController: loginWatch.languageController,
            suffixWidget: CommonSVG(
              strIcon: Assets.svgs.svgDropDown.keyName,
              height: 8.h,
              width: 8.w,
              svgColor: null,
            ),
            itemListBuilder: languageList
                .map((e) => e.uuid)
                .toList()
                .map(
                  (item) => DropdownMenuItem<String>(
                    value: item,
                    child: CommonText(
                      title: languageList.where((element) => element.uuid == item).firstOrNull?.name?.capsFirstLetterOfSentence ?? '',
                      textStyle: TextStyles.medium.copyWith(color: AppColors.black),
                    ),
                  ),
                )
                .toList(),
            onChanged: (String? value) async {
              if (Session.appLanguageUuid != value) {
                loginWatch.updateAppLanguage(value);

                /// To Update App Language
                context.setLocale(Locale(Session.appLanguage));
                if (Session.getUserAccessToken().isNotEmpty) {
                  await loginWatch.changeLanguageApi(context, languageUuid: Session.appLanguageUuid);
                  await drawerWatch.disposeController();

                  // await drawerWatch.sideBarListApi(ref);
                }
              }
            },
          );
  }
}

/// Dropdown Shimmer
Widget _dropdownShimmer() {
  return Shimmer.fromColors(
    baseColor: Colors.grey.shade300,
    highlightColor: Colors.grey.shade100,
    child: Container(
      width: 180.w,
      height: 50.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18.r),
        color: AppColors.black,
      ),
    ),
  ).alignAtCenterRight();
}
