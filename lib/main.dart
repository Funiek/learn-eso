import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './word.dart';

void main() {
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
  //final prefs = await SharedPreferences.getInstance();

  setSelectedView(selectedView) {
    setState(() {
      _selectedView = selectedView;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LearnESO',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepOrange,
          primary: Colors.grey,
          secondary: Colors.deepOrange,
        ),
        useMaterial3: true,
      ),
      // home: const MainMenu(title: 'Learn English with ESO'),
      home: Navigator(
        pages: [
          MaterialPage(
              child: MainMenu(
            title: 'Learn English with ESO',
            setSelectedView: setSelectedView,
          )),
          if (_selectedView == 'Translator')
            const MaterialPage(child: TranslatorView())
        ],
        onPopPage: (route, result) {
          setSelectedView(null);
          return route.didPop(result);
        },
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
                func: setSelectedView),
            const SizedBox(
              height: 10,
            ),
            MenuButton(
                inlineText: 'Lista słów',
                viewName: 'WordsList',
                func: setSelectedView),
            const SizedBox(
              height: 10,
            ),
            MenuButton(
                inlineText: 'Wyczyść dane (potem Opcje)',
                viewName: 'ClearData',
                func: setSelectedView),
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

class MenuButton extends StatelessWidget {
  const MenuButton(
      {super.key, required this.inlineText, this.viewName, required this.func});

  final String inlineText;
  final String? viewName;
  final Function func;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        border: Border.all(
          color: Theme.of(context).colorScheme.primary,
          width: 4,
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(30),
        ),
      ),
      child: TextButton(
        child: Text(
          inlineText,
          style: TextStyle(color: Theme.of(context).colorScheme.surface),
        ),
        onPressed: () {
          if (viewName != null) {
            func(viewName);
          } else {
            func();
          }
        },
      ),
    );
  }
}

class TranslatorView extends StatefulWidget {
  const TranslatorView({super.key});

  @override
  State<TranslatorView> createState() => _TranslatorViewState();
}

class _TranslatorViewState extends State<TranslatorView> {
  final TextEditingController textController = TextEditingController();

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        foregroundColor: Colors.white,
        title: const Text('Translator'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding:
                const EdgeInsets.only(left: 8, top: 16, right: 8, bottom: 4),
            child: TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Wpisz słowo do przetłumaczenia',
              ),
              controller: textController,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: TextButton(
              onPressed: () {
                Word word = Word(1, textController.text, 'b', 'abc');
                String str = jsonEncode(word.toJson());
                print(str);
                final parsed = jsonDecode(str);
                Word decodedWord = Word.fromJson(parsed);

                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: Text(decodedWord.original),
                    );
                  },
                );
              },
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      Theme.of(context).colorScheme.secondary)),
              child: Text(
                'Tłumacz',
                style: TextStyle(color: Theme.of(context).colorScheme.surface),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
