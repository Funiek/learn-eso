import 'package:flutter/material.dart';
import 'package:learneso/menu_button.dart';
import 'package:learneso/helpers/database_helper.dart';
import 'package:fluttertoast/fluttertoast.dart';

class OptionsView extends StatefulWidget {
  const OptionsView({
    super.key,
    required this.setSelectedView,
  });

  final Function setSelectedView;

  @override
  State<OptionsView> createState() => _OptionsViewState();
}

class _OptionsViewState extends State<OptionsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        foregroundColor: Colors.white,
        title: const Text('Opcje'),
      ),
      body: Center(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            MenuButton(
              inlineText: 'Wyczyść słownik',
              func: () async {
                DatabaseHelper.instance.removeAll();

                await Fluttertoast.showToast(
                  msg: 'Słowa usunięte',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
              },
            ),
            const SizedBox(
              height: 10,
            ),
            MenuButton(
              inlineText: 'Cofnij',
              viewName: '',
              func: widget.setSelectedView,
            ),
          ],
        ),
      ),
    );
  }
}
