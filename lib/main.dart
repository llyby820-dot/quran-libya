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
  final int totalPages = 612;
  late PageController _pageController;
  late int currentPage;
  int bookmarkedPage = -1;
  bool showUI = false;

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
    SurahInfo("سورة نوح", 574, 71),
    SurahInfo("سورة الجن", 576, 72),
    SurahInfo("سورة المزمل", 578, 73),
    SurahInfo("سورة المدثر", 579, 74),
    SurahInfo("سورة القيامة", 581, 75),
    SurahInfo("سورة الإنسان", 583, 76),
    SurahInfo("سورة المرسلات", 585, 77),
    SurahInfo("سورة النبأ", 587, 78),
    SurahInfo("سورة النازعات", 589, 79),
    SurahInfo("سورةعبس", 591, 80),
    SurahInfo("سورة التكوير", 592, 81),
    SurahInfo("سورة الانفطار", 593, 82),
    SurahInfo("سورة المطففين", 594, 83),
    SurahInfo("سورة الانشقاق", 596, 84),
    SurahInfo("سورة البروج", 597, 85),
    SurahInfo("سورة الطارق", 598, 86),
    SurahInfo("سورة الأعلى", 599, 87),
    SurahInfo("سورة الغاشية", 600, 88),
    SurahInfo("سورة الفجر", 601, 89),
    SurahInfo("سورة البلد", 602, 90),
    SurahInfo("سورة الشمس", 603, 91),
    SurahInfo("سورة الليل", 604, 92),
    SurahInfo("سورة الضحى", 605, 93),
    SurahInfo("سورة الشرح", 605, 94),
    SurahInfo("سورة التين", 606, 95),
    SurahInfo("سورة العلق", 606, 96),
    SurahInfo("سورة القدر", 607, 97),
    SurahInfo("سورة البينة", 607, 98),
    SurahInfo("سورة الزلزلة", 608, 99),
    SurahInfo("سورة العاديات", 608, 100),
    SurahInfo("سورة القارعة", 609, 101),
    SurahInfo("سورة التكاثر", 609, 102),
    SurahInfo("سورة العصر", 610, 103),
    SurahInfo("سورة الهمزة", 610, 104),
    SurahInfo("سورة الفيل", 610, 105),
    SurahInfo("سورة قريش", 611, 106),
    SurahInfo("سورة الماعون", 611, 107),
    SurahInfo("سورة الكوثر", 611, 108),
    SurahInfo("سورة الكافرون", 611, 109),
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

  SurahInfo _getCurrentSurah(int pageNum) {
    SurahInfo current = surahs.first;
    for (var surah in surahs) {
      if (pageNum >= surah.pageNumber) {
        current = surah;
      } else {
        break;
      }
    }
    return current;
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
    SurahInfo currentSurah = _getCurrentSurah(currentPage);

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

  // بناء الصفحة باستخدام 15 شريحة بالضبط المطابقة لمجلد assets
  Widget _buildCompositePage(int pageNum) {
    List<int> sliceIndices = List.generate(15, (index) => index + 1);

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: sliceIndices.length,
      itemBuilder: (context, index) {
        int sliceIndex = sliceIndices[index];

        String darkPath = 'assets/$pageNum.${sliceIndex}_dark.png';
        String normalPath = 'assets/$pageNum.$sliceIndex.png';

        Widget imageWidget;

        if (widget.isDarkMode) {
          imageWidget = Image.asset(
            darkPath,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return ColorFiltered(
                colorFilter: const ColorFilter.matrix(<double>[
                  -1.0,  0.0,  0.0, 0.0, 255.0,
                   0.0, -1.0,  0.0, 0.0, 255.0,
                   0.0,  0.0, -1.0, 0.0, 255.0,
                   0.0,  0.0,  0.0, 1.0,   0.0,
                ]),
                child: Image.asset(
                  normalPath,
                  fit: BoxFit.contain,
                  errorBuilder: (c, e, s) => const SizedBox.shrink(),
                ),
              );
            },
          );
        } else {
          imageWidget = Image.asset(
            normalPath,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
          );
        }

        return imageWidget;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    SurahInfo currentSurah = _getCurrentSurah(currentPage);

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
                dir: TextDirection.rtl,
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
