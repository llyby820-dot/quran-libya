import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';

class AudioService {
  static final AudioPlayer _player = AudioPlayer();
  
  // دالة لفحص ما إذا كانت السورة محملة مسبقاً، وإذا لم تكن يتم تحميلها وتخزينها محلياً
  static Future<String?> getAudioFilePath(String surahNumber, String reciterId) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      // إنشاء مجلد خاص بالصوتيات داخل ذاكرة التطبيق الداخلية
      final folderPath = Directory('${directory.path}/quran_audio/$reciterId');
      if (!await folderPath.exists()) {
        await folderPath.create(recursive: true);
      }

      final filePath = '${folderPath.path}/surah_$surahNumber.mp3';
      final file = File(filePath);

      // إذا كان الملف موجوداً محلياً، نرجع مساره مباشرة للتشغيل بدون إنترنت
      if (await file.exists()) {
        return filePath;
      }

      // إذا لم يكن موجوداً، نقوم بتحميله من السيرفر المعتمد (مثال: سيرفر mp3quran أو سيرفرك الخاص)
      // ملاحظة: يمكنك تغيير رابط السيرفر الأساسي حسب القارئ
      final audioUrl = 'https://server8.mp3quran.net/afs/${surahNumber.padLeft(3, '0')}.mp3';
      
      final response = await http.get(Uri.parse(audioUrl));
      if (response.statusCode == 200) {
        await file.writeAsBytes(response.bodyBytes);
        return filePath;
      }
    } catch (e) {
      print('خطأ في تحميل أو تشغيل الملف الصوتي: $e');
    }
    return null;
  }

  // دالة لتشغيل السورة محلياً
  static Future<void> playSurah(String surahNumber, String reciterId) async {
    String? localPath = await getAudioFilePath(surahNumber, reciterId);
    if (localPath != null) {
      await _player.setFilePath(localPath);
      await _player.play();
    }
  }

  // إيقاف مؤقت أو كامل
  static Future<void> stop() async {
    await _player.stop();
  }
}
