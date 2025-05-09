import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:odigo_vendor/ui/utils/const/app_constants.dart';
import 'package:path_provider/path_provider.dart';

///---------Use-------------///
///
/// var storeImage = await FileDownloadManager.instance.downloadImage(image.toString(), "${generateFileName()}.jpg");
///
/// ..................
class FileDownloadManager {
  FileDownloadManager._privateConstructor();
  static final FileDownloadManager instance =
  FileDownloadManager._privateConstructor();

  Directory? directory;
  late String filePathAndName;
  String imageDirectoryName = '/images/old';
  File? imageFile;
  Future<File?> downloadImage(String imgUrl, String nameWithExt) async {
    showLog('downloadImage imgUrl : $imgUrl');
    // var response = await get(imgUrl);
    var response = await http.get(Uri.parse(imgUrl));
    directory = await getApplicationDocumentsDirectory();
    var firstPath = directory!.path + imageDirectoryName;
    filePathAndName = '${directory!.path}$imageDirectoryName/$nameWithExt';
    await Directory(firstPath).create(recursive: true);
    File file2 = File(filePathAndName);
    file2.writeAsBytesSync(response.bodyBytes);
    showLog('downloadImage file imgUrl : $filePathAndName');
    showLog('--->1 : ${directory!.path}');
    showLog('--->2: ${directory!.absolute.path}');

    showLog('converted file image :- $filePathAndName');
    imageFile = File(filePathAndName);
    showLog('File Object From Downloaded File - $imageFile');

    return imageFile;
  }
}
