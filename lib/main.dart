import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? _selectedView;

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
          children: [
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

class TranslatorView extends StatelessWidget {
  const TranslatorView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Translator'),
      ),
    );
  }
}
