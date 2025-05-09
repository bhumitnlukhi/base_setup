import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/ui/utils/helper/base_widget.dart';
import 'package:odigo_vendor/ui/utils/helper/image_picker_manager.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_image_selection_widget.dart';

class UploadDocumentListWidget extends ConsumerWidget with BaseConsumerWidget {
  final List<Uint8List?>? imageList;
  final Function(int index, Uint8List file)? onTap;
  final Function(int index)? onRemoveTap;
  final double? height;
  final double? width;
  final int? xRation;
  final int? yRatio;
  final bool isAds;

  const UploadDocumentListWidget({super.key, required this.imageList, required this.onTap, required this.onRemoveTap, this.height, this.width, this.xRation, this.yRatio, this.isAds = false});

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: height ?? context.height * 0.380,
      child: ListView.separated(
        itemCount: imageList?.length ?? 0,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return CommonImageSelectionWidget(
            width: width ?? context.width * 0.130,
            // height: height?? context.height * 0.200,
            onTap: () async {
              Uint8List? file = await ImagePickerManager.instance.openPicker(context, ratioX: xRation, ratioY: yRatio, isAds: isAds);
              if (file != null) {
                onTap!(index, file);
              }
            },
            pickedImage: imageList?[index],
            onRemovedTap: () async {
              onRemoveTap!(index);
              if (context.mounted) {
                Navigator.pop(context);
              }
            },
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(
            width: context.width * 0.018,
          );
        },
      ),
    );
  }
}
