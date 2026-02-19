import 'package:flutter/widgets.dart';

class PreloadImageHelper {
  String imageName;
  bool imageError;
  final VoidCallback? onUpdate;
  bool mounted;

  PreloadImageHelper({
    this.imageName = "",
    this.imageError = false,
    this.onUpdate,
    required this.mounted,
  });

  void preloadImage(String baseUrl) {
    if (imageName.isEmpty) {
      imageError = true;
      onUpdate?.call();
      return;
    }

    final Image image = Image.network(
      "$baseUrl/img/$imageName",
      fit: BoxFit.fitHeight,
    );

    image.image
        .resolve(ImageConfiguration())
        .addListener(
          ImageStreamListener(
            (ImageInfo info, bool synchronousCall) {
              if (mounted) {
                imageError = false;
                onUpdate?.call();
              }
            },
            onError: (dynamic exception, StackTrace? stackTrace) {
              if (mounted) {
                imageError = true;
                onUpdate?.call();
              }
            },
          ),
        );
  }

  bool get hasValidImage => imageName.isNotEmpty && !imageError;
}
