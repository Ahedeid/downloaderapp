import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

List<String> list = <String>['.mp3', '.mp4', '.pdf', '.png'];


class DownloadScreen extends StatefulWidget {
  const DownloadScreen({Key? key}) : super(key: key);

  @override
  State<DownloadScreen> createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreen> {

  String dropdownValue = list.first;

  final Dio dio = Dio();
  bool loading = false;
  double progress = 0;

  TextEditingController controller = TextEditingController();
  TextEditingController controllerName = TextEditingController();

  Future<bool> saveVideo(String url, String fileName) async {
    Directory? directory;
    try {
      if (Platform.isAndroid) {
        if (await _requestPermission(Permission.storage)) {
          directory = await getExternalStorageDirectory();
          String newPath = "";
          print(directory);
          List<String> paths = directory!.path.split("/");
          for (int x = 1; x < paths.length; x++) {
            String folder = paths[x];
            if (folder != "Android") {
              newPath += "/" + folder;
            } else {
              break;
            }
          }
          newPath = newPath + "/LocalStoriegApp";
          directory = Directory(newPath);
        } else {
          return false;
        }
      } else {
        if (await _requestPermission(Permission.photos)) {
          directory = await getTemporaryDirectory();
        } else {
          return false;
        }
      }
      File saveFile = File(directory.path + "/$fileName");
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }
      if (await directory.exists()) {
        await dio.download(url, saveFile.path,
            onReceiveProgress: (downloaded, totalSize) {
          setState(() {
            progress = -(downloaded / totalSize);
          });
        });
        if (Platform.isIOS) {
          await ImageGallerySaver.saveFile(saveFile.path,
              isReturnPathOfIOS: true);
        }
        return true;
      }
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
    }
    return false;
  }

  downloadFile() async {
    setState(() {
      loading = true;
      progress = 0;
    });
    bool downloaded = await saveVideo(
        controller.text,
        // "https://www.learningcontainer.com/wp-content/uploads/2020/05/sample-mp4-file.mp4",
        controllerName.text + dropdownValue);
    if (downloaded) {
      print("File Downloaded");
    } else {
      print("Problem Downloading File");
    }
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Details'),
        ),
        body: Center(
          child: loading
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(children:    [
                    const CircularProgressIndicator(
                      backgroundColor: Colors.black,
                      valueColor: AlwaysStoppedAnimation(Colors.orange),
                      strokeWidth: 10,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    LinearProgressIndicator(
                      backgroundColor: Colors.black,
                      valueColor:  AlwaysStoppedAnimation(Colors.orange),
                      minHeight: 10,
                      value: progress,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text('${(progress / 100000).toStringAsFixed(1)}+%',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                  ]))
              : Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                  child: Column(
                    children: [
                      Material(
                        elevation: 5,
                        borderRadius:
                        const BorderRadius.all(Radius.circular(15)),
                        child: TextField(
                          controller: controllerName,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                            prefixIconConstraints:
                            BoxConstraints.tightFor(width: 45, height: 45),
                            hintText: 'Named',
                            alignLabelWithHint: true,
                            filled: true,
                            fillColor: Colors.white,
                            hintStyle: TextStyle(fontSize: 14),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.all(
                                Radius.circular(15),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Material(
                        elevation: 5,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15)),
                        child: TextField(
                          controller: controller,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                            prefixIconConstraints:
                                BoxConstraints.tightFor(width: 45, height: 45),
                            hintText: 'Write The URL',
                            alignLabelWithHint: true,
                            filled: true,
                            fillColor: Colors.white,
                            hintStyle: TextStyle(fontSize: 14),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.all(
                                Radius.circular(15),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                       CustomDropdownButton(dropdownValue: dropdownValue, ChangedDrop: (String? value) {
                           setState(() {
                             dropdownValue = value!;
                             print(dropdownValue);
                           }
                           );
                       },),

                      const SizedBox(height: 15),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                          ),
                          onPressed: downloadFile,
                          child: const Text('DownLoade')),
                    ],
                  ),
                ),
        ));
  }
}


class CustomDropdownButton extends StatefulWidget {
   CustomDropdownButton({required this.dropdownValue,required this.ChangedDrop});
  String dropdownValue;
  Function(String? value) ChangedDrop;

  @override
  State<CustomDropdownButton> createState() => _CustomDropdownButtonState();
}

class _CustomDropdownButtonState extends State<CustomDropdownButton> {

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: widget.dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: widget.ChangedDrop,
      items: list.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
