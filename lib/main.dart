import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
      home: const MainMenu(title: 'Learn English with ESO'),
    );
  }
}

class MainMenu extends StatefulWidget {
  const MainMenu({super.key, required this.title});

  final String title;

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        foregroundColor: Colors.white,
        title: Text(widget.title),
      ),
      body: Center(
        child: ListView(
          padding: const EdgeInsets.all(24),
          
          children: const <MenuButton>[
            MenuButton(inlineText: 'Przetłumacz'),
            MenuButton(inlineText: 'Lista słów'),
            MenuButton(inlineText: 'Wyczyść dane (potem Opcje)'),
            MenuButton(inlineText: 'Zamknij'),
          ],
        ),
      ),
    );
  }
}

class MenuButton extends StatelessWidget {
  const MenuButton({super.key, required this.inlineText});

  final String inlineText;

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
        onPressed: () {},
        child: Text(
          inlineText,
          style: TextStyle(color: Theme.of(context).colorScheme.surface),
        ),
      ),
    );
  }
}
