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
  int bookmarkedPage = 1;

  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  void setBookmark(int page) {
    setState(() {
      bookmarkedPage = page;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('تم حفظ الفاصلة عند صفحة $page')),
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
        bookmarkedPage: bookmarkedPage,
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
  final int startPage;

  Surah({
    required this.number,
    required this.name,
    required this.type,
    required this.versesCount,
    required this.startPage,
  });
}

final List<Surah> quranSurahs = [
  Surah(number: 1, name: 'سُورَةُ الفَاتِحَةِ', type: 'مكية', versesCount: 7, startPage: 1),
  Surah(number: 2, name: 'سُورَةُ البَقَرَةِ', type: 'مدنية', versesCount: 286, startPage: 2),
  Surah(number: 3, name: 'سُورَةُ آلِ عِمْرَانَ', type: 'مدنية', versesCount: 200, startPage: 50),
  Surah(number: 4, name: 'سُورَةُ النِّسَاءِ', type: 'مدنية', versesCount: 176, startPage: 77),
  Surah(number: 5, name: 'سُورَةُ المَائِدَةِ', type: 'مدنية', versesCount: 120, startPage: 106),
  Surah(number: 6, name: 'سُورَةُ الأَنْعَامِ', type: 'مكية', versesCount: 165, startPage: 128),
  Surah(number: 7, name: 'سُورَةُ الأَعْرَافِ', type: 'مكية', versesCount: 206, startPage: 151),
  Surah(number: 8, name: 'سُورَةُ الأَنْفَالِ', type: 'مدنية', versesCount: 75, startPage: 177),
  Surah(number: 9, name: 'سُورَةُ التَّوَّبَةِ', type: 'مدنية', versesCount: 129, startPage: 187),
  Surah(number: 10, name: 'سُورَةُ يُونُسَ', type: 'مكية', versesCount: 109, startPage: 208),
  Surah(number: 11, name: 'سُورَةُ هُودٍ', type: 'مكية', versesCount: 123, startPage: 221),
  Surah(number: 12, name: 'سُورَةُ يُوسُفَ', type: 'مكية', versesCount: 111, startPage: 235),
  Surah(number: 13, name: 'سُورَةُ الرَّعْدِ', type: 'مدنية', versesCount: 43, startPage: 249),
  Surah(number: 14, name: 'سُورَةُ إِبْرَاهِيمَ', type: 'مكية', versesCount: 52, startPage: 255),
  Surah(number: 15, name: 'سُورَةُ الحِجْرِ', type: 'مكية', versesCount: 99, startPage: 262),
  Surah(number: 16, name: 'سُورَةُ النَّحْلِ', type: 'مكية', versesCount: 128, startPage: 267),
  Surah(number: 17, name: 'سُورَةُ الإِسْرَاءِ', type: 'مكية', versesCount: 111, startPage: 282),
  Surah(number: 18, name: 'سُورَةُ الكَهْفِ', type: 'مكية', versesCount: 110, startPage: 293),
  Surah(number: 19, name: 'سُورَةُ مَرْيَمَ', type: 'مكية', versesCount: 98, startPage: 305),
  Surah(number: 20, name: 'سُورَةُ طٰهٰ', type: 'مكية', versesCount: 135, startPage: 312),
  Surah(number: 21, name: 'سُورَةُ الأَنْبِيَاءِ', type: 'مكية', versesCount: 112, startPage: 322),
  Surah(number: 22, name: 'سُورَةُ الحَجِّ', type: 'مدنية', versesCount: 78, startPage: 332),
  Surah(number: 23, name: 'سُورَةُ المُؤْمِنُونَ', type: 'مكية', versesCount: 118, startPage: 342),
  Surah(number: 24, name: 'سُورَةُ النُّورِ', type: 'مدنية', versesCount: 64, startPage: 350),
  Surah(number: 25, name: 'سُورَةُ الفُرْقَانِ', type: 'مكية', versesCount: 77, startPage: 359),
  Surah(number: 26, name: 'سُورَةُ الشُّعَرَاءِ', type: 'مكية', versesCount: 227, startPage: 367),
  Surah(number: 27, name: 'سُورَةُ النَّمْلِ', type: 'مكية', versesCount: 93, startPage: 377),
  Surah(number: 28, name: 'سُورَةُ القَصَصِ', type: 'مكية', versesCount: 88, startPage: 385),
  Surah(number: 29, name: 'سُورَةُ العَنْكَبُوتِ', type: 'مكية', versesCount: 69, startPage: 396),
  Surah(number: 30, name: 'سُورَةُ الرُّومِ', type: 'مكية', versesCount: 60, startPage: 404),
  Surah(number: 31, name: 'سُورَةُ لُقْمَانَ', type: 'مكية', versesCount: 34, startPage: 411),
  Surah(number: 32, name: 'سُورَةُ السَّجْدَةِ', type: 'مكية', versesCount: 30, startPage: 415),
  Surah(number: 33, name: 'سُورَةُ الأَحْزَابِ', type: 'مدنية', versesCount: 73, startPage: 418),
  Surah(number: 34, name: 'سُورَةُ سَبَإٍ', type: 'مكية', versesCount: 54, startPage: 428),
  Surah(number: 35, name: 'سُورَةُ فَاطِرٍ', type: 'مكية', versesCount: 45, startPage: 434),
  Surah(number: 36, name: 'سُورَةُ يٰسٓ', type: 'مكية', versesCount: 83, startPage: 440),
  Surah(number: 37, name: 'سُورَةُ الصَّافَّاتِ', type: 'مكية', versesCount: 182, startPage: 446),
  Surah(number: 38, name: 'سُورَةُ صٓ', type: 'مكية', versesCount: 88, startPage: 453),
  Surah(number: 39, name: 'سُورَةُ الزُّمَرِ', type: 'مكية', versesCount: 75, startPage: 458),
  Surah(number: 40, name: 'سُورَةُ غَافِرٍ', type: 'مكية', versesCount: 85, startPage: 467),
  Surah(number: 41, name: 'سُورَةُ فُصِّلَتْ', type: 'مكية', versesCount: 54, startPage: 477),
  Surah(number: 42, name: 'سُورَةُ الشُّورَىٰ', type: 'مكية', versesCount: 53, startPage: 483),
  Surah(number: 43, name: 'سُورَةُ الزُّخْرُفِ', type: 'مكية', versesCount: 89, startPage: 489),
  Surah(number: 44, name: 'سُورَةُ الدُّخَانِ', type: 'مكية', versesCount: 59, startPage: 496),
  Surah(number: 45, name: 'سُورَةُ الجَاثِيَةِ', type: 'مكية', versesCount: 37, startPage: 499),
  Surah(number: 46, name: 'سُورَةُ الأَحْقَافِ', type: 'مكية', versesCount: 35, startPage: 502),
  Surah(number: 47, name: 'سُورَةُ مُحَمَّدٍ', type: 'مدنية', versesCount: 38, startPage: 507),
  Surah(number: 48, name: 'سُورَةُ الفَتْحِ', type: 'مدنية', versesCount: 29, startPage: 511),
  Surah(number: 49, name: 'سُورَةُ الحُجُرَاتِ', type: 'مدنية', versesCount: 18, startPage: 515),
  Surah(number: 50, name: 'سُورَةُ قٓ', type: 'مكية', versesCount: 45, startPage: 518),
  Surah(number: 51, name: 'سُورَةُ الذَّارِيَاتِ', type: 'مكية', versesCount: 60, startPage: 520),
  Surah(number: 52, name: 'سُورَةُ الطُّورِ', type: 'مكية', versesCount: 49, startPage: 523),
  Surah(number: 53, name: 'سُورَةُ النَّجْمِ', type: 'مكية', versesCount: 62, startPage: 526),
  Surah(number: 54, name: 'سُورَةُ القَمَرِ', type: 'مكية', versesCount: 55, startPage: 528),
  Surah(number: 55, name: 'سُورَةُ الرَّحْمٰنِ', type: 'مدنية', versesCount: 78, startPage: 531),
  Surah(number: 56, name: 'سُورَةُ الوَاقِعَةِ', type: 'مكية', versesCount: 96, startPage: 534),
  Surah(number: 57, name: 'سُورَةُ الحَدِيدِ', type: 'مدنية', versesCount: 29, startPage: 537),
  Surah(number: 58, name: 'سُورَةُ المُجَادَلَةِ', type: 'مدنية', versesCount: 22, startPage: 542),
  Surah(number: 59, name: 'سُورَةُ الحَشْرِ', type: 'مدنية', versesCount: 24, startPage: 545),
  Surah(number: 60, name: 'سُورَةُ المُمْتَحَنَةِ', type: 'مدنية', versesCount: 13, startPage: 549),
  Surah(number: 61, name: 'سُورَةُ الصَّفِّ', type: 'مدنية', versesCount: 14, startPage: 551),
  Surah(number: 62, name: 'سُورَةُ الجُمُعَةِ', type: 'مدنية', versesCount: 11, startPage: 553),
  Surah(number: 63, name: 'سُورَةُ المُنَافِقُونَ', type: 'مدنية', versesCount: 11, startPage: 554),
  Surah(number: 64, name: 'سُورَةُ التَّغَابُنِ', type: 'مدنية', versesCount: 18, startPage: 556),
  Surah(number: 65, name: 'سُورَةُ الطَّلاَقِ', type: 'مدنية', versesCount: 12, startPage: 558),
  Surah(number: 66, name: 'سُورَةُ التَّحْرِيمِ', type: 'مدنية', versesCount: 12, startPage: 560),
  Surah(number: 67, name: 'سُورَةُ المُلْكِ', type: 'مكية', versesCount: 30, startPage: 562),
  Surah(number: 68, name: 'سُورَةُ القَلَمِ', type: 'مكية', versesCount: 52, startPage: 564),
  Surah(number: 69, name: 'سُورَةُ الحَاقَّةِ', type: 'مكية', versesCount: 52, startPage: 566),
  Surah(number: 70, name: 'سُورَةُ المَعَارِجِ', type: 'مكية', versesCount: 44, startPage: 568),
  Surah(number: 71, name: 'سُورَةُ نُوحٍ', type: 'مكية', versesCount: 28, startPage: 570),
  Surah(number: 72, name: 'سُورَةُ الجِنِّ', type: 'مكية', versesCount: 28, startPage: 572),
  Surah(number: 73, name: 'سُورَةُ المُزَّمِّلِ', type: 'مكية', versesCount: 20, startPage: 574),
  Surah(number: 74, name: 'سُورَةُ المُدَّثِّرِ', type: 'مكية', versesCount: 56, startPage: 575),
  Surah(number: 75, name: 'سُورَةُ القِيَامَةِ', type: 'مكية', versesCount: 40, startPage: 577),
  Surah(number: 76, name: 'سُورَةُ الإِنْسَانِ', type: 'مدنية', versesCount: 31, startPage: 578),
  Surah(number: 77, name: 'سُورَةُ المُرْسَلاَتِ', type: 'مكية', versesCount: 50, startPage: 580),
  Surah(number: 78, name: 'سُورَةُ النَّبَإِ', type: 'مكية', versesCount: 40, startPage: 582),
  Surah(number: 79, name: 'سُورَةُ النَّازِعَاتِ', type: 'مكية', versesCount: 46, startPage: 583),
  Surah(number: 80, name: 'سُورَةُ عَبَسَ', type: 'مكية', versesCount: 42, startPage: 585),
  Surah(number: 81, name: 'سُورَةُ التَّكْوِيرِ', type: 'مكية', versesCount: 29, startPage: 586),
  Surah(number: 82, name: 'سُورَةُ الإِنْفِطَارِ', type: 'مكية', versesCount: 19, startPage: 587),
  Surah(number: 83, name: 'سُورَةُ المُطَفِّفِينَ', type: 'مكية', versesCount: 36, startPage: 587),
  Surah(number: 84, name: 'سُورَةُ الإِنْشِقَاقِ', type: 'مكية', versesCount: 25, startPage: 589),
  Surah(number: 85, name: 'سُورَةُ البُرُوجِ', type: 'مكية', versesCount: 22, startPage: 590),
  Surah(number: 86, name: 'سُورَةُ الطَّارِقِ', type: 'مكية', versesCount: 17, startPage: 591),
  Surah(number: 87, name: 'سُورَةُ الأَعْلَىٰ', type: 'مكية', versesCount: 19, startPage: 591),
  Surah(number: 88, name: 'سُورَةُ الغَاشِيَةِ', type: 'مكية', versesCount: 26, startPage: 592),
  Surah(number: 89, name: 'سُورَةُ الفَجْرِ', type: 'مكية', versesCount: 30, startPage: 593),
  Surah(number: 90, name: 'سُورَةُ البَلَدِ', type: 'مكية', versesCount: 20, startPage: 594),
  Surah(number: 91, name: 'سُورَةُ الشَّمْسِ', type: 'مكية', versesCount: 15, startPage: 595),
  Surah(number: 92, name: 'سُورَةُ اللَّيْلِ', type: 'مكية', versesCount: 21, startPage: 595),
  Surah(number: 93, name: 'سُورَةُ الضُّحَىٰ', type: 'مكية', versesCount: 11, startPage: 596),
  Surah(number: 94, name: 'سُورَةُ الشَّرْحِ', type: 'مكية', versesCount: 8, startPage: 596),
  Surah(number: 95, name: 'سُورَةُ التِّينِ', type: 'مكية', versesCount: 8, startPage: 597),
  Surah(number: 96, name: 'سُورَةُ العَلَقِ', type: 'مكية', versesCount: 19, startPage: 597),
  Surah(number: 97, name: 'سُورَةُ القَدْرِ', type: 'مكية', versesCount: 5, startPage: 598),
  Surah(number: 98, name: 'سُورَةُ البَيِّنَةِ', type: 'مدنية', versesCount: 8, startPage: 598),
  Surah(number: 99, name: 'سُورَةُ الزَّلْزَلَةِ', type: 'مدنية', versesCount: 8, startPage: 599),
  Surah(number: 100, name: 'سُورَةُ العَادِيَاتِ', type: 'مكية', versesCount: 11, startPage: 599),
  Surah(number: 101, name: 'سُورَةُ القَارِعَةِ', type: 'مكية', versesCount: 11, startPage: 600),
  Surah(number: 102, name: 'سُورَةُ التَّكَاثُرِ', type: 'مكية', versesCount: 8, startPage: 600),
  Surah(number: 103, name: 'سُورَةُ العَصْرِ', type: 'مكية', versesCount: 3, startPage: 601),
  Surah(number: 104, name: 'سُورَةُ الهُمَزَةِ', type: 'مكية', versesCount: 9, startPage: 601),
  Surah(number: 105, name: 'سُورَةُ الفِيلِ', type: 'مكية', versesCount: 5, startPage: 601),
  Surah(number: 106, name: 'سُورَةُ قُرَيْشٍ', type: 'مكية', versesCount: 4, startPage: 602),
  Surah(number: 107, name: 'سُورَةُ المَاعُونِ', type: 'مكية', versesCount: 7, startPage: 602),
  Surah(number: 108, name: 'سُورَةُ الكَوْثَرِ', type: 'مكية', versesCount: 3, startPage: 602),
  Surah(number: 109, name: 'سُورَةُ الكَافِرُونَ', type: 'مكية', versesCount: 6, startPage: 603),
  Surah(number: 110, name: 'سُورَةُ النَّصْرِ', type: 'مدنية', versesCount: 3, startPage: 603),
  Surah(number: 111, name: 'سُورَةُ المَسَدِ', type: 'مكية', versesCount: 5, startPage: 603),
  Surah(number: 112, name: 'سُورَةُ الإِخْلاَصِ', type: 'مكية', versesCount: 4, startPage: 604),
  Surah(number: 113, name: 'سُورَةُ الفَلَقِ', type: 'مكية', versesCount: 5, startPage: 604),
  Surah(number: 114, name: 'سُورَةُ النَّاسِ', type: 'مكية', versesCount: 6, startPage: 604),
];

class SurahIndexScreen extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onToggleTheme;
  final int bookmarkedPage;
  final Function(int) onSetBookmark;

  const SurahIndexScreen({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
    required this.bookmarkedPage,
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
          surah.number.toString() == searchQuery ||
          surah.startPage.toString() == searchQuery;
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
                    trailing: Text(
                      'صـ ${surah.startPage}',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuranPageView(
                            initialPage: surah.startPage,
                            onSetBookmark: widget.onSetBookmark,
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

class QuranPageView extends StatefulWidget {
  final int initialPage;
  final Function(int) onSetBookmark;

  const QuranPageView({
    super.key,
    required this.initialPage,
    required this.onSetBookmark,
  });

  @override
  State<QuranPageView> createState() => _QuranPageViewState();
}

class _QuranPageViewState extends State<QuranPageView> {
  late PageController _pageController;
  late int currentPage;

  @override
  void initState() {
    super.initState();
    currentPage = widget.initialPage;
    _pageController = PageController(initialPage: widget.initialPage - 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('صفحة $currentPage'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_add_outlined),
            onPressed: () => widget.onSetBookmark(currentPage),
          ),
        ],
      ),
      body: PageView.builder(
        controller: _pageController,
        reverse: true,
        itemCount: 604,
        onPageChanged: (index) {
          setState(() {
            currentPage = index + 1;
          });
        },
        itemBuilder: (context, index) {
          int pageNum = index + 1;
          
          // مسار قراءة الصور من مجلد الأصول الأصلي
          String imagePath = 'assets/page_$pageNum.png';

          return InteractiveViewer(
            maxScale: 4.0,
            minScale: 1.0,
            child: Center(
              child: Image.asset(
                imagePath,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(color: Colors.black12, blurRadius: 8),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.image_not_supported_outlined, size: 80, color: Color(0xFF1B4D3E)),
                        const SizedBox(height: 20),
                        Text(
                          'صفحة $pageNum',
                          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF1B4D3E)),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'جاري تحميل صورة الصفحة من المجلد الأصلي...\n(تأكد من توافق اسم الصورة مع المسار: assets/page_$pageNum.png)',
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

