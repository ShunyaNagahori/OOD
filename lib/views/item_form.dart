import 'package:flutter/material.dart';
import 'package:ood/models/item.dart';

class ItemFormWidget extends StatefulWidget {
  ItemFormWidget({super.key, required this.dictionaryId, this.item});
  final int dictionaryId;
  Item? item;

  @override
  State<ItemFormWidget> createState() => _ItemFormWidgetState();
}

class _ItemFormWidgetState extends State<ItemFormWidget> {
  List<Item> itemList = [];
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _subTitleController = TextEditingController();
  final TextEditingController _textController = TextEditingController();
  bool isEditMode = false;

  @override
  void initState() {
    super.initState();
    isEditMode = widget.item != null;
    if (isEditMode) {
      _titleController.text = widget.item!.title;
      _subTitleController.text = widget.item!.subTitle!;
      _textController.text = widget.item!.text;
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
          title: Text(isEditMode ? '項目の編集' : '新しい項目の追加'),
        ),
        backgroundColor: Colors.white,
        body: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  hintText: '名前やタイトルを入力してください',
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _subTitleController,
                decoration: const InputDecoration(
                  hintText: '補足情報を入力してください',
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(width: 1),
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                  ),
                  child: TextField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    controller: _textController,
                    decoration: const InputDecoration(
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
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  void _saveItem() async {
    Item item = Item(
      title: _titleController.text,
      subTitle: _subTitleController.text,
      text: _textController.text,
      dictionaryId: widget.dictionaryId,
    );
    await Item.saveItem(item);
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
      widget.item = updateItem;
    });

    _titleController.clear();
    _subTitleController.clear();
    _textController.clear();

    return updateItem;
  }
}
