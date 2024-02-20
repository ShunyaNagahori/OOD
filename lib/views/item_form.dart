import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:ood/models/item.dart';
import 'package:ood/models/item_picture.dart';
import 'package:ood/models/picture.dart';
import 'package:ood/my_colors.dart';
import 'package:ood/views/picture_list.dart';
import 'package:ood/views/picture_show.dart';

class ItemFormWidget extends StatefulWidget {
  ItemFormWidget({super.key, required this.dictionaryId, this.item});
  final int dictionaryId;
  Item? item;

  @override
  State<ItemFormWidget> createState() => _ItemFormWidgetState();
}

class _ItemFormWidgetState extends State<ItemFormWidget> {
  List<Item> itemList = [];
  List<Picture?> itemPictureList = [];

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _subTitleController = TextEditingController();
  final TextEditingController _textController = TextEditingController();
  bool isEditMode = false;

  @override
  void initState() {
    super.initState();
    isEditMode = widget.item != null;
    if (isEditMode) {
      _loadItemData();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _subTitleController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (bool didPop) {},
      child: Scaffold(
        appBar: AppBar(
          title: Text(isEditMode ? '項目の編集' : '新しい項目の追加',
              style: const TextStyle(
                  color: MyColors.white, fontWeight: FontWeight.bold)),
          backgroundColor: MyColors.brown,
          iconTheme: const IconThemeData(
            color: MyColors.white,
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.add_photo_alternate),
              onPressed: () {
                Navigator.of(context)
                    .push(
                  MaterialPageRoute(
                    builder: (context) =>
                        PictureListWidget(itemPictureList: itemPictureList),
                  ),
                )
                    .then((value) {
                  if (value != null &&
                      !itemPictureList
                          .any((picture) => picture!.id == value.id)) {
                    setState(() {
                      itemPictureList.add(value);
                    });
                  }
                });
              },
            ),
          ],
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        filled: false,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                        hintText: '名前やタイトルを入力してください',
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black,
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _subTitleController,
                      decoration: const InputDecoration(
                        filled: false,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                        hintText: '補足情報を入力してください',
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black,
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (itemPictureList.isNotEmpty)
                      Column(
                        children: [
                          SizedBox(
                            height: 100,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: itemPictureList.length,
                              itemBuilder: (context, index) {
                                Uint8List imageData =
                                    base64Decode(itemPictureList[index]!.data);
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) => PictureShowWidget(
                                        picture: itemPictureList[index]!,
                                        itemPictureList: itemPictureList,
                                        isRegistered: true,
                                      ),
                                    ))
                                        .then((value) {
                                      if (value != null) {
                                        setState(() {
                                          itemPictureList = value;
                                        });
                                      }
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(1),
                                    child: Image.memory(
                                      imageData,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(width: 1),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                        ),
                        child: TextField(
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          controller: _textController,
                          decoration: const InputDecoration(
                            filled: false,
                            contentPadding: EdgeInsets.symmetric(horizontal: 8),
                            border: InputBorder.none,
                            hintText: '詳細を入力してください',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        if (_titleController.text.isNotEmpty &&
                            _textController.text.isNotEmpty) {
                          if (isEditMode) {
                            _updateItem().then((Item updateItem) {
                              Navigator.of(context).pop(updateItem);
                            });
                          } else {
                            _saveItem();
                            Navigator.of(context).pop(itemList);
                          }
                        } else {
                          const snackBar = SnackBar(
                            content: Text('タイトルまたは本文が入力されていません'),
                            duration: Duration(seconds: 2),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                      ),
                      child: Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        child: Text(isEditMode ? '更新' : '登録'),
                      ),
                    ),
                    SizedBox(height: isEditMode ? 8 : 16),
                    if (isEditMode)
                      Column(
                        children: [
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
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                      ),
                                      ElevatedButton(
                                        child: const Text('削除'),
                                        onPressed: () {
                                          _deleteItem(widget.item!.id!);
                                          int count = 0;
                                          Navigator.popUntil(
                                              context, (_) => count++ >= 3);
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
                              child: const Text('削除'),
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _loadItemData() async {
    _titleController.text = widget.item!.title;
    _subTitleController.text = widget.item!.subTitle!;
    _textController.text = widget.item!.text;

    List<ItemPicture> itemPictures =
        await ItemPicture.getItemPicturesByItemId(widget.item!.id!);

    for (ItemPicture itemPicture in itemPictures) {
      Picture? picture = await Picture.findById(itemPicture.pictureId);
      if (picture != null && !itemPictureList.any((p) => p!.id == picture.id)) {
        setState(() {
          itemPictureList.add(picture);
        });
      }
    }

    print(itemPictureList);
  }

  void _saveItem() async {
    Item item = Item(
      title: _titleController.text,
      subTitle: _subTitleController.text,
      text: _textController.text,
      dictionaryId: widget.dictionaryId,
    );

    int itemId = await Item.saveItem(item);

    if (itemPictureList.isNotEmpty) {
      for (Picture? picture in itemPictureList) {
        if (picture != null) {
          await ItemPicture.saveItemPicture(
            ItemPicture(itemId: itemId, pictureId: picture.id!),
          );
        }
      }
    }

    final List<Item> items = await Item.getAllItems(widget.dictionaryId);
    setState(() {
      itemList = items;
    });
    _titleController.clear();
    _subTitleController.clear();
    _textController.clear();
  }

  Future<Item> _updateItem() async {
    Item updateItem = Item(
      id: widget.item!.id,
      title: _titleController.text,
      subTitle: _subTitleController.text,
      text: _textController.text,
      dictionaryId: widget.dictionaryId,
    );
    await Item.updateItem(updateItem);

    setState(() {
      widget.item = updateItem; // FIXME: 直接widget.itemを変更しているので、修正したい
    });

    _titleController.clear();
    _subTitleController.clear();
    _textController.clear();

    return updateItem;
  }

  void _deleteItem(int id) async {
    await Item.deleteItem(id);
  }
}
