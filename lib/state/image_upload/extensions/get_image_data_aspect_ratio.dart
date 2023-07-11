import 'dart:typed_data' show Uint8List;

import 'package:eight_night/state/image_upload/extensions/get_image_aspect_ratio.dart';
import 'package:flutter/material.dart' as material show Image;

extension GetImageDataAspectRatio on Uint8List {
  Future<double> getAspectRatio() {
    final image = material.Image.memory(this);
    return image.getAspectRatio();
  }
}
