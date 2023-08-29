import 'package:flutter/material.dart';

class LearnWordsView extends StatefulWidget {
  const LearnWordsView({
    super.key,
    required this.setSelectedView,
  });

  final Function setSelectedView;

  @override
  State<LearnWordsView> createState() => _LearnWordsViewState();
}

class _LearnWordsViewState extends State<LearnWordsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        foregroundColor: Colors.white,
        title: const Text('Naucz się słówek'),
      ),
    );
  }
}
