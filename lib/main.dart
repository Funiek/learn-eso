import 'dart:io';

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
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Future<void> main() async {
  await dotenv.load();
  WidgetsFlutterBinding.ensureInitialized();

  if (!Platform.isAndroid && !Platform.isIOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

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
            setSelectedView(ViewEnum.none);
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
              viewName: ViewEnum.translator,
              func: setSelectedView,
            ),
            const SizedBox(
              height: 10,
            ),
            MenuButton(
              inlineText: 'Lista słów',
              viewName: ViewEnum.wordsList,
              func: setSelectedView,
            ),
            const SizedBox(
              height: 10,
            ),
            MenuButton(
              inlineText: 'Ucz się słówek',
              viewName: ViewEnum.learnWords,
              func: setSelectedView,
            ),
            const SizedBox(
              height: 10,
            ),
            MenuButton(
              inlineText: 'Opcje',
              viewName: ViewEnum.options,
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
