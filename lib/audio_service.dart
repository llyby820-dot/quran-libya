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

      String formattedSurahNum = surahNumber.toString().padLeft(3, '0');
      final filePath = '${folderPath.path}/surah_$formattedSurahNum.mp3';
      final file = File(filePath);

      // إذا كان الملف مخزناً محلياً مسبقاً
      if (await file.exists()) {
        if (await file.length() > 1000) { // التأكد من أن الملف سليم وليس فارغاً
          return filePath;
        } else {
          await file.delete(); // حذف الملف التالف إن وجد
        }
      }

      // تجربة السيرفر الأول (mp3quran)
      List<String> urls = [
        'https://server8.mp3quran.net/$reciterFolder/$formattedSurahNum.mp3',
        'https://everyayah.com/data/$reciterFolder/$surahNumber.mp3',
      ];

      for (String audioUrl in urls) {
        try {
          print('محاولة التحميل من: $audioUrl');
          final response = await http.get(Uri.parse(audioUrl));
          
          if (response.statusCode == 200 && response.bodyBytes.isNotEmpty) {
            await file.writeAsBytes(response.bodyBytes);
            return filePath;
          }
        } catch (e) {
          print('فشل الرابط $audioUrl بسبب: $e');
        }
      }
    } catch (e) {
      print('خطأ عام في التخزين المؤقت: $e');
    }
    return null;
  }

  static Future<void> playSurahAudio(int surahNumber, String reciterFolder) async {
    try {
      String? localPath = await getAudioFilePath(surahNumber, reciterFolder);
      if (localPath != null) {
        await _player.setFilePath(localPath);
        await _player.play();
      } else {
        throw Exception("ملف الصوت غير متوفر");
      }
    } catch (e) {
      print('خطأ المشغل النهائي: $e');
      rethrow;
    }
  }

  static Future<void> stop() async {
    await _player.stop();
  }
}
