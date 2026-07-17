import 'file_service_mobile.dart'
    if (dart.library.html) 'file_service_web.dart';

class FileService {
  static Future<void> writeText(String fileName, String content) => writeTextImpl(fileName, content);

  static Future<String> readText(String fileName) => readTextImpl(fileName);

  static Future<void> appendText(String fileName, String content) => appendTextImpl(fileName, content);
}
