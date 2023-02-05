import 'package:flutter/material.dart';


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

class CustomList extends StatelessWidget {
  String title;
  String details;

   CustomList({
    required this.title,
     required this.details,
  });



  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
        Text(title,style: const TextStyle(fontSize: 18),),
        Text(details,),
      ],),
      onTap: (){
        Navigator.pushNamed(context, 'download_screen');
      },
      trailing: IconButton(
        onPressed: (){
          Navigator.pushNamed(context, 'download_screen');
        },
        icon: const Icon(Icons.download_for_offline_outlined),
      ),
    );
  }
}
