import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  String? _selectedView;
  final String googleTranslationApiKey =
      dotenv.env['GOOGLE_TRANSLATION_API_KEY'] ?? '';

  setSelectedView(selectedView) {
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
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepOrange,
            primary: Colors.grey,
            secondary: Colors.deepOrange,
          ),
          useMaterial3: true,
        ),
        home: Navigator(
          pages: [
            MaterialPage(
              child: MainMenu(
                title: 'Learn English with ESO',
                setSelectedView: setSelectedView,
              ),
            ),
            if (_selectedView == 'Translator')
              MaterialPage(
                child: TranslatorView(setSelectedView: setSelectedView),
              )
            else if (_selectedView == 'WordsList')
              MaterialPage(
                child: WordsListView(setSelectedView: setSelectedView),
              )
            else if (_selectedView == 'LearnWords')
              MaterialPage(
                child: LearnWordsView(setSelectedView: setSelectedView),
              )
            else if (_selectedView == 'Options')
              MaterialPage(
                child: OptionsView(setSelectedView: setSelectedView),
              )
          ],
          onPopPage: (route, result) {
            setSelectedView(null);
            return route.didPop(result);
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
        backgroundColor: Theme.of(context).colorScheme.secondary,
        foregroundColor: Colors.white,
        title: Text(title),
      ),
      body: Center(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            MenuButton(
              inlineText: 'Przetłumacz',
              viewName: 'Translator',
              func: setSelectedView,
            ),
            const SizedBox(
              height: 10,
            ),
            MenuButton(
              inlineText: 'Lista słów',
              viewName: 'WordsList',
              func: setSelectedView,
            ),
            const SizedBox(
              height: 10,
            ),
            MenuButton(
              inlineText: 'Ucz się słówek',
              viewName: 'LearnWords',
              func: setSelectedView,
            ),
            const SizedBox(
              height: 10,
            ),
            MenuButton(
              inlineText: 'Opcje',
              viewName: 'Options',
              func: setSelectedView,
            ),
            const SizedBox(
              height: 10,
            ),
            MenuButton(
              inlineText: 'Zamknij',
              func: () => SystemNavigator.pop(),
            ),
          ],
        ),
      ),
    );
  }
}
