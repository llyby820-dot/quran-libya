import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';

class AudioService {
  static final AudioPlayer _player = AudioPlayer();

  // الحصول على ملف الصوت للسورة محلياً أو تحميله من السيرفر المعتمد
  static Future<String?> getAudioFilePath(String surahNumber, String reciterFolder) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final folderPath = Directory('${directory.path}/quran_audio/$reciterFolder');
      
      if (!await folderPath.exists()) {
        await folderPath.create(recursive: true);
      }

      // توحيد اسم الملف برقم السورة (مثال: 001.mp3)
      String formattedSurahNum = surahNumber.padLeft(3, '0');
      final filePath = '${folderPath.path}/surah_$formattedSurahNum.mp3';
      final file = File(filePath);

      // إذا كان الملف مخزناً مسبقاً في الهاتف، يتم تشغيله فورا بدون إنترنت
      if (await file.exists()) {
        return filePath;
      }

      // رابط السيرفر المباشر والمستقر لجميع القراء (mp3quran)
      final audioUrl = 'https://server8.mp3quran.net/$reciterFolder/$formattedSurahNum.mp3';

      print('جاري تحميل الصوت من: $audioUrl');
      final response = await http.get(Uri.parse(audioUrl));
      
      if (response.statusCode == 200) {
        await file.writeAsBytes(response.bodyBytes);
        return filePath;
      } else {
        print('خطأ في الاتصال بالسيرفر: ${response.statusCode}');
      }
    } catch (e) {
      print('خطأ في التحميل المحلي: $e');
    }
    return null;
  }

  static Future<void> playAudio(String surahNumber, String reciterFolder) async {
    try {
      String? localPath = await getAudioFilePath(surahNumber, reciterFolder);
      if (localPath != null) {
        await _player.setFilePath(localPath);
        await _player.play();
      }
    } catch (e) {
      print('خطأ أثناء تشغيل الصوت: $e');
    }
  }

  static Future<void> stop() async {
    await _player.stop();
  }
}
