import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

/// A picked photo: its bytes and a file name for the upload.
typedef PickedImage = ({Uint8List bytes, String name});

/// Opens the photo gallery (FR-CKE-04; receipts in S6). Behind a provider so
/// widget tests can return a photo without a device.
final imagePickerProvider = Provider<Future<PickedImage?> Function()>(
  (ref) => () async {
    final file = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 2000,
      imageQuality: 85,
    );
    if (file == null) return null;
    return (bytes: await file.readAsBytes(), name: file.name);
  },
);
