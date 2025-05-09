import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigo_vendor/framework/controller/ads/add_edit_ads_controller.dart';
import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/ui/ads/web/helper/common_radio_widget.dart';
import 'package:odigo_vendor/ui/utils/helper/base_widget.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';

class ImageCountRadioWidget extends ConsumerStatefulWidget {
  const ImageCountRadioWidget({super.key});

  @override
  ConsumerState<ImageCountRadioWidget> createState() => _ImageSizeRadioWidgetState();
}

class _ImageSizeRadioWidgetState extends ConsumerState<ImageCountRadioWidget>with BaseConsumerStatefulWidget {
  ///Build
  @override
  Widget buildPage(BuildContext context) {
    final addEditAdsWatch = ref.watch(addEditAdsController);
    return SizedBox(
      height: context.height * 0.03,
      child: ListView.separated(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: addEditAdsWatch.imageSizeCount.length,
          itemBuilder: (context, index) {
            var value = addEditAdsWatch.imageSizeCount[index];
            return CommonRadioWidget(
                name: value.toString(),
                isSelect: value == addEditAdsWatch.selectedImageCount,
                onTap: () {
                  addEditAdsWatch.onRadioSelectedImageCount(value);
                });
          }, separatorBuilder: (BuildContext context, int index) {
            return SizedBox(width: context.width * 0.01);
      },),
    );
  }
}
