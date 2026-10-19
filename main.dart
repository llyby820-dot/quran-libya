import 'package:flutter/material.dart';

void main() {
  runApp(const QuranApp());
}

class QuranApp extends StatefulWidget {
  const QuranApp({super.key});

  @override
  State<QuranApp> createState() => _QuranAppState();
}

class _QuranAppState extends State<QuranApp> {
  bool isDarkMode = false;
  int bookmarkedSurah = 1;

  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  void setBookmark(int surahNum) {
    setState(() {
      bookmarkedSurah = surahNum;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('تم حفظ الفاصلة عند السورة رقم $surahNum')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'مصحف الأوقاف الليبية',
      theme: ThemeData(
        brightness: isDarkMode ? Brightness.dark : Brightness.light,
        primaryColor: const Color(0xFF1B4D3E),
        scaffoldBackgroundColor: isDarkMode ? const Color(0xFF121212) : const Color(0xFFF7F5EC),
        appBarTheme: AppBarTheme(
          backgroundColor: isDarkMode ? const Color(0xFF1E1E1E) : const Color(0xFF1B4D3E),
          foregroundColor: Colors.white,
        ),
      ),
      home: SurahIndexScreen(
        isDarkMode: isDarkMode,
        onToggleTheme: toggleTheme,
        bookmarkedSurah: bookmarkedSurah,
        onSetBookmark: setBookmark,
      ),
    );
  }
}

class Surah {
  final int number;
  final String name;
  final String type;
  final int versesCount;

  Surah({
    required this.number,
    required this.name,
    required this.type,
    required this.versesCount,
  });
}

final List<Surah> quranSurahs = [
  Surah(number: 1, name: 'سُورَةُ الفَاتِحَةِ', type: 'مكية', versesCount: 7),
  Surah(number: 2, name: 'سُورَةُ البَقَرَةِ', type: 'مدنية', versesCount: 286),
  Surah(number: 3, name: 'سُورَةُ آلِ عِمْرَانَ', type: 'مدنية', versesCount: 200),
  Surah(number: 4, name: 'سُورَةُ النِّسَاءِ', type: 'مدنية', versesCount: 176),
  Surah(number: 5, name: 'سُورَةُ المَائِدَةِ', type: 'مدنية', versesCount: 120),
  Surah(number: 6, name: 'سُورَةُ الأَنْعَامِ', type: 'مكية', versesCount: 165),
  Surah(number: 7, name: 'سُورَةُ الأَعْرَافِ', type: 'مكية', versesCount: 206),
  Surah(number: 8, name: 'سُورَةُ الأَنْفَالِ', type: 'مدنية', versesCount: 75),
  Surah(number: 9, name: 'سُورَةُ التَّوَّبَةِ', type: 'مدنية', versesCount: 129),
  Surah(number: 10, name: 'سُورَةُ يُونُسَ', type: 'مكية', versesCount: 109),
  Surah(number: 11, name: 'سُورَةُ هُودٍ', type: 'مكية', versesCount: 123),
  Surah(number: 12, name: 'سُورَةُ يُوسُفَ', type: 'مكية', versesCount: 111),
  Surah(number: 13, name: 'سُورَةُ الرَّعْدِ', type: 'مدنية', versesCount: 43),
  Surah(number: 14, name: 'سُورَةُ إِبْرَاهِيمَ', type: 'مكية', versesCount: 52),
  Surah(number: 15, name: 'سُورَةُ الحِجْرِ', type: 'مكية', versesCount: 99),
  Surah(number: 16, name: 'سُورَةُ النَّحْلِ', type: 'مكية', versesCount: 128),
  Surah(number: 17, name: 'سُورَةُ الإِسْرَاءِ', type: 'مكية', versesCount: 111),
  Surah(number: 18, name: 'سُورَةُ الكَهْفِ', type: 'مكية', versesCount: 110),
  Surah(number: 19, name: 'سُورَةُ مَرْيَمَ', type: 'مكية', versesCount: 98),
  Surah(number: 20, name: 'سُورَةُ طٰهٰ', type: 'مكية', versesCount: 135),
  Surah(number: 21, name: 'سُورَةُ الأَنْبِيَاءِ', type: 'مكية', versesCount: 112),
  Surah(number: 22, name: 'سُورَةُ الحَجِّ', type: 'مدنية', versesCount: 78),
  Surah(number: 23, name: 'سُورَةُ المُؤْمِنُونَ', type: 'مكية', versesCount: 118),
  Surah(number: 24, name: 'سُورَةُ النُّورِ', type: 'مدنية', versesCount: 64),
  Surah(number: 25, name: 'سُورَةُ الفُرْقَانِ', type: 'مكية', versesCount: 77),
  Surah(number: 26, name: 'سُورَةُ الشُّعَرَاءِ', type: 'مكية', versesCount: 227),
  Surah(number: 27, name: 'سُورَةُ النَّمْلِ', type: 'مكية', versesCount: 93),
  Surah(number: 28, name: 'سُورَةُ القَصَصِ', type: 'مكية', versesCount: 88),
  Surah(number: 29, name: 'سُورَةُ العَنْكَبُوتِ', type: 'مكية', versesCount: 69),
  Surah(number: 30, name: 'سُورَةُ الرُّومِ', type: 'مكية', versesCount: 60),
  Surah(number: 31, name: 'سُورَةُ لُقْمَانَ', type: 'مكية', versesCount: 34),
  Surah(number: 32, name: 'سُورَةُ السَّجْدَةِ', type: 'مكية', versesCount: 30),
  Surah(number: 33, name: 'سُورَةُ الأَحْزَابِ', type: 'مدنية', versesCount: 73),
  Surah(number: 34, name: 'سُورَةُ سَبَإٍ', type: 'مكية', versesCount: 54),
  Surah(number: 35, name: 'سُورَةُ فَاطِرٍ', type: 'مكية', versesCount: 45),
  Surah(number: 36, name: 'سُورَةُ يٰسٓ', type: 'مكية', versesCount: 83),
  Surah(number: 37, name: 'سُورَةُ الصَّافَّاتِ', type: 'مكية', versesCount: 182),
  Surah(number: 38, name: 'سُورَةُ صٓ', type: 'مكية', versesCount: 88),
  Surah(number: 39, name: 'سُورَةُ الزُّمَرِ', type: 'مكية', versesCount: 75),
  Surah(number: 40, name: 'سُورَةُ غَافِرٍ', type: 'مكية', versesCount: 85),
  Surah(number: 41, name: 'سُورَةُ فُصِّلَتْ', type: 'مكية', versesCount: 54),
  Surah(number: 42, name: 'سُورَةُ الشُّورَىٰ', type: 'مكية', versesCount: 53),
  Surah(number: 43, name: 'سُورَةُ الزُّخْرُفِ', type: 'مكية', versesCount: 89),
  Surah(number: 44, name: 'سُورَةُ الدُّخَانِ', type: 'مكية', versesCount: 59),
  Surah(number: 45, name: 'سُورَةُ الجَاثِيَةِ', type: 'مكية', versesCount: 37),
  Surah(number: 46, name: 'سُورَةُ الأَحْقَافِ', type: 'مكية', versesCount: 35),
  Surah(number: 47, name: 'سُورَةُ مُحَمَّدٍ', type: 'مدنية', versesCount: 38),
  Surah(number: 48, name: 'سُورَةُ الفَتْحِ', type: 'مدنية', versesCount: 29),
  Surah(number: 49, name: 'سُورَةُ الحُجُرَاتِ', type: 'مدنية', versesCount: 18),
  Surah(number: 50, name: 'سُورَةُ قٓ', type: 'مكية', versesCount: 45),
  Surah(number: 51, name: 'سُورَةُ الذَّارِيَاتِ', type: 'مكية', versesCount: 60),
  Surah(number: 52, name: 'سُورَةُ الطُّورِ', type: 'مكية', versesCount: 49),
  Surah(number: 53, name: 'سُورَةُ النَّجْمِ', type: 'مكية', versesCount: 62),
  Surah(number: 54, name: 'سُورَةُ القَمَرِ', type: 'مكية', versesCount: 55),
  Surah(number: 55, name: 'سُورَةُ الرَّحْمٰنِ', type: 'مدنية', versesCount: 78),
  Surah(number: 56, name: 'سُورَةُ الوَاقِعَةِ', type: 'مكية', versesCount: 96),
  Surah(number: 57, name: 'سُورَةُ الحَدِيدِ', type: 'مدنية', versesCount: 29),
  Surah(number: 58, name: 'سُورَةُ المُجَادَلَةِ', type: 'مدنية', versesCount: 22),
  Surah(number: 59, name: 'سُورَةُ الحَشْرِ', type: 'مدنية', versesCount: 24),
  Surah(number: 60, name: 'سُورَةُ المُمْتَحَنَةِ', type: 'مدنية', versesCount: 13),
  Surah(number: 61, name: 'سُورَةُ الصَّفِّ', type: 'مدنية', versesCount: 14),
  Surah(number: 62, name: 'سُورَةُ الجُمُعَةِ', type: 'مدنية', versesCount: 11),
  Surah(number: 63, name: 'سُورَةُ المُنَافِقُونَ', type: 'مدنية', versesCount: 11),
  Surah(number: 64, name: 'سُورَةُ التَّغَابُنِ', type: 'مدنية', versesCount: 18),
  Surah(number: 65, name: 'سُورَةُ الطَّلاَقِ', type: 'مدنية', versesCount: 12),
  Surah(number: 66, name: 'سُورَةُ التَّحْرِيمِ', type: 'مدنية', versesCount: 12),
  Surah(number: 67, name: 'سُورَةُ المُلْكِ', type: 'مكية', versesCount: 30),
  Surah(number: 68, name: 'سُورَةُ القَلَمِ', type: 'مكية', versesCount: 52),
  Surah(number: 69, name: 'سُورَةُ الحَاقَّةِ', type: 'مكية', versesCount: 52),
  Surah(number: 70, name: 'سُورَةُ المَعَارِجِ', type: 'مكية', versesCount: 44),
  Surah(number: 71, name: 'سُورَةُ نُوحٍ', type: 'مكية', versesCount: 28),
  Surah(number: 72, name: 'سُورَةُ الجِنِّ', type: 'مكية', versesCount: 28),
  Surah(number: 73, name: 'سُورَةُ المُزَّمِّلِ', type: 'مكية', versesCount: 20),
  Surah(number: 74, name: 'سُورَةُ المُدَّثِّرِ', type: 'مكية', versesCount: 56),
  Surah(number: 75, name: 'سُورَةُ القِيَامَةِ', type: 'مكية', versesCount: 40),
  Surah(number: 76, name: 'سُورَةُ الإِنْسَانِ', type: 'مدنية', versesCount: 31),
  Surah(number: 77, name: 'سُورَةُ المُرْسَلاَتِ', type: 'مكية', versesCount: 50),
  Surah(number: 78, name: 'سُورَةُ النَّبَإِ', type: 'مكية', versesCount: 40),
  Surah(number: 79, name: 'سُورَةُ النَّازِعَاتِ', type: 'مكية', versesCount: 46),
  Surah(number: 80, name: 'سُورَةُ عَبَسَ', type: 'مكية', versesCount: 42),
  Surah(number: 81, name: 'سُورَةُ التَّكْوِيرِ', type: 'مكية', versesCount: 29),
  Surah(number: 82, name: 'سُورَةُ الإِنْفِطَارِ', type: 'مكية', versesCount: 19),
  Surah(number: 83, name: 'سُورَةُ المُطَفِّفِينَ', type: 'مكية', versesCount: 36),
  Surah(number: 84, name: 'سُورَةُ الإِنْشِقَاقِ', type: 'مكية', versesCount: 25),
  Surah(number: 85, name: 'سُورَةُ البُرُوجِ', type: 'مكية', versesCount: 22),
  Surah(number: 86, name: 'سُورَةُ الطَّارِقِ', type: 'مكية', versesCount: 17),
  Surah(number: 87, name: 'سُورَةُ الأَعْلَىٰ', type: 'مكية', versesCount: 19),
  Surah(number: 88, name: 'سُورَةُ الغَاشِيَةِ', type: 'مكية', versesCount: 26),
  Surah(number: 89, name: 'سُورَةُ الفَجْرِ', type: 'مكية', versesCount: 30),
  Surah(number: 90, name: 'سُورَةُ البَلَدِ', type: 'مكية', versesCount: 20),
  Surah(number: 91, name: 'سُورَةُ الشَّمْسِ', type: 'مكية', versesCount: 15),
  Surah(number: 92, name: 'سُورَةُ اللَّيْلِ', type: 'مكية', versesCount: 21),
  Surah(number: 93, name: 'سُورَةُ الضُّحَىٰ', type: 'مكية', versesCount: 11),
  Surah(number: 94, name: 'سُورَةُ الشَّرْحِ', type: 'مكية', versesCount: 8),
  Surah(number: 95, name: 'سُورَةُ التِّينِ', type: 'مكية', versesCount: 8),
  Surah(number: 96, name: 'سُورَةُ العَلَقِ', type: 'مكية', versesCount: 19),
  Surah(number: 97, name: 'سُورَةُ القَدْرِ', type: 'مكية', versesCount: 5),
  Surah(number: 98, name: 'سُورَةُ البَيِّنَةِ', type: 'مدنية', versesCount: 8),
  Surah(number: 99, name: 'سُورَةُ الزَّلْزَلَةِ', type: 'مدنية', versesCount: 8),
  Surah(number: 100, name: 'سُورَةُ العَادِيَاتِ', type: 'مكية', versesCount: 11),
  Surah(number: 101, name: 'سُورَةُ القَارِعَةِ', type: 'مكية', versesCount: 11),
  Surah(number: 102, name: 'سُورَةُ التَّكَاثُرِ', type: 'مكية', versesCount: 8),
  Surah(number: 103, name: 'سُورَةُ العَصْرِ', type: 'مكية', versesCount: 3),
  Surah(number: 104, name: 'سُورَةُ الهُمَزَةِ', type: 'مكية', versesCount: 9),
  Surah(number: 105, name: 'سُورَةُ الفِيلِ', type: 'مكية', versesCount: 5),
  Surah(number: 106, name: 'سُورَةُ قُرَيْشٍ', type: 'مكية', versesCount: 4),
  Surah(number: 107, name: 'سُورَةُ المَاعُونِ', type: 'مكية', versesCount: 7),
  Surah(number: 108, name: 'سُورَةُ الكَوْثَرِ', type: 'مكية', versesCount: 3),
  Surah(number: 109, name: 'سُورَةُ الكَافِرُونَ', type: 'مكية', versesCount: 6),
  Surah(number: 110, name: 'سُورَةُ النَّصْرِ', type: 'مدنية', versesCount: 3),
  Surah(number: 111, name: 'سُورَةُ المَسَدِ', type: 'مكية', versesCount: 5),
  Surah(number: 112, name: 'سُورَةُ الإِخْلاَصِ', type: 'مكية', versesCount: 4),
  Surah(number: 113, name: 'سُورَةُ الفَلَقِ', type: 'مكية', versesCount: 5),
  Surah(number: 114, name: 'سُورَةُ النَّاسِ', type: 'مكية', versesCount: 6),
];

class SurahIndexScreen extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onToggleTheme;
  final int bookmarkedSurah;
  final Function(int) onSetBookmark;

  const SurahIndexScreen({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
    required this.bookmarkedSurah,
    required this.onSetBookmark,
  });

  @override
  State<SurahIndexScreen> createState() => _SurahIndexScreenState();
}

class _SurahIndexScreenState extends State<SurahIndexScreen> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final filteredSurahs = quranSurahs.where((surah) {
      return surah.name.contains(searchQuery) ||
          surah.number.toString() == searchQuery;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('مصحف الأوقاف الليبية (قالون)'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(widget.isDarkMode ? Icons.wb_sunny : Icons.nightlight_round),
            onPressed: widget.onToggleTheme,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              onChanged: (val) {
                setState(() {
                  searchQuery = val;
                });
              },
              decoration: InputDecoration(
                hintText: '... ابحث عن اسم السورة أو رقمها',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: widget.isDarkMode ? Colors.grey[850] : Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredSurahs.length,
              itemBuilder: (context, index) {
                final surah = filteredSurahs[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  elevation: 0,
                  color: widget.isDarkMode ? Colors.grey[900] : Colors.white,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: const Color(0xFF1B4D3E),
                      child: Text(
                        '${surah.number}',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    title: Text(
                      surah.name,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('${surah.type} - آياتها ${surah.versesCount}'),
                    trailing: IconButton(
                      icon: Icon(
                        widget.bookmarkedSurah == surah.number
                            ? Icons.bookmark
                            : Icons.bookmark_outline,
                        color: const Color(0xFF1B4D3E),
                      ),
                      onPressed: () => widget.onSetBookmark(surah.number),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SurahDetailView(
                            surah: surah,
                            isDarkMode: widget.isDarkMode,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class SurahDetailView extends StatelessWidget {
  final Surah surah;
  final bool isDarkMode;

  const SurahDetailView({
    super.key,
    required this.surah,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(surah.name),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        itemCount: 150, // أقصى عدد أجزاء متوقع للسورة
        itemBuilder: (context, index) {
          int partNumber = index + 1;

          // تحديد اسم صورة العنوان بالوضع الداكن أو باقي الأجزاء العادية
          String imageName = (isDarkMode && partNumber == 4)
              ? 'assets/${surah.number}.${partNumber}_dark.png'
              : 'assets/${surah.number}.$partNumber.png';

          return Image.asset(
            imageName,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              // تتوقف القائمة آلياً وبشكل مخفي عند عدم وجود أجزاء إضافية
              return const SizedBox.shrink();
            },
          );
        },
      ),
    );
  }
}
