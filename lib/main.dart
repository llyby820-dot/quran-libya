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

  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'مصحف الأوقاف الليبية',
      theme: ThemeData(
        brightness: isDarkMode ? Brightness.dark : Brightness.light,
        scaffoldBackgroundColor: isDarkMode ? const Color(0xFF121212) : const Color(0xFFF7F5EC),
        appBarTheme: AppBarTheme(
          backgroundColor: isDarkMode ? const Color(0xFF1E1E1E) : const Color(0xFF1B4D3E),
          foregroundColor: Colors.white,
        ),
      ),
      home: QuranIndexView(isDarkMode: isDarkMode, onToggleTheme: toggleTheme),
    );
  }
}

class SurahInfo {
  final String name;
  final int pageNumber;
  final int number;

  SurahInfo(this.name, this.pageNumber, this.number);
}

class QuranIndexView extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback onToggleTheme;

  QuranIndexView({super.key, required this.isDarkMode, required this.onToggleTheme});

  final List<SurahInfo> surahs = [
    SurahInfo("سورة الفاتحة", 1, 1),
    SurahInfo("سورة البقرة", 2, 2),
    SurahInfo("سورة آل عمران", 50, 3),
    SurahInfo("سورة النساء", 77, 4),
    SurahInfo("سورة المائدة", 106, 5),
    SurahInfo("سورة الأنعام", 128, 6),
    SurahInfo("سورة الأعراف", 151, 7),
    SurahInfo("سورة الأنفال", 177, 8),
    SurahInfo("سورة التوبة", 187, 9),
    SurahInfo("سورة يونس", 208, 10),
    SurahInfo("سورة هود", 221, 11),
    SurahInfo("سورة يوسف", 235, 12),
    SurahInfo("سورة الرعد", 249, 13),
    SurahInfo("سورة إبراهيم", 255, 14),
    SurahInfo("سورة الحجر", 262, 15),
    SurahInfo("سورة النحل", 267, 16),
    SurahInfo("سورة الإسراء", 282, 17),
    SurahInfo("سورة الكهف", 293, 18),
    SurahInfo("سورة مريم", 305, 19),
    SurahInfo("سورة طه", 312, 20),
    SurahInfo("سورة الأنبياء", 322, 21),
    SurahInfo("سورة الحج", 332, 22),
    SurahInfo("سورة المؤمنون", 342, 23),
    SurahInfo("سورة النور", 350, 24),
    SurahInfo("سورة الفرقان", 359, 25),
    SurahInfo("سورة الشعراء", 367, 26),
    SurahInfo("سورة النمل", 377, 27),
    SurahInfo("سورة القصص", 385, 28),
    SurahInfo("سورة العنكبوت", 396, 29),
    SurahInfo("سورة الروم", 404, 30),
    SurahInfo("سورة لقمان", 411, 31),
    SurahInfo("سورة السجدة", 415, 32),
    SurahInfo("سورة الأحزاب", 418, 33),
    SurahInfo("سورة سبأ", 428, 34),
    SurahInfo("سورة فاطر", 434, 35),
    SurahInfo("سورة يس", 440, 36),
    SurahInfo("سورة الصافات", 446, 37),
    SurahInfo("سورة ص", 453, 38),
    SurahInfo("سورة الزمر", 458, 39),
    SurahInfo("سورة غافر", 467, 40),
    SurahInfo("سورة فصلت", 477, 41),
    SurahInfo("سورة الشورى", 483, 42),
    SurahInfo("سورة الزخرف", 489, 43),
    SurahInfo("سورة الدخان", 496, 44),
    SurahInfo("سورة الجاثية", 499, 45),
    SurahInfo("سورة الأحقاف", 502, 46),
    SurahInfo("سورة محمد", 507, 47),
    SurahInfo("سورة الفتح", 511, 48),
    SurahInfo("سورة الحجرات", 515, 49),
    SurahInfo("سورة ق", 518, 50),
    SurahInfo("سورة الذاريات", 520, 51),
    SurahInfo("سورة الطور", 523, 52),
    SurahInfo("سورة النجم", 526, 53),
    SurahInfo("سورة القمر", 528, 54),
    SurahInfo("سورة الرحمن", 531, 55),
    SurahInfo("سورة الواقعة", 534, 56),
    SurahInfo("سورة الحديد", 537, 57),
    SurahInfo("سورة المجادلة", 542, 58),
    SurahInfo("سورة الحشر", 545, 59),
    SurahInfo("سورة الممتحنة", 549, 60),
    SurahInfo("سورة الصف", 551, 61),
    SurahInfo("سورة الجمعة", 553, 62),
    SurahInfo("سورة المنافقون", 554, 63),
    SurahInfo("سورة التغابن", 556, 64),
    SurahInfo("سورة الطلاق", 558, 65),
    SurahInfo("سورة التحريم", 560, 66),
    SurahInfo("سورة الملك", 562, 67),
    SurahInfo("سورة القلم", 564, 68),
    SurahInfo("سورة الحاقة", 566, 69),
    SurahInfo("سورة المعارج", 568, 70),
    SurahInfo("سورة نوح", 570, 71),
    SurahInfo("سورة الجن", 572, 72),
    SurahInfo("سورة المزمل", 574, 73),
    SurahInfo("سورة المدثر", 575, 74),
    SurahInfo("سورة القيامة", 577, 75),
    SurahInfo("سورة الإنسان", 578, 76),
    SurahInfo("سورة المرسلات", 580, 77),
    SurahInfo("سورة النبأ", 582, 78),
    SurahInfo("سورة النازعات", 583, 79),
    SurahInfo("سورة عبس", 585, 80),
    SurahInfo("سورة التكوير", 586, 81),
    SurahInfo("سورة الانفطار", 587, 82),
    SurahInfo("سورة المطففين", 587, 83),
    SurahInfo("سورة الانشقاق", 589, 84),
    SurahInfo("سورة البروج", 590, 85),
    SurahInfo("سورة الطارق", 591, 86),
    SurahInfo("سورة الأعلى", 591, 87),
    SurahInfo("سورة الغاشية", 592, 88),
    SurahInfo("سورة الفجر", 593, 89),
    SurahInfo("سورة البلد", 594, 90),
    SurahInfo("سورة الشمس", 595, 91),
    SurahInfo("سورة الليل", 595, 92),
    SurahInfo("سورة الضحى", 596, 93),
    SurahInfo("سورة الشرح", 596, 94),
    SurahInfo("سورة التين", 597, 95),
    SurahInfo("سورة العلق", 597, 96),
    SurahInfo("سورة القدر", 598, 97),
    SurahInfo("سورة البينة", 598, 98),
    SurahInfo("سورة الزلزلة", 599, 99),
    SurahInfo("سورة العاديات", 599, 100),
    SurahInfo("سورة القارعة", 600, 101),
    SurahInfo("سورة التكاثر", 600, 102),
    SurahInfo("سورة العصر", 601, 103),
    SurahInfo("سورة الهمزة", 601, 104),
    SurahInfo("سورة الفيل", 601, 105),
    SurahInfo("سورة قريش", 602, 106),
    SurahInfo("سورة الماعون", 602, 107),
    SurahInfo("سورة الكوثر", 602, 108),
    SurahInfo("سورة الكافرون", 603, 109),
    SurahInfo("سورة النصر", 603, 110),
    SurahInfo("سورة المسد", 603, 111),
    SurahInfo("سورة الإخلاص", 604, 112),
    SurahInfo("سورة الفلق", 604, 113),
    SurahInfo("سورة الناس", 604, 114),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('فهرس السور - مصحف الأوقاف'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(isDarkMode ? Icons.wb_sunny : Icons.nightlight_round),
            onPressed: onToggleTheme,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: surahs.length,
        itemBuilder: (context, index) {
          final surah = surahs[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: const Color(0xFF1B4D3E),
              foregroundColor: Colors.white,
              child: Text('${surah.number}'),
            ),
            title: Text(
              surah.name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            trailing: Text(
              'صفحة ${surah.pageNumber}',
              style: const TextStyle(color: Colors.grey),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QuranPagesView(
                    initialPage: surah.pageNumber,
                    isDarkMode: isDarkMode,
                    onToggleTheme: onToggleTheme,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class QuranPagesView extends StatefulWidget {
  final int initialPage;
  final bool isDarkMode;
  final VoidCallback onToggleTheme;

  const QuranPagesView({
    super.key,
    required this.initialPage,
    required this.isDarkMode,
    required this.onToggleTheme,
  });

  @override
  State<QuranPagesView> createState() => _QuranPageState();
}

class _QuranPageState extends State<QuranPagesView> {
  final int totalPages = 604;
  late PageController _pageController;
  late int currentPage;

  @override
  void initState() {
    super.initState();
    currentPage = widget.initialPage;
    _pageController = PageController(initialPage: widget.initialPage - 1);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('صفحة $currentPage من $totalPages'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(widget.isDarkMode ? Icons.wb_sunny : Icons.nightlight_round),
            onPressed: widget.onToggleTheme,
          ),
        ],
      ),
      body: PageView.builder(
        controller: _pageController,
        reverse: true,
        itemCount: totalPages,
        onPageChanged: (index) {
          setState(() {
            currentPage = index + 1;
          });
        },
        itemBuilder: (context, index) {
          int pageNum = index + 1;
          String imagePath = 'assets/page_${pageNum.toString().padLeft(3, '0')}.png';

          return InteractiveViewer(
            minScale: 1.0,
            maxScale: 4.0,
            child: Container(
              color: widget.isDarkMode ? const Color(0xFF121212) : const Color(0xFFF7F5EC),
              child: Center(
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'assets/$pageNum.png',
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.menu_book, size: 64, color: Colors.grey),
                              const SizedBox(height: 12),
                              Text(
                                'صفحة رقم $pageNum',
                                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'جارٍ تحميل صورة الصفحة...',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
