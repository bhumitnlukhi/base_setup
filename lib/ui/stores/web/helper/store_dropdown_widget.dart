import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigo_vendor/framework/repository/store/model/store_list_response_model.dart';
import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/framework/utils/extension/string_extension.dart';
import 'package:odigo_vendor/ui/utils/helper/base_widget.dart';
import 'package:odigo_vendor/ui/utils/theme/app_strings.g.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_form_field_dropdown.dart';

class StoreDropdownWidget extends ConsumerWidget with BaseConsumerWidget {
  final List<StoreListData> storeList;
  final StoreListData? selectedStore;
  final void Function(StoreListData? value)? onChanged;

  const StoreDropdownWidget({
    super.key,
    required this.storeList,
    this.selectedStore,
    required this.onChanged,
  });

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: context.width * 0.12,
      child: CommonDropdownInputFormField<StoreListData?>(
        height: context.height * 0.04,
        defaultValue: selectedStore,
        menuItems: storeList,
        onChanged: onChanged,
        hintText: LocaleKeys.keySelectStore.localized,
        validator: (value) {
          if (value == null) {
            return LocaleKeys.keyStoreRequired.localized;
          } else {
            return null;
          }
        },
        selectedItemBuilder: (context) => List.generate(
          storeList.length,
          (index) => Align(
            alignment: Alignment.centerLeft,
            child: Text(
              storeList[index].name ?? '',
              maxLines: 2,
              style: TextStyles.regular.copyWith(fontSize: 18.sp, color: AppColors.black171717),
            ),
          ),
        ),
        itemListBuilder: List.generate(
          storeList.length,
          (index) => DropdownMenuItem<StoreListData?>(
            value: storeList[index],
            child: Text(
              storeList[index].name ?? '',
              maxLines: 2,
              style: TextStyles.regular.copyWith(fontSize: 18.sp, color: AppColors.black171717),
            ),
          ),
        ),
      ),
    );
  }
}
