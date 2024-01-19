import 'package:flutter/material.dart';
import 'package:ood/models/dictionary.dart';
import 'package:ood/models/item.dart';
import 'package:ood/sizes.dart';
import 'package:ood/views/item_form.dart';
import 'package:ood/views/item_show.dart';
import 'package:ood/widgets/tategaki.dart';

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
                scrollDirection: Axis.horizontal,
                reverse: true,
                itemCount: itemList.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              ItemShowWidget(item: itemList[index]),
                        ),
                      );
                    },
                    child: SingleChildScrollView(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 0,
                          horizontal: 12,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.only(top: 10),
                              child: Tategaki(
                                itemList[index].text,
                                fontSize: Sizes.m,
                                space: 5,
                              ),
                            ),
                            Column(
                              children: [
                                Tategaki(
                                  itemList[index].title,
                                  fontWeight: FontWeight.bold,
                                  fontSize: Sizes.l,
                                  space: 5,
                                ),
                                Tategaki(
                                  itemList[index].subTitle == null ||
                                          itemList[index].subTitle!.isEmpty
                                      ? ''
                                      : '【${itemList[index].subTitle}】',
                                  fontSize: Sizes.m,
                                  space: 5,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
