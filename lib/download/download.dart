import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:timefly/net/DioInstance.dart';

showPicker(BuildContext context) {
  FocusScope.of(context).requestFocus(FocusNode());
  //底部弹出
  showModalBottomSheet(
      context: context,
      builder: (BuildContext con) => Container(
            height: 160,
            padding: EdgeInsets.all(20),
            color: Colors.white,
            child: Column(
              children: [createItem(true, "拍照"), createItem(false, "相册")],
            ),
          ));
}

//创建item
Widget createItem(bool state, String name) {
  return GestureDetector(
      onTap: () {
        openPicker(state);
      },
      child: ListTile(
        leading: Icon(state ? Icons.camera : Icons.image),
        title: Text(name),
      ));
}

openPicker(BuildContext context, bool state) async {
  Navigator.pop(context);
  var photo = await ImagePicker.pickImage(
      source: state ? ImageSource.camera : ImageSource.gallery);
  if (photo != null) {
    var imageCompressAndGetFile =
        await ImageCompressUtil.imageCompressAndGetFile(File(photo.path));

    var formData = FormData.fromMap(
        {'file': await MultipartFile.fromFile(imageCompressAndGetFile.path)});
    uploadFile(formData);
  }
}

uploadFile(formData) {
  HttpManager.getInstance().uploadImage(formData, (Map<String, dynamic> data) {
    if (data["code"] == 0) {
      String url = data["data"];
      switchOcrType(url);
      setState(() {
        imageUrl = url;
      });
    }
  });
}

class ImageCompressUtil {
  static Future<File> imageCompressAndGetFile(File file) async {
    if (file.lengthSync() < 200 * 1024) {
      return file;
    }
    var quality = 100;
    if (file.lengthSync() > 4 * 1024 * 1024) {
      quality = 50;
    } else if (file.lengthSync() > 2 * 1024 * 1024) {
      quality = 60;
    } else if (file.lengthSync() > 1 * 1024 * 1024) {
      quality = 70;
    } else if (file.lengthSync() > 0.5 * 1024 * 1024) {
      quality = 80;
    } else if (file.lengthSync() > 0.25 * 1024 * 1024) {
      quality = 90;
    }
    var dir = await getTemporaryDirectory();
    var targetPath = dir.absolute.path +
        "/" +
        DateTime.now().millisecondsSinceEpoch.toString() +
        ".jpg";

    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      minWidth: 600,
      quality: quality,
      rotate: 0,
    );

    return result;
  }
}
