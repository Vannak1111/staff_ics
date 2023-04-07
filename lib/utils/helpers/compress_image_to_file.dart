  import 'dart:convert';
import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';

Future<String> compressAndGetFile(File file) async {
    final dir = Directory.systemTemp;
    final targetPath = dir.absolute.path + "/temp.jpg";
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 40,
    );
    var base64img = base64Encode(result!.readAsBytesSync());
    return base64img;
  }