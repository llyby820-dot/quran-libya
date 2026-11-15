import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';

class AudioService {
  static final AudioPlayer _player = AudioPlayer();

  static Future<String?> getAudioFilePath(int surahNumber, String reciterFolder) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final folderPath = Directory('${directory.path}/quran_audio/$reciterFolder');
      
      if (!await folderPath.exists()) {
        await folderPath.create(recursive: true);
      }

      final filePath = '${folderPath.path}/surah_$surahNumber.mp3';
      final file = File(filePath);

      if (await file.exists()) {
        return filePath;
      }

      final audioUrl = 'https://everyayah.com/data/$reciterFolder/$surahNumber.mp3';
      
      final response = await http.get(Uri.parse(audioUrl));
      
      if (response.statusCode == 200) {
        await file.writeAsBytes(response.bodyBytes);
        return filePath;
      } else {
        // رمي خطأ برمز الاستجابة لنعرف السبب بالضبط
        throw 'خطأ السيرفر: ${response.statusCode} (تأكد من اسم المجلد: $reciterFolder)';
      }
    } catch (e) {
      throw 'فشل التحميل: $e';
    }
  }

  static Future<void> playSurahAudio(int surahNumber, String reciterFolder) async {
    try {
      String? localPath = await getAudioFilePath(surahNumber, reciterFolder);
      if (localPath != null) {
        await _player.setFilePath(localPath);
        await _player.play();
      }
    } catch (e) {
      rethrow; // إعادة إرسال الخطأ لواجهة التطبيق ليظهر للمستخدم
    }
  }

  static Future<void> stop() async {
    await _player.stop();
  }
}
