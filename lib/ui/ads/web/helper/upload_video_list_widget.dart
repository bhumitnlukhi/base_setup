import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigo_vendor/framework/controller/ads/add_edit_ads_controller.dart';
import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/framework/utils/extension/string_extension.dart';
import 'package:odigo_vendor/ui/ads/web/helper/common_video_selection_widget.dart';
import 'package:odigo_vendor/ui/ads/web/helper/video_images_combine_demo_one_controller.dart';
import 'package:odigo_vendor/ui/utils/const/app_constants.dart';
import 'package:odigo_vendor/ui/utils/helper/base_widget.dart';
import 'package:odigo_vendor/ui/utils/theme/app_strings.g.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_dialogs.dart';
import 'package:path/path.dart' as path;

class UploadVideoListWidget extends ConsumerWidget with BaseConsumerWidget {
  const UploadVideoListWidget({super.key});

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) {
    final addEditAdsWatch = ref.watch(addEditAdsController);
    return SizedBox(
      height: context.height * 0.450,
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: addEditAdsWatch.videoFileList.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return CommonVideoSelectionWidget(
            thumbnailImage: addEditAdsWatch.thumbnailFileList[index],
            onTap: () async {
              // final XFile? results = await ImagePicker().pickVideo(source: ImageSource.gallery);
              // if(results != null){
              //   File file = File(results.path);
              //   addEditAdsWatch.initVideoPlayerController(file, context,index);
              // }

              showLog("FilePickerResult >> INSIDE FILE PICKER BY MOHIT test");
              FilePickerResult? result = await FilePicker.platform.pickFiles(
                type: FileType.custom,
                allowedExtensions: ['mp4', 'avi', 'mov', 'mkv', 'flv', 'webm', 'mpeg', 'mpg', 'ogv'], // Filter video files
              );

              if (result != null && result.files.isNotEmpty) {
                File file = File(result.files.first.xFile.path);
                String fileExt = path.extension(result.files.first.xFile.name).trim().toLowerCase();
                if(!(videoExtensions.contains(fileExt))){
                  if(context.mounted){
                    showCommonErrorDialogNew(
                        context: context,
                        message:
                            '${LocaleKeys.keyVideoExtensionValidationMsg.localized} \n ${videoExtensions.join(', ')}');
                  }
                } else{
                  if(context.mounted){
                    addEditAdsWatch.initVideoPlayerController(
                        file, context, index);
                  }
                }

              }
            },
            onThumbnailImageTap: () {
              showCommonWebDialog(
                context: context,
                // width: context.width * 0.5,
                keyBadge: addEditAdsWatch.combineWithSignleDialogKey,
                height: 0.6,
                width: 0.6,
                barrierDismissible: false,
                dialogBody: VideoImageCombineDemoWithSingleController(
                  videoUrl: addEditAdsWatch.videoFileList[index]?.path ?? '',
                ),
              );
            },
            onRemovedTap: () {
              addEditAdsWatch.removeVideo(index);
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
