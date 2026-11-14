import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';

class AudioService {
  static final AudioPlayer _player = AudioPlayer();

  // دالة لجلب مسار الصوت أو تحميله وتخزينه محلياً
  static Future<String?> getAudioFilePath(int surahNumber, String reciterFolder) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final folderPath = Directory('${directory.path}/quran_audio/$reciterFolder');
      
      if (!await folderPath.exists()) {
        await folderPath.create(recursive: true);
      }

      // تنسيق رقم الملف ليتطابق مع السيرفر بدون أصفار يسارية (مثال: 1.mp3, 36.mp3, 114.mp3)
      final filePath = '${folderPath.path}/surah_$surahNumber.mp3';
      final file = File(filePath);

      // إذا كان الملف موجوداً محلياً، يتم تشغيله فورا بدون إنترنت
      if (await file.exists()) {
        return filePath;
      }

      // رابط السيرفر المحدث والمطابق لرقم السورة المباشر
      final audioUrl = 'https://everyayah.com/data/$reciterFolder/$surahNumber.mp3';

      print('جاري التحميل من: $audioUrl');
      final response = await http.get(Uri.parse(audioUrl));
      
      if (response.statusCode == 200) {
        await file.writeAsBytes(response.bodyBytes);
        return filePath;
      } else {
        print('فشل التحميل من السيرفر، الرمز: ${response.statusCode}');
      }
    } catch (e) {
      print('خطأ في الاتصال: $e');
    }
    return null;
  }

  // دالة التشغيل
  static Future<void> playSurahAudio(int surahNumber, String reciterFolder) async {
    try {
      String? localPath = await getAudioFilePath(surahNumber, reciterFolder);
      if (localPath != null) {
        await _player.setFilePath(localPath);
        await _player.play();
      }
    } catch (e) {
      print('خطأ في المشغل: $e');
    }
  }

  static Future<void> stop() async {
    await _player.stop();
  }
}
