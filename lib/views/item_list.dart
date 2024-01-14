import 'package:flutter/material.dart';
import 'package:ood/models/dictionary.dart';
import 'package:ood/models/item.dart';
import 'package:ood/views/item_form.dart';

class ItemListWidget extends StatefulWidget {
  const ItemListWidget({super.key, required this.dictionary});
  final Dictionary dictionary;

  @override
  State<ItemListWidget> createState() => _ItemListWidgetState();
}

class _ItemListWidgetState extends State<ItemListWidget> {
  List<Item> itemList = [];

  Future<void> initializeItem() async {
    itemList = await Item.getAllItems(widget.dictionary.id!.toInt());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.dictionary.title),
        actions: [
          IconButton(
            onPressed: () async {
              Navigator.of(context)
                  .push(
                MaterialPageRoute(
                  builder: (context) => ItemFormWidget(
                    dictionaryId: widget.dictionary.id!.toInt(),
                  ),
                ),
              )
                  .then((value) {
                setState(() {
                  itemList = value;
                });
              });
            },
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
        child: FutureBuilder(
          future: initializeItem(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return ListView.builder(
                itemCount: itemList.length,
                itemBuilder: ((context, index) {
                  return GestureDetector(
                    onTap: () {},
                    child: Card(
                        child: ListTile(
                      title: Text(itemList[index].title),
                    )),
                  );
                }),
              );
            }
          },
        ),
      ),
    );
  }
}
