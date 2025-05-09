import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigo_vendor/framework/repository/package/model/destination_list_response_model.dart';
import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/framework/utils/extension/string_extension.dart';
import 'package:odigo_vendor/ui/utils/helper/base_widget.dart';
import 'package:odigo_vendor/ui/utils/theme/app_strings.g.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_form_field_dropdown.dart';

class DestinationDropdownWidget extends ConsumerWidget with BaseConsumerWidget {
  final List<DestinationData?> destinationList;
  final DestinationData? selectedDestination;
  final void Function(DestinationData? value)? onChanged;

  const DestinationDropdownWidget({
    super.key,
    required this.destinationList,
    this.selectedDestination,
    required this.onChanged,
  });

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: context.width * 0.12,
      child: CommonDropdownInputFormField<DestinationData?>(
        height: context.height * 0.04,
        defaultValue: selectedDestination,
        menuItems: destinationList,
        onChanged: onChanged,
        hintText: LocaleKeys.keySelectDestination.localized,
        validator: (value) {
          if (value == null) {
            return LocaleKeys.keyDestinationRequired.localized;
          } else {
            return null;
          }
        },
        selectedItemBuilder: (context) => List.generate(
          destinationList.length,
          (index) => Align(
            alignment: Alignment.centerLeft,
            child: Text(
              destinationList[index]?.name ?? '',
              maxLines: 2,
              style: TextStyles.regular.copyWith(fontSize: 16.sp, color: AppColors.black171717),
            ),
          ),
        ),
        itemListBuilder: List.generate(
          destinationList.length,
          (index) => DropdownMenuItem<DestinationData?>(
            value: destinationList[index],
            child: Text(
              destinationList[index]?.name ?? '',
              maxLines: 2,
              style: TextStyles.regular.copyWith(fontSize: 18.sp, color: AppColors.black171717),
            ),
          ),
        ),
      ),
    );
  }
}
