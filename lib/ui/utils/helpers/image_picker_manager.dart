import 'dart:io';
import 'package:flutter_base_setup/framework/utility/extension/string_extension.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:flutter_base_setup/ui/utils/theme/theme.dart';

/*
Required permissions for iOS
NSCameraUsageDescription :- ${PRODUCT_NAME} is require camera permission to choose user profile photo.
NSPhotoLibraryUsageDescription :- ${PRODUCT_NAME} is require photos permission to choose user profile photo.

Required permissions for Android
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.CAMERA"/>

<!--Image Cropper-->
       <activity
           android:name="com.yalantis.ucrop.UCropActivity"
           android:exported="true"
           android:screenOrientation="portrait"
           android:theme="@style/Theme.AppCompat.Light.NoActionBar"/>
* */

class ImagePickerManager {
  ImagePickerManager._privateConstructor();
  static final ImagePickerManager instance = ImagePickerManager._privateConstructor();

  var imgSelectOption = {'camera', 'gallery', 'document'};

  /*
  Open Picker
  Usage:- File? file = await ImagePickerManager.instance.openPicker(context);
  * */
  Future<File?> openPicker(BuildContext context, {String? title, double? ratioX, double? ratioY}) async {
    String type = '';
    await showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        barrierColor: AppColors.black.withOpacity(0.3),
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (context, state) {
                return Container(
                  color: AppColors.transparent,
                  padding: EdgeInsets.only(left: 29.w, right: 29.w),
                  height: 280.h,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(10.r)
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 20.h, bottom: 5.h),
                              child: Text(
                                title ?? ''.localized,
                                maxLines: 2,
                                style: TextStyles.medium.copyWith(fontSize: 18.sp),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                                type = imgSelectOption.elementAt(0);
                              },
                              child: Container(
                                padding: EdgeInsets.only(top: 30.h, bottom: 15.h),
                                alignment: Alignment.center,
                                child: Text(
                                  'Key_PhotoFromCamera'.localized,
                                  style: TextStyles.medium.copyWith(color: AppColors.blue),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 20.w, right: 20.w),
                              child: const Divider(height: 1, color: AppColors.greyCFCFCF,),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                                type = imgSelectOption.elementAt(1);
                              },
                              child: Container(
                                padding: EdgeInsets.only(top: 15.h, bottom: 30.h),
                                alignment: Alignment.center,
                                child: Text(
                                  'Key_PhotoFromGallery'.localized,
                                  style: TextStyles.medium.copyWith(color: AppColors.blue),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 10.h),
                      InkWell(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: double.infinity,
                          height: 50.h,
                          decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(10.r)
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Key_Cancel'.localized,
                            style: TextStyles.semiBold.copyWith(color: AppColors.red),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
          );
        }
    );

    File? croppedFile;
    if(type.isNotEmpty){
      XFile? fileProfile = (await ImagePicker().pickImage(source: (imgSelectOption.elementAt(0) == type) ? ImageSource.camera : ImageSource.gallery));
      
      print('fileProfile: $fileProfile');

      if(fileProfile != null && fileProfile.path != '') {
        CroppedFile? cropImage = (await ImageCropper().cropImage(
          sourcePath: fileProfile.path,
          aspectRatio: CropAspectRatio(ratioX: ratioX ?? 1, ratioY: ratioY ?? 1),
        ));

        if(cropImage != null && cropImage.path != '') {
          croppedFile = File(cropImage.path);
        }
      }
    }
    return croppedFile;
  }

  /*
  Open Multi Picker
  Usage:- Future<List<File>?> files = ImagePickerManager.instance.openMultiPicker(context);
  * */
  Future<List<File>?> openMultiPicker(BuildContext context, {int maxAssets = 3}) async {
    final List<AssetEntity>? result = await AssetPicker.pickAssets(
      context,
      pickerConfig: AssetPickerConfig(
        maxAssets: maxAssets,
        themeColor: AppColors.primary,
        requestType: RequestType.image,
      ),
    );

    List<File> files = [];
    if((result ?? []).isNotEmpty){
      for (final AssetEntity entity in result!){
        final File? file = await entity.file;
        files.add(file!);
      }
    }
    return files;
  }

  ///Handle Document After Picker
  // handleDocumentAfterPicker(BuildContext context, Function(List<File>) resultBlock) async {
  //   List<File> files = [];
  //   FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true,type: FileType.custom, allowedExtensions: ['pdf', 'doc', 'docx'],);
  //
  //   if(result != null) {
  //     // files = result.paths.map((path) => PickedFile(path ?? "")).toList();
  //     files = result.paths.map((path) => File(path ?? "")).toList();
  //   }
  //   resultBlock(files);
  // }




}
