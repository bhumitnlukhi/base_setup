import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/framework/utils/extension/string_extension.dart';
import 'package:odigo_vendor/ui/utils/helper/base_widget.dart';
import 'package:odigo_vendor/ui/utils/theme/app_strings.g.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_button.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_export_widget.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_import_widget.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_searchbar.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_text.dart';

class CommonTopRowWeb extends StatelessWidget with BaseStatelessWidget{
  final String? masterTitle;
  final String? searchPlaceHolder;
  final TextEditingController searchController;
  final ValueChanged<String>? onChanged;
  final GestureTapCallback? onExportTap;
  final GestureTapCallback? onImportTap;
  final GestureTapCallback? onCreateTap;
  final bool?isFilterRequired;
  final List? menuItems;
  final Function(int id)? onDropDownTap;
  final Widget? filterWidget;
  final bool? showImport;
  final bool? showExport;
  final bool? showSearchBar;
  final String? buttonText;
  final double? buttonHeight;
  final double? buttonWidth;
  final int? spacerValue;
  final int? expandedValue;
  final double? extraSpace;
  final bool isButtonEnabled;
  final Function()? onClearSearch;


  const CommonTopRowWeb({
    Key? key,
    this.masterTitle,
    required this.searchController,
    this.onChanged,
    this.searchPlaceHolder,
    this.onExportTap,
    this.onImportTap,
    this.onCreateTap,
    this.isFilterRequired,
    this.menuItems,
    this.onDropDownTap,
    this.filterWidget,
    this.showImport = true,
    this.showExport = true,
    this.showSearchBar = true,
    this.buttonText,
    this.buttonHeight,
    this.buttonWidth,
    this.spacerValue,
    this.expandedValue,
    this.extraSpace,
    this.onClearSearch,
    this.isButtonEnabled = true,
  }) : super(key: key);

  @override
  Widget buildPage(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [

        /// Master title
        CommonText(
            title: masterTitle??'',
          textStyle: TextStyles.regular.copyWith(
            fontSize: 20.sp,
          ),
        ),
         Spacer(
          flex:spacerValue?? ((showImport == true)?2:4),
        ),

        extraSpace!=null?SizedBox(
          width: extraSpace,
        ): const Offstage(),
              Expanded(
                flex:expandedValue?? ((showImport == true && showExport == true) ? 8 : (showImport == false && showExport == true)? 6: 3),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    /// Search for the master
                    showSearchBar??true?CommonSearchBar(
                      controller: searchController,
                      onChanged: onChanged,
                      leftIcon: Assets.svgs.svgSearch.keyName,
                      borderColor: AppColors.clrD0D5DD,
                      clrSearchIcon: AppColors.clr687083,
                      cursorColor: AppColors.black,
                      textColor: AppColors.black,
                      placeholder: searchPlaceHolder??'',
                      hintStyle: TextStyles.regular.copyWith(fontSize: 14.sp, color: AppColors.black),
                      labelStyle: TextStyles.regular.copyWith(fontSize: 14.sp, color: AppColors.black),
                      width: context.width*0.18,
                      height:  context.height*0.063,
                      onClearSearch: onClearSearch,
                      rightIcon:Assets.svgs.svgClearSearch.keyName,
                    ):const Offstage(),

                    ///Filter
                    filterWidget ?? const Offstage(),

                    /// Import
                    showExport??true ? CommonExportWidget(onTap: onExportTap,):const Offstage(),

                    /// Export
                    showImport??true ? CommonImportWidget(onTap: onImportTap,) : const Offstage(),

                    /// Create Master
                    CommonButton(
                      buttonDisabledColor: AppColors.shimmerBaseColor,
                      buttonText: buttonText??LocaleKeys.keyCreate.localized,
                      onTap: onCreateTap,
                      width: buttonWidth??context.width*0.097,
                      height: buttonHeight??context.height*0.063,
                      buttonTextStyle: TextStyles.regular.copyWith(
                        fontSize: 16.sp,
                        color: AppColors.white,
                      ),
                      isButtonEnabled:isButtonEnabled,
                      buttonEnabledColor: AppColors.black,
                    )
                  ],
                ),
        ),
      ],
    );
  }
}
