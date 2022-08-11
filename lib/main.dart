import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(const GetMaterialApp(
    title: "Getx Video",
    home: TedxApp(),
  ));
}

class TedxApp extends StatelessWidget {
  const TedxApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column();
  }
}
