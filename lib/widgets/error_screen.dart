// Widget de uso general dentro de la aplicación para mostrar mensajes
// de errores críticos dentro de la aplicación.

import 'package:flutter/material.dart';

class ErrorScreen extends StatefulWidget {
  const ErrorScreen({Key? key, required this.title, required this.description})
      : super(key: key);

  final String title;
  final String description;

  @override
  State<ErrorScreen> createState() => ErrorScreenState();
}

class ErrorScreenState extends State<ErrorScreen> {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
          Text(widget.title,
              style: TextStyle(color: theme.colorScheme.error, fontSize: 24)),
          Text(widget.description),
        ]));
  }
}
