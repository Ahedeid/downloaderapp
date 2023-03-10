import 'dart:io';
import 'package:dio/dio.dart';
import 'package:downloaderapp/screens/download_screen/widget/custom_loading.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'widget/custom_dropdown.dart';


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
  File? newPath2 ;
  Directory? directory ;

  TextEditingController controller = TextEditingController();
  TextEditingController controllerName = TextEditingController();

  Future<bool> saveFile(String url, String fileName) async {
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
              newPath += "/$folder";
              print(newPath);
            } else {
              break;
            }
          }
          newPath = "$newPath/LocalStoriegApp";

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
      File saveFile = File("${directory.path}/$fileName");
      newPath2 = saveFile ;

      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }
      if (await directory.exists()) {
        await dio.download(url, saveFile.path,
            onReceiveProgress: (downloaded, totalSize) {
          setState(() {
            progress = downloaded / totalSize;
            // print(progress);
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
    bool downloaded = await saveFile(
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
      OpenFile.open(newPath2?.path);
    });
  }

  bool isURl(String url) {
    return RegExp(
            r'^((?:.|\n)*?)((http://www\.|https://www\.|http://|https://)?[a-z\d]+([\-.]{1}[a-z\d]+)([-A-Z\d.]+)(/[-A-Z\d+&@#/%=~_|!:,.;]*)?(\?[A-Z\d+&@#/%=~_|!:??????,.;]*)?)')
        .hasMatch(url);
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                  child: Column(
                    children: [
                      CustomLoading(progress: progress),
                      ElevatedButton(
                        onPressed: () {},
                        child: const Text('cansel'),
                      ),
                    ],
                  ),
                )
              : Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                  child: Form(
                    child: Column(
                      children: [
                        Material(
                          elevation: 5,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15)),
                          child: TextFormField(
                            controller: controllerName,
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 20),
                              prefixIconConstraints: BoxConstraints.tightFor(
                                  width: 45, height: 45),
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
                              prefixIconConstraints: BoxConstraints.tightFor(
                                  width: 45, height: 45),
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
                        CustomDropdownButton(
                          dropdownValue: dropdownValue,
                          ChangedDrop: (String? value) {
                            setState(() {
                              dropdownValue = value!;
                              print(dropdownValue);
                            });
                          },
                        ),
                        const SizedBox(height: 15),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                            ),
                            onPressed: isURl(controller.text) == true
                                ? downloadFile
                                : () => print('Wrong URl'),
                            child: const Text('DownLoad')),
                      ],
                    ),
                  ),
                ),
        ));
  }
}
