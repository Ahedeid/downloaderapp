import 'package:downloaderapp/screens/home_screen/home.dart';
import 'package:flutter/material.dart';

import 'screens/download_screen/downloadscreen.dart';

void main() => runApp(const DownloaderApp());

class DownloaderApp extends StatelessWidget {
  const DownloaderApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          appBarTheme: const AppBarTheme(
              backgroundColor: Colors.orange,
              iconTheme: IconThemeData(color: Colors.black),
              centerTitle: true,
              titleTextStyle: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
              shape: BeveledRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(5),
                  bottomRight: Radius.circular(5),
                ),
              ))),
      initialRoute: 'home_screen',
      routes: {
        'home_screen': (context) =>  HomeScreen(),
        'download_screen': (context) =>  const DownloadScreen(),
      },
    );
  }
}
