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

      if (await file.exists()) {
        if (await file.length() > 5000) {
          return filePath;
        } else {
          await file.delete();
        }
      }

      // قائمة السيرفرات المتوافقة مع أسماء القراء
      final List<String> candidateUrls = [
        'https://everyayah.com/data/$reciterFolder/$formattedSurahNum.mp3',
        'https://server8.mp3quran.net/$reciterFolder/$formattedSurahNum.mp3',
        'https://server11.mp3quran.net/$reciterFolder/$formattedSurahNum.mp3',
      ];

      for (String url in candidateUrls) {
        try {
          print('جاري محاولة التحميل من: $url');
          final response = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 15));
          if (response.statusCode == 200 && response.bodyBytes.length > 5000) {
            await file.writeAsBytes(response.bodyBytes);
            return filePath;
          }
        } catch (e) {
          print('فشل الرابط $url: $e');
        }
      }
    } catch (e) {
      print('خطأ في الخدمة: $e');
    }
    return null;
  }

  static Future<void> stop() async {
    await _player.stop();
  }
}
