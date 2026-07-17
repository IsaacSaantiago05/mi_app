import 'dart:io';
import 'package:path_provider/path_provider.dart';

Future<void> writeTextImpl(String fileName, String content) async {
  final dir = await getApplicationDocumentsDirectory();
  final file = File('${dir.path}/$fileName');
  await file.writeAsString(content, flush: true);
}

Future<String> readTextImpl(String fileName) async {
  try {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$fileName');
    if (!await file.exists()) return '';
    return await file.readAsString();
  } catch (e) {
    return '';
  }
}

Future<void> appendTextImpl(String fileName, String content) async {
  final dir = await getApplicationDocumentsDirectory();
  final file = File('${dir.path}/$fileName');
  await file.writeAsString(content, mode: FileMode.append, flush: true);
}
