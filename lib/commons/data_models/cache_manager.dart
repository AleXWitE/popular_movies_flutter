import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:popular_films/commons/api/services/modal_services.dart';

class CacheManager {

  final defaultCacheManager = DefaultCacheManager();

  Future<String> cacheImage(String imagePath) async {


    // Check if the image file is not in the cache
    if ((await defaultCacheManager.getFileFromCache(imagePath))?.file == null) {
      // Download your image data
      final imageBytes = await getImageBytes(imagePath);

      await defaultCacheManager.putFile(
        imagePath,
        imageBytes,
        fileExtension: "jpg",
      );
    }
    // Return image download url
    return imagePath;
  }
}