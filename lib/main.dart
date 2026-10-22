import 'dart:convert';
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

class HizbInfo {
  final int number;
  final String name;
  final int pageNumber;

  HizbInfo(this.number, this.name, this.pageNumber);
}

class VerseTafseer {
  final String verseText;
  final int verseNumber;
  final String tafseerText;

  VerseTafseer({required this.verseText, required this.verseNumber, required this.tafseerText});
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

  String? hizbNotificationText;
  bool showHizbNotification = false;

  final List<HizbInfo> hizbs = [
    HizbInfo(1, "سورة البقرة", 1),
    HizbInfo(2, "وإذا لقوا", 11),
    HizbInfo(3, "سيقول", 22),
    HizbInfo(4, "واذكروا الله", 31),
    HizbInfo(5, "تلك الرسل", 42),
    HizbInfo(6, "قل أونبئكم", 51),
    HizbInfo(7, "لن تنالوا", 62),
    HizbInfo(8, "يستبشرون", 72),
    HizbInfo(9, "والمحصنات", 82),
    HizbInfo(10, "الله لا إله إلا هو", 92),
    HizbInfo(11, "لا يحب الله الجهر بالسوء", 102),
    HizbInfo(12, "قال رجلان", 111),
    HizbInfo(13, "لتجدن", 121),
    HizbInfo(14, "إنما يستجيب", 132),
    HizbInfo(15, "ولو أننا", 142),
    HizbInfo(16, "فما كان دعواهم", 151),
    HizbInfo(17, "قال الملأ", 162),
    HizbInfo(18, "وإذ نتقنا", 173),
    HizbInfo(19, "واعلموا", 182),
    HizbInfo(20, "يا أيها الذين آمنوا إن كثيراً", 192),
    HizbInfo(21, "إنما السبيل", 201),
    HizbInfo(22, "للذين أحسنوا الحسنى", 212),
    HizbInfo(23, "وما من دابة", 222),
    HizbInfo(24, "وإلى مدين", 231),
    HizbInfo(25, "وما أبرئ نفسي", 242),
    HizbInfo(26, "أفمن يعلم", 252),
    HizbInfo(27, "ألر", 262),
    HizbInfo(28, "وقال الله لا تتخذوا", 272),
    HizbInfo(29, "سبحان", 282),
    HizbInfo(30, "أولم يروا", 292),
    HizbInfo(31, "قال ألم أقل", 302),
    HizbInfo(32, "طه", 312),
    HizbInfo(33, "اقترب", 322),
    HizbInfo(34, "يا أيها الناس اتقوا ربكم", 332),
    HizbInfo(35, "قد أفلح المؤمنون", 342),
    HizbInfo(36, "يا أيها الذين آمنوا لا تتبعوا", 352),
    HizbInfo(37, "وقال الذين لا يرجون", 362),
    HizbInfo(38, "قالوا أنؤمن", 372),
    HizbInfo(39, "فما كان جواب", 383),
    HizbInfo(40, "ولقد وصلنا", 393),
    HizbInfo(41, "ولا تجادلوا", 403),
    HizbInfo(42, "ومن يسلم", 414),
    HizbInfo(43, "ومن يقنت", 423),
    HizbInfo(44, "قل من يرزقكم", 432),
    HizbInfo(45, "وما أنزلنا", 443),
    HizbInfo(46, "فنبذناه", 452),
    HizbInfo(47, "فمن أظلم", 463),
    HizbInfo(48, "ويا قوم", 473),
    HizbInfo(49, "إليه يرد علم الساعة", 483),
    HizbInfo(50, "قل أولو جئتكم", 492),
    HizbInfo(51, "حم", 504),
    HizbInfo(52, "لقد رضي الله عن المؤمنين", 515),
    HizbInfo(53, "قال فما خطبكم", 524),
    HizbInfo(54, "الرحمن", 534),
    HizbInfo(55, "قد سمع", 546),
    HizbInfo(56, "يسبح لله", 557),
    HizbInfo(57, "تبارك", 566),
    HizbInfo(58, "قل أوحي إلي", 577),
    HizbInfo(59, "عم يتساءلون", 588),
    HizbInfo(60, "سبح اسم ربك", 598),
  ];

  final List<SurahInfo> surahs = [
    SurahInfo("سورة الفاتحة", 1, 1),
    SurahInfo("سورة البقرة", 1, 2),
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
    SurahInfo("سورة الفرقان", 360, 25),
    SurahInfo("سورة الشعراء", 367, 26),
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
    SurahInfo("سورة الصافات", 446, 37),
    SurahInfo("سورة ص", 454, 38),
    SurahInfo("سورة الزمر", 459, 39),
    SurahInfo("سورة غافر", 468, 40),
    SurahInfo("سورة فصلت", 478, 41),
    SurahInfo("سورة الشورى", 484, 42),
    SurahInfo("سورة الزخرف", 490, 43),
    SurahInfo("سورة الدخان", 497, 44),
    SurahInfo("سورة الجاثية", 500, 45),
    SurahInfo("سورة الأحقاف", 504, 46),
    SurahInfo("سورة محمد", 509, 47),
    SurahInfo("سورة الفتح", 513, 48),
    SurahInfo("سورة الحجرات", 517, 49),
    SurahInfo("سورة ق", 520, 50),
    SurahInfo("سورة الذاريات", 523, 51),
    SurahInfo("سورة الطور", 526, 52),
    SurahInfo("سورة النجم", 528, 53),
    SurahInfo("سورة القمر", 531, 54),
    SurahInfo("سورة الرحمن", 534, 55),
    SurahInfo("سورة الواقعة", 538, 56),
    SurahInfo("سورة الحديد", 541, 57),
    SurahInfo("سورة المجادلة", 546, 58),
    SurahInfo("سورة الحشر", 549, 59),
    SurahInfo("سورة الممتحنة", 552, 60),
    SurahInfo("سورة الصف", 555, 61),
    SurahInfo("سورة الجمعة", 557, 62),
    SurahInfo("سورة المنافقون", 558, 63),
    SurahInfo("سورة التغابن", 560, 64),
    SurahInfo("سورة الطلاق", 562, 65),
    SurahInfo("سورة التحريم", 564, 66),
    SurahInfo("سورة الملك", 566, 67),
    SurahInfo("سورة القلم", 568, 68),
    SurahInfo("سورة الحاقة", 571, 69),
    SurahInfo("سورة المعارج", 573, 70),
    SurahInfo("سورة نوح", 575, 71),
    SurahInfo("سورة الجن", 577, 72),
    SurahInfo("سورة المزمل", 579, 73),
    SurahInfo("سورة المدثر", 580, 74),
    SurahInfo("سورة القيامة", 582, 75),
    SurahInfo("سورة الإنسان", 584, 76),
    SurahInfo("سورة المرسلات", 586, 77),
    SurahInfo("سورة النبأ", 588, 78),
    SurahInfo("سورة النازعات", 589, 79),
    SurahInfo("سورة عبس", 591, 80),
    SurahInfo("سورة التكوير", 592, 81),
    SurahInfo("سورة الانفطار", 593, 82),
    SurahInfo("سورة المطففين", 594, 83),
    SurahInfo("سورة الانشقاق", 596, 84),
    SurahInfo("سورة البروج", 596, 85),
    SurahInfo("سورة الطارق", 598, 86),
    SurahInfo("سورة الأعلى", 598, 87),
    SurahInfo("سورة الغاشية", 599, 88),
    SurahInfo("سورة الفجر", 600, 89),
    SurahInfo("سورة البلد", 601, 90),
    SurahInfo("سورة الشمس", 602, 91),
    SurahInfo("سورة الليل", 603, 92),
    SurahInfo("سورة الضحى", 604, 93),
    SurahInfo("سورة الشرح", 604, 94),
    SurahInfo("سورة التين", 604, 95),
    SurahInfo("سورة العلق", 605, 96),
    SurahInfo("سورة القدر", 606, 97),
    SurahInfo("سورة البينة", 606, 98),
    SurahInfo("سورة الزلزلة", 607, 99),
    SurahInfo("سورة العاديات", 607, 100),
    SurahInfo("سورة القارعة", 607, 101),
    SurahInfo("سورة التكاثر", 608, 102),
    SurahInfo("سورة العصر", 608, 103),
    SurahInfo("سورة الهمزة", 609, 104),
    SurahInfo("سورة الفيل", 609, 105),
    SurahInfo("سورة قريش", 610, 106),
    SurahInfo("سورة الماعون", 610, 107),
    SurahInfo("سورة الكوثر", 610, 108),
    SurahInfo("سورة الكافرون", 611, 109),
    SurahInfo("سورة النصر", 611, 110),
    SurahInfo("سورة المسد", 611, 111),
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkHizbNotification(currentPage);
    });
  }

  // دالة قراءة التفسير المباشرة والمضبوطة لمعالجة هيكل الملف الحقيقي
  Future<List<VerseTafseer>> _loadPageTafseer(int pageNum) async {
    try {
      String jsonString = await rootBundle.loadString('assets/data/tafseer.json');
      final dynamic decodedData = json.decode(jsonString);

      List<VerseTafseer> resultList = [];

      if (decodedData is List) {
        for (var item in decodedData) {
          if (item['number'].toString() == pageNum.toString()) {
            resultList.add(
              VerseTafseer(
                verseText: item['text'] ?? '',
                verseNumber: int.tryParse(item['aya'].toString()) ?? 1,
                tafseerText: item['text'] ?? '',
              ),
            );
          }
        }
      } else if (decodedData is Map && decodedData['pages'] != null) {
        String pageKey = pageNum.toString();
        if (decodedData['pages'][pageKey] != null) {
          List versesJson = decodedData['pages'][pageKey];
          for (var v in versesJson) {
            resultList.add(
              VerseTafseer(
                verseText: v['text'] ?? v['verse_text'] ?? '',
                verseNumber: int.tryParse((v['aya'] ?? v['verse_number'] ?? 1).toString()) ?? 1,
                tafseerText: v['text'] ?? v['tafseer_text'] ?? '',
              ),
            );
          }
        }
      }

      return resultList;
    } catch (e) {
      debugPrint("خطأ أثناء تحميل ملف التفسير: $e");
    }
    return [];
  }

  void _checkHizbNotification(int page) {
    HizbInfo? currentHizb;
    try {
      currentHizb = hizbs.firstWhere((h) => h.pageNumber == page);
    } catch (_) {
      currentHizb = null;
    }

    if (currentHizb != null) {
      setState(() {
        hizbNotificationText = "الحزب ${currentHizb!.number}: ${currentHizb.name}";
        showHizbNotification = true;
      });

      Future.delayed(const Duration(milliseconds: 2500), () {
        if (mounted) {
          setState(() {
            showHizbNotification = false;
          });
        }
      });
    } else {
      setState(() {
        showHizbNotification = false;
      });
    }
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
                    Tab(text: 'قائمة الأحزاب (60)'),
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
                        itemCount: hizbs.length,
                        itemBuilder: (context, index) {
                          final hizb = hizbs[index];
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: const Color(0xFF1B4D3E),
                              foregroundColor: Colors.white,
                              child: Text('${hizb.number}'),
                            ),
                            title: Text(hizb.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text('الحزب ${hizb.number}'),
                            trailing: Text('صفحة ${hizb.pageNumber}'),
                            onTap: () {
                              Navigator.pop(context);
                              _pageController.jumpToPage(hizb.pageNumber - 1);
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
      backgroundColor: widget.isDarkMode ? const Color(0xFF1E1E1E) : const Color(0xFFF9F8F3),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          height: MediaQuery.of(context).size.height * 0.80,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // شريط السحب العلوي (Drag Handle)
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: widget.isDarkMode ? Colors.white24 : Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // هيدر النافذة الرئيسي
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1B4D3E).withOpacity(0.12),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.menu_book_rounded, color: Color(0xFF1B4D3E), size: 22),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'التفسير الميسر',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: widget.isDarkMode ? Colors.white : const Color(0xFF1B4D3E),
                            ),
                          ),
                          Text(
                            'صفحة $currentPage • ${currentSurah.name}',
                            style: TextStyle(
                              fontSize: 12,
                              color: widget.isDarkMode ? Colors.white54 : Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  IconButton(
                    icon: Icon(Icons.close_rounded, color: widget.isDarkMode ? Colors.white70 : Colors.black54),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Divider(height: 1, thickness: 1, color: widget.isDarkMode ? Colors.white12 : Colors.black12),
              const SizedBox(height: 12),

              // قائمة التفسير
              Expanded(
                child: FutureBuilder<List<VerseTafseer>>(
                  future: _loadPageTafseer(currentPage),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(color: Color(0xFF1B4D3E)),
                      );
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                        child: Text(
                          'التفسير غير متوفر حالياً لهذه الصفحة',
                          style: TextStyle(color: widget.isDarkMode ? Colors.white70 : Colors.black54),
                        ),
                      );
                    }

                    final pageVerses = snapshot.data!;
                    return ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: pageVerses.length,
                      itemBuilder: (context, index) {
                        final item = pageVerses[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: widget.isDarkMode ? const Color(0xFF2A2A2A) : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(widget.isDarkMode ? 0.2 : 0.04),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                            border: Border.all(
                              color: widget.isDarkMode ? Colors.white10 : const Color(0xFFEFECE6),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // رأس البطاقة: رقم الآية وزر النسخ
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: widget.isDarkMode
                                            ? const Color(0xFF1B4D3E).withOpacity(0.3)
                                            : const Color(0xFF1B4D3E).withOpacity(0.08),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        "﴿ الآية ${item.verseNumber} ﴾",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: widget.isDarkMode ? Colors.amber.shade200 : const Color(0xFF1B4D3E),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Clipboard.setData(ClipboardData(
                                            text: "الآية (${item.verseNumber})\n\nالتفسير: ${item.tafseerText}"));
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text('تم نسخ التفسير بنجاح'),
                                            behavior: SnackBarBehavior.floating,
                                            duration: Duration(seconds: 2),
                                          ),
                                        );
                                      },
                                      borderRadius: BorderRadius.circular(8),
                                      child: Padding(
                                        padding: const EdgeInsets.all(6.0),
                                        child: Row(
                                          children: const [
                                            Icon(Icons.copy_rounded, size: 16, color: Color(0xFF1B4D3E)),
                                            SizedBox(width: 4),
                                            Text(
                                              'نسخ',
                                              style: TextStyle(fontSize: 12, color: Color(0xFF1B4D3E), fontWeight: FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),

                                // نص التفسير الميسر
                                Text(
                                  item.tafseerText,
                                  style: TextStyle(
                                    fontSize: 15,
                                    height: 1.7,
                                    color: widget.isDarkMode ? Colors.white.withOpacity(0.87) : const Color(0xFF2C3E50),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
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
                _checkHizbNotification(page);
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

            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              top: showHizbNotification ? (showUI ? 80.0 : 40.0) : -80.0,
              left: MediaQuery.of(context).size.width * 0.15,
              right: MediaQuery.of(context).size.width * 0.15,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: showHizbNotification ? 1.0 : 0.0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.85),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      hizbNotificationText ?? '',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'sans-serif',
                      ),
                    ),
                  ),
                ),
              ),
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
