import 'package:just_audio/just_audio.dart';

class AudioService {
  static final AudioPlayer _player = AudioPlayer();

  static Future<void> playSurahAudio(int surahNumber, String reciterFolder) async {
    try {
      // تنسيق رقم السورة بثلاثة أرقام (مثل 001، 002)
      String formattedSurahNum = surahNumber.toString().padLeft(3, '0');
      
      // استخدام سيرفر EveryAyah المتوافق تماماً مع أسماء مجلدات القراء في التطبيق
      final audioUrl = 'https://everyayah.com/data/$reciterFolder/$formattedSurahNum.mp3';
      
      print('جاري تشغيل الصوت من: $audioUrl');
      
      await _player.setUrl(audioUrl);
      await _player.play();
    } catch (e) {
      print('خطأ في تشغيل الصوت: $e');
      rethrow;
    }
  }

  static Future<void> stop() async {
    await _player.stop();
  }
}
