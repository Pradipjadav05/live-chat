import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class MediaService {
  // used to get image from gallery
  static Future<Uint8List?> pickImage() async {
    try {
      final imagePicker = ImagePicker();
      final file = await imagePicker.pickImage(source: ImageSource.gallery);
      if (file != null) {
        return await file.readAsBytes();
      }
    } on PlatformException catch (e) {
      debugPrint('Failed to pick image: $e');
    }
    return null;
  }
}
