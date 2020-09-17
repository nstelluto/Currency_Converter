import 'package:aula09/page_principal.dart';
import 'package:flutter/material.dart';

const Url =
    'https://api.hgbrasil.com/finance/?format=json-cors&key=development';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Conversor de Moedas',
      theme: ThemeData(
        hintColor: Colors.amber,
        primaryColor: Colors.white,
      ),
      home: HomeCotacao(),
    );
  }
}
