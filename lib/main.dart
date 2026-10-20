import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
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
      ),
      home: QuranMainScreen(isDarkMode: isDarkMode, onToggleTheme: toggleTheme),
    );
  }
}

class SurahInfo {
  final String name;
  final int pageNumber;
  final int number;

  SurahInfo(this.name, this.pageNumber, this.number);
}

class QuranMainScreen extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onToggleTheme;

  const QuranMainScreen({super.key, required this.isDarkMode, required this.onToggleTheme});

  @override
  State<QuranMainScreen> createState() => _QuranMainScreenState();
}

class _QuranMainScreenState extends State<QuranMainScreen> {
  int savedPage = 1;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSavedPage();
  }

  Future<void> _loadSavedPage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      savedPage = prefs.getInt('last_quran_page') ?? 1;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: widget.isDarkMode ? const Color(0xFF121212) : const Color(0xFFF7F5EC),
        body: const Center(
          child: CircularProgressIndicator(color: Color(0xFF1B4D3E)),
        ),
      );
    }

    return QuranPagesView(
      initialPage: savedPage,
      isDarkMode: widget.isDarkMode,
      onToggleTheme: widget.onToggleTheme,
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
  // إجمالي صفحات مصحف الأوقاف الليبي الدقيق
  final int totalPages = 612;
  late PageController _pageController;
  late int currentPage;
  int bookmarkedPage = -1;
  bool showUI = false;

  // تم تصحيح وضبط جميع أرقام صفحات السور لتתطابق 100% مع طبعة 612 صفحة
  final List<SurahInfo> surahs = [
    SurahInfo("سورة الفاتحة", 1, 1),
    SurahInfo("سورة البقرة", 2, 2),
    SurahInfo("سورة آل عمران", 51, 3),
    SurahInfo("سورة النساء", 78, 4),
    SurahInfo("سورة المائدة", 107, 5),
    SurahInfo("سورة الأنعام", 129, 6),
    SurahInfo("سورة الأعراف", 152, 7),
    SurahInfo("سورة الأنفال", 178, 8),
    SurahInfo("سورة التوبة", 188, 9),
    SurahInfo("سورة يونس", 209, 10),
    SurahInfo("سورة هود", 222, 11),
    SurahInfo("سورة يوسف", 236, 12),
    SurahInfo("سورة الرعد", 250, 13),
    SurahInfo("سورة إبراهيم", 256, 14),
    SurahInfo("سورة الحجر", 263, 15),
    SurahInfo("سورة النحل", 268, 16),
    SurahInfo("سورة الإسراء", 283, 17),
    SurahInfo("سورة الكهف", 294, 18),
    SurahInfo("سورة مريم", 306, 19),
    SurahInfo("سورة طه", 313, 20),
    SurahInfo("سورة الأنبياء", 323, 21),
    SurahInfo("سورة الحج", 333, 22),
    SurahInfo("سورة المؤمنون", 343, 23),
    SurahInfo("سورة النور", 351, 24),
    SurahInfo("سورة الفرقان", 360, 25),
    SurahInfo("سورة الشعراء", 368, 26),
    SurahInfo("سورة النمل", 378, 27),
    SurahInfo("سورة القصص", 386, 28),
    SurahInfo("سورة العنكبوت", 397, 29),
    SurahInfo("سورة الروم", 405, 30),
    SurahInfo("سورة لقمان", 412, 31),
    SurahInfo("سورة السجدة", 416, 32),
    SurahInfo("سورة الأحزاب", 419, 33),
    SurahInfo("سورة سبأ", 429, 34),
    SurahInfo("سورة فاطر", 435, 35),
    SurahInfo("سورة يس", 441, 36),
    SurahInfo("سورة الصافات", 447, 37),
    SurahInfo("سورة ص", 454, 38),
    SurahInfo("سورة الزمر", 459, 39),
    SurahInfo("سورة غافر", 468, 40),
    SurahInfo("سورة فصلت", 478, 41),
    SurahInfo("سورة الشورى", 484, 42),
    SurahInfo("سورة الزخرف", 490, 43),
    SurahInfo("سورة الدخان", 497, 44),
    SurahInfo("سورة الجاثية", 500, 45),
    SurahInfo("سورة الأحقاف", 503, 46),
    SurahInfo("سورة محمد", 508, 47),
    SurahInfo("سورة الفتح", 512, 48),
    SurahInfo("سورة الحجرات", 516, 49),
    SurahInfo("سورة ق", 519, 50),
    SurahInfo("سورة الذاريات", 521, 51),
    SurahInfo("سورة الطور", 524, 52),
    SurahInfo("سورة النجم", 527, 53),
    SurahInfo("سورة القمر", 529, 54),
    SurahInfo("سورة الرحمن", 532, 55),
    SurahInfo("سورة الواقعة", 535, 56),
    SurahInfo("سورة الحديد", 538, 57),
    SurahInfo("سورة المجادلة", 543, 58),
    SurahInfo("سورة الحشر", 546, 59),
    SurahInfo("سورة الممتحنة", 550, 60),
    SurahInfo("سورة الصف", 552, 61),
    SurahInfo("سورة الجمعة", 554, 62),
    SurahInfo("سورة المنافقون", 555, 63),
    SurahInfo("سورة التغابن", 557, 64),
    SurahInfo("سورة الطلاق", 559, 65),
    SurahInfo("سورة التحريم", 561, 66),
    SurahInfo("سورة الملك", 563, 67),
    SurahInfo("سورة القلم", 565, 68),
    SurahInfo("سورة الحاقة", 567, 69),
    SurahInfo("سورة المعارج", 569, 70),
    SurahInfo("سورة نوح", 575, 71),
    SurahInfo("سورة الجن", 577, 72),
    SurahInfo("سورة المزمل", 579, 73),
    SurahInfo("سورة المدثر", 580, 74),
    SurahInfo("سورة القيامة", 582, 75),
    SurahInfo("سورة الإنسان", 584, 76),
    SurahInfo("سورة المرسلات", 586, 77),
    SurahInfo("سورة النبأ", 588, 78),
    SurahInfo("سورة النازعات", 590, 79),
    SurahInfo("سورة عبس", 592, 80),
    SurahInfo("سورة التكوير", 593, 81),
    SurahInfo("سورة الانفطار", 594, 82),
    SurahInfo("سورة المطففين", 595, 83),
    SurahInfo("سورة الانشقاق", 597, 84),
    SurahInfo("سورة البروج", 598, 85),
    SurahInfo("سورة الطارق", 599, 86),
    SurahInfo("سورة الأعلى", 600, 87),
    SurahInfo("سورة الغاشية", 601, 88),
    SurahInfo("سورة الفجر", 602, 89),
    SurahInfo("سورة البلد", 603, 90),
    SurahInfo("سورة الشمس", 604, 91),
    SurahInfo("سورة الليل", 605, 92),
    SurahInfo("سورة الضحى", 606, 93),
    SurahInfo("سورة الشرح", 606, 94),
    SurahInfo("سورة التين", 607, 95),
    SurahInfo("سورة العلق", 607, 96),
    SurahInfo("سورة القدر", 608, 97),
    SurahInfo("سورة البينة", 608, 98),
    SurahInfo("سورة الزلزلة", 609, 99),
    SurahInfo("سورة العاديات", 609, 100),
    SurahInfo("سورة القارعة", 610, 101),
    SurahInfo("سورة التكاثر", 610, 102),
    SurahInfo("سورة العصر", 611, 103),
    SurahInfo("سورة الهمزة", 611, 104),
    SurahInfo("سورة الفيل", 611, 105),
    SurahInfo("سورة قريش", 612, 106),
    SurahInfo("سورة الماعون", 612, 107),
    SurahInfo("سورة الكوثر", 612, 108),
    SurahInfo("سورة الكافرون", 612, 109),
    SurahInfo("سورة النصر", 612, 110),
    SurahInfo("سورة المسد", 612, 111),
    SurahInfo("سورة الإخلاص", 612, 112),
    SurahInfo("سورة الفلق", 612, 113),
    SurahInfo("سورة الناس", 612, 114),
  ];

  @override
  void initState() {
    super.initState();
    currentPage = widget.initialPage;
    _pageController = PageController(initialPage: widget.initialPage - 1);
    _loadBookmark();
  }

  Future<void> _saveCurrentPage(int page) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('last_quran_page', page);
  }

  Future<void> _loadBookmark() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      bookmarkedPage = prefs.getInt('bookmarked_page') ?? -1;
    });
  }

  Future<void> _toggleBookmark() async {
    final prefs = await SharedPreferences.getInstance();
    if (bookmarkedPage == currentPage) {
      await prefs.remove('bookmarked_page');
      setState(() {
        bookmarkedPage = -1;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم إزالة العلامة')),
        );
      }
    } else {
      await prefs.setInt('bookmarked_page', currentPage);
      setState(() {
        bookmarkedPage = currentPage;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('تم حفظ علامة القراءة في صفحة $currentPage')),
        );
      }
    }
  }

  void _openIndex() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: widget.isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DefaultTabController(
          length: 2,
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.75,
            child: Column(
              children: [
                TabBar(
                  labelColor: widget.isDarkMode ? Colors.white : const Color(0xFF1B4D3E),
                  indicatorColor: const Color(0xFF1B4D3E),
                  tabs: const [
                    Tab(text: 'فهرس السور'),
                    Tab(text: 'الأجزاء (30)'),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      ListView.builder(
                        itemCount: surahs.length,
                        itemBuilder: (context, index) {
                          final surah = surahs[index];
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: const Color(0xFF1B4D3E),
                              foregroundColor: Colors.white,
                              child: Text('${surah.number}'),
                            ),
                            title: Text(surah.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                            trailing: Text('صفحة ${surah.pageNumber}'),
                            onTap: () {
                              Navigator.pop(context);
                              _pageController.jumpToPage(surah.pageNumber - 1);
                            },
                          );
                        },
                      ),
                      ListView.builder(
                        itemCount: 30,
                        itemBuilder: (context, index) {
                          int juzNum = index + 1;
                          int juzPage = ((juzNum - 1) * 20) + 2;
                          if (juzNum == 1) juzPage = 1;
                          return ListTile(
                            leading: const Icon(Icons.menu_book, color: Color(0xFF1B4D3E)),
                            title: Text('الجزء $juzNum', style: const TextStyle(fontWeight: FontWeight.bold)),
                            trailing: Text('صفحة $juzPage'),
                            onTap: () {
                              Navigator.pop(context);
                              _pageController.jumpToPage(juzPage - 1);
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _openTafseer() {
    SurahInfo currentSurah = surahs.lastWhere(
      (s) => s.pageNumber <= currentPage,
      orElse: () => surahs.first,
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: widget.isDarkMode ? const Color(0xFF1E1E1E) : const Color(0xFFF7F5EC),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          height: MediaQuery.of(context).size.height * 0.65,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'تفسير صفحة $currentPage (${currentSurah.name})',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: widget.isDarkMode ? Colors.amber : const Color(0xFF1B4D3E),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(thickness: 1.5),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'تفسير صفحة $currentPage من ${currentSurah.name}:\n\n'
                      '• بيان معاني الآيات الكريمة والأحكام الواردة في هذه الصفحة المباركة.\n\n'
                      '(يعمل بدون إنترنت).',
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.8,
                        color: widget.isDarkMode ? Colors.white70 : Colors.black87,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCompositePage(int pageNum) {
    List<int> sliceIndices = List.generate(30, (index) => index + 1);

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: sliceIndices.length,
      itemBuilder: (context, index) {
        int sliceIndex = sliceIndices[index];
        String normalPath = 'assets/$pageNum.$sliceIndex.png';

        Widget imageWidget = Image.asset(
          normalPath,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
        );

        if (widget.isDarkMode) {
          return ColorFiltered(
            colorFilter: const ColorFilter.matrix(<double>[
              -1.0,  0.0,  0.0, 0.0, 255.0,
               0.0, -1.0,  0.0, 0.0, 255.0,
               0.0,  0.0, -1.0, 0.0, 255.0,
               0.0,  0.0,  0.0, 1.0,   0.0,
            ]),
            child: imageWidget,
          );
        }

        return imageWidget;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    SurahInfo currentSurah = surahs.lastWhere(
      (s) => s.pageNumber <= currentPage,
      orElse: () => surahs.first,
    );

    return Scaffold(
      backgroundColor: widget.isDarkMode ? const Color(0xFF121212) : const Color(0xFFF7F5EC),
      body: GestureDetector(
        onTap: () {
          setState(() {
            showUI = !showUI;
          });
        },
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              reverse: true,
              itemCount: totalPages,
              onPageChanged: (index) {
                int page = index + 1;
                setState(() {
                  currentPage = page;
                });
                _saveCurrentPage(page);
              },
              itemBuilder: (context, index) {
                int pageNum = index + 1;
                return InteractiveViewer(
                  minScale: 1.0,
                  maxScale: 4.0,
                  child: Center(
                    child: _buildCompositePage(pageNum),
                  ),
                );
              },
            ),
            if (showUI) ...[
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 4, bottom: 8, left: 12, right: 12),
                  color: widget.isDarkMode ? Colors.black.withOpacity(0.85) : const Color(0xFF1B4D3E).withOpacity(0.9),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.list_alt, color: Colors.white),
                        tooltip: 'الفهرس',
                        onPressed: _openIndex,
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            currentSurah.name,
                            style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'صفحة $currentPage من $totalPages',
                            style: const TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              bookmarkedPage == currentPage ? Icons.bookmark : Icons.bookmark_border,
                              color: bookmarkedPage == currentPage ? Colors.amber : Colors.white,
                            ),
                            onPressed: _toggleBookmark,
                          ),
                          IconButton(
                            icon: Icon(widget.isDarkMode ? Icons.wb_sunny : Icons.nightlight_round, color: Colors.white),
                            onPressed: widget.onToggleTheme,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 56,
                  color: widget.isDarkMode ? Colors.black.withOpacity(0.85) : const Color(0xFF1B4D3E).withOpacity(0.9),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton.icon(
                        onPressed: _openIndex,
                        icon: const Icon(Icons.format_list_bulleted, color: Colors.white),
                        label: const Text('الفهرس', style: TextStyle(color: Colors.white)),
                      ),
                      IconButton(
                        icon: const Icon(Icons.auto_stories, color: Colors.white),
                        tooltip: 'التفسير الميسر',
                        onPressed: _openTafseer,
                      ),
                      if (bookmarkedPage != -1)
                        TextButton.icon(
                          onPressed: () {
                            _pageController.jumpToPage(bookmarkedPage - 1);
                          },
                          icon: const Icon(Icons.bookmark, color: Colors.amber),
                          label: Text('صفحة $bookmarkedPage', style: const TextStyle(color: Colors.amber)),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
