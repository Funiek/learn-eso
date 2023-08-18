import 'package:flutter/material.dart';

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
