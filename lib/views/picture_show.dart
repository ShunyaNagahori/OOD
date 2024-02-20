import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:ood/models/item_picture.dart';
import 'package:ood/models/picture.dart';
import 'package:ood/my_colors.dart';

class PictureShowWidget extends StatefulWidget {
  const PictureShowWidget(
      {super.key,
      required this.picture,
      required this.itemPictureList,
      this.isRegistered});
  final Picture picture;
  final bool? isRegistered;
  final List<Picture?> itemPictureList;

  @override
  State<PictureShowWidget> createState() => _PictureShowWidgetState();
}

class _PictureShowWidgetState extends State<PictureShowWidget> {
  late Uint8List imageData;
  bool isRegistered = false;

  @override
  void initState() {
    super.initState();
    isRegistered = widget.isRegistered ?? false;
    imageData = base64Decode(widget.picture.data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.white,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),
      body: Container(
        height: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            Expanded(child: Image.memory(imageData)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  !isRegistered
                      ? ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.of(context).pop(widget.picture);
                          },
                          child: Container(
                            width: double.infinity,
                            alignment: Alignment.center,
                            child: const Text('登録'),
                          ),
                        )
                      : ElevatedButton(
                          onPressed: () {
                            widget.itemPictureList.removeWhere(
                              (itemPicture) =>
                                  itemPicture!.id == widget.picture.id,
                            );
                            Navigator.of(context).pop(widget.itemPictureList);
                          },
                          child: Container(
                            width: double.infinity,
                            alignment: Alignment.center,
                            child: const Text('解除'),
                          ),
                        ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content: const Text('本当に削除しますか？'),
                            actions: [
                              ElevatedButton(
                                child: const Text('キャンセル'),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                              ElevatedButton(
                                child: const Text('削除'),
                                onPressed: () {
                                  _deletePicture(widget.picture.id!);
                                  Navigator.pop(context);
                                  Navigator.of(context)
                                      .pop(widget.itemPictureList);
                                  // int count = 0;
                                  // Navigator.popUntil(
                                  //     context, (_) => count++ >= 2);
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: const Text('フォルダから削除'),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _deletePicture(int id) async {
    await Picture.deletePicture(id);
  }

  void _deleteItemPicture(int itemId, int pictureId) async {
    await ItemPicture.deleteItemPicture(itemId, pictureId);
  }
}
