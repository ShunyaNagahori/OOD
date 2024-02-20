import 'dart:convert';
import 'dart:typed_data';
// import 'dart:math';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ood/models/picture.dart';
import 'package:ood/my_colors.dart';
import 'package:ood/views/picture_show.dart';

class PictureListWidget extends StatefulWidget {
  const PictureListWidget({super.key, required this.itemPictureList});
  final List<Picture?> itemPictureList;
  @override
  State<PictureListWidget> createState() => _PictureListWidgetState();
}

class _PictureListWidgetState extends State<PictureListWidget> {
  List<Picture> _picturesList = [];

  Future<void> initializePictures() async {
    _picturesList = await Picture.getAllPictures();
  }

  Future<void> _refreshPictures() async {
    _picturesList = await Picture.getAllPictures();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '画像の選択',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: MyColors.white,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      '画像追加',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        _pickPictureFromCamera().then((_) {
                          _refreshPictures();
                        });
                        Navigator.pop(context);
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.camera_alt,
                          ),
                          SizedBox(width: 8),
                          Text("カメラで撮る"),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.perm_media,
                          ),
                          SizedBox(width: 8),
                          Text("フォルダから取り込む"),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder(
        future: initializePictures(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              itemCount: _picturesList.length,
              itemBuilder: (context, index) {
                Uint8List imageData = base64Decode(_picturesList[index].data);
                return !widget.itemPictureList.any(
                        (picture) => picture!.id == _picturesList[index].id)
                    ? GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .push(
                            MaterialPageRoute(
                              builder: (context) => PictureShowWidget(
                                picture: _picturesList[index],
                                itemPictureList: widget.itemPictureList,
                              ),
                            ),
                          )
                              .then((_) {
                            _refreshPictures(); // FIXME: 更新したときのみリフレッシュしたい
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(1),
                          child: Image.memory(
                            imageData,
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(1),
                        child: ColorFiltered(
                          colorFilter: ColorFilter.mode(
                            Colors.white.withOpacity(0.5), // 0.5は透明度を調整します
                            BlendMode.lighten, // 適切なBlendModeを選択してください
                          ),
                          child: Image.memory(
                            imageData,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );

                // return GestureDetector(
                //   onTap: () {
                //     Navigator.of(context)
                //         .push(
                //       MaterialPageRoute(
                //         builder: (context) => PictureShowWidget(
                //           picture: _picturesList[index],
                //           itemPictureList: widget.itemPictureList,
                //         ),
                //       ),
                //     )
                //         .then((_) {
                //       _refreshPictures(); // FIXME: 更新したときのみリフレッシュしたい
                //     });
                //   },
                //   child: Padding(
                //     padding: const EdgeInsets.all(1),
                //     child: widget.itemPictureList.any(
                //             (picture) => picture!.id == _picturesList[index].id)
                //         ? ColorFiltered(
                //             colorFilter: ColorFilter.mode(
                //               Colors.white.withOpacity(0.5), // 0.5は透明度を調整します
                //               BlendMode.lighten, // 適切なBlendModeを選択してください
                //             ),
                //             child: Image.memory(
                //               imageData,
                //               fit: BoxFit.cover,
                //             ),
                //           )
                //         : Image.memory(
                //             imageData,
                //             fit: BoxFit.cover,
                //           ),
                //   ),
                // );
              },
            );
          }
        },
      ),
    );
  }

  _pickPictureFromCamera() async {
    final ImagePicker picker = ImagePicker();
    final imgFile = await picker.pickImage(source: ImageSource.camera);

    if (imgFile != null) {
      String imgString = base64Encode(await imgFile.readAsBytes());
      Picture photo = Picture(data: imgString);
      await Picture.savePicture(photo);
    }
  }
}
