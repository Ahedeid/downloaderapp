import 'package:flutter/material.dart';

import 'custom_list.dart';


class HomeScreen extends StatelessWidget {
   HomeScreen({Key? key}) : super(key: key);

  List title = <String>[
    'Title 1',
    'Title 2',
    'Sound',
    'Image',
    'CV'
  ];
  var details =[
    'mp3',
    'mp4',
    'mp3',
    'png',
    'pdf'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Downloader App',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
      ),
      body:ListView.builder(
          itemCount: 5,
          itemBuilder:(context,index){
            return  CustomList(title: title[index], details: details[index],);
          } ,
      ),
    );
  }
}

