import 'package:flutter/material.dart';
import 'package:ood/models/item.dart';

class ItemFormWidget extends StatefulWidget {
  const ItemFormWidget({super.key, required this.dictionaryId});
  final int dictionaryId;

  @override
  State<ItemFormWidget> createState() => _ItemFormWidgetState();
}

class _ItemFormWidgetState extends State<ItemFormWidget> {
  List<Item> itemList = [];
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('新しい項目の追加'),
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
                _saveItem(widget.dictionaryId);
                Navigator.of(context).pop(itemList);
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero,
              ),
              child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                child: const Text('登録'),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _saveItem(int dictionaryId) async {
    Item item = Item(
      title: _titleController.text,
      text: _textController.text,
      dictionaryId: dictionaryId,
    );
    await Item.saveItem(item);
    final List<Item> items = await Item.getAllItems(dictionaryId);
    setState(() {
      itemList = items;
    });
    _titleController.clear();
    _textController.clear();
  }
}
