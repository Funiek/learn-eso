import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:learneso/enums/view_enum.dart';
import 'views/options_view.dart';
import 'package:learneso/views/learn_words_view.dart';
import 'views/translator_view.dart';
import 'views/words_list_view.dart';
import 'package:google_translator/google_translator.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'menu_button.dart';

Future<void> main() async {
  await dotenv.load();
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ViewEnum _selectedView = ViewEnum.none;
  final String googleTranslationApiKey =
      dotenv.env['GOOGLE_TRANSLATION_API_KEY'] ?? '';

  void setSelectedView(ViewEnum selectedView) {
    setState(() {
      _selectedView = selectedView;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GoogleTranslatorInit(
      googleTranslationApiKey,
      translateFrom: const Locale('en'),
      translateTo: const Locale('pl'),
      builder: () => MaterialApp(
        title: 'LearnESO',
        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          scaffoldBackgroundColor: const Color(0xFF111111), // Deep Obsidian Void Black
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFF8E8E8E), // Akatosh Silver/Stone Grey
            secondary: Color(0xFFD4AF37), // Elder Scrolls Imperial Gold
            surface: Color(0xFF1E1E1E), // Dark Slate Menu Background
            onPrimary: Colors.black,
            onSecondary: Colors.black,
          ),
          cardTheme: const CardThemeData(
            color: Color(0xFFF5E6CC), // Warm Ancient Parchment Cream
            surfaceTintColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16)),
              side: BorderSide(
                color: Color(0xFFC4B18B), // Aged Parchment Edge/Dust Border
                width: 1.5,
              ),
            ),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF1E1E1E),
            foregroundColor: Color(0xFFD4AF37), // Gold Title
            elevation: 3,
            centerTitle: true,
          ),
        ),
        home: Navigator(
          pages: [
            MaterialPage(
              child: MainMenu(
                title: 'Learn English with ESO',
                setSelectedView: setSelectedView,
              ),
            ),
            if (_selectedView == ViewEnum.translator)
              MaterialPage(
                child: TranslatorView(setSelectedView: setSelectedView),
              )
            else if (_selectedView == ViewEnum.wordsList)
              MaterialPage(
                child: WordsListView(setSelectedView: setSelectedView),
              )
            else if (_selectedView == ViewEnum.learnWords)
              MaterialPage(
                child: LearnWordsView(setSelectedView: setSelectedView),
              )
            else if (_selectedView == ViewEnum.options)
              MaterialPage(
                child: OptionsView(setSelectedView: setSelectedView),
              )
          ],
          onDidRemovePage: (page) {
          },
        ),
      ),
    );
  }
}

class MainMenu extends StatelessWidget {
  const MainMenu({
    super.key,
    required this.title,
    required this.setSelectedView,
  });

  final String title;
  final Function setSelectedView;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            MenuButton(
              inlineText: 'Przetłumacz',
              viewName: ViewEnum.translator,
              func: setSelectedView,
              icon: Icons.translate,
            ),
            const SizedBox(
              height: 12,
            ),
            MenuButton(
              inlineText: 'Lista słów',
              viewName: ViewEnum.wordsList,
              func: setSelectedView,
              icon: Icons.list_alt,
            ),
            const SizedBox(
              height: 12,
            ),
            MenuButton(
              inlineText: 'Ucz się słówek',
              viewName: ViewEnum.learnWords,
              func: setSelectedView,
              icon: Icons.school,
            ),
            const SizedBox(
              height: 12,
            ),
            MenuButton(
              inlineText: 'Opcje',
              viewName: ViewEnum.options,
              func: setSelectedView,
              icon: Icons.settings,
            ),
            const SizedBox(
              height: 12,
            ),
            MenuButton(
              inlineText: 'Zamknij',
              func: () => SystemNavigator.pop(),
              icon: Icons.exit_to_app,
            ),
          ],
        ),
      ),
    );
  }
}
