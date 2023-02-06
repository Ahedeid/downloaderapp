


import 'package:flutter/material.dart';

class CustomList extends StatelessWidget {
  String title;
  String details;

  CustomList({super.key,
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
