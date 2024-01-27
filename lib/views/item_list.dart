import 'package:flutter/material.dart';
import 'package:ood/models/dictionary.dart';
import 'package:ood/models/item.dart';
import 'package:ood/my_colors.dart';
import 'package:ood/sizes.dart';
import 'package:ood/views/item_form.dart';
import 'package:ood/views/item_show.dart';
import 'package:ood/widgets/tategaki.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class ItemListWidget extends StatefulWidget {
  const ItemListWidget({super.key, required this.dictionary});
  final Dictionary dictionary;

  @override
  State<ItemListWidget> createState() => _ItemListWidgetState();
}

class _ItemListWidgetState extends State<ItemListWidget> {
  List<Item> itemList = [];
  String searchWord = '';
  final TextEditingController _searchController = TextEditingController();

  Future<void> initializeItem() async {
    if (searchWord.isEmpty) {
      itemList = await Item.getAllItems(widget.dictionary.id!.toInt());
    } else {
      List<Item>? results = await Item.findByWord(searchWord);
      if (results != null) {
        itemList = results;
      } else {
        itemList = [];
      }
    }
  }

  Future<void> _refreshItemList() async {
    itemList = await Item.getAllItems(widget.dictionary.id!.toInt());
    setState(() {});
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          searchWord.isNotEmpty ? "検索： $searchWord" : widget.dictionary.title,
          style: const TextStyle(
              color: MyColors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: MyColors.brown,
        iconTheme: const IconThemeData(
          color: MyColors.white,
        ),
        actions: [
          if (searchWord.isNotEmpty)
            IconButton(
              onPressed: () async {
                setState(() {
                  searchWord = '';
                });
                _searchController.clear();
              },
              icon: const Icon(Icons.clear),
            ),
        ],
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        children: [
          SpeedDialChild(
            child: Icon(Icons.share_rounded),
            label: '共有',
            backgroundColor: MyColors.yellowBrown,
            onTap: () {
              print('Share Tapped');
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.add),
            label: '新規作成',
            backgroundColor: MyColors.yellowBrown,
            onTap: () {
              Navigator.of(context)
                  .push(
                MaterialPageRoute(
                  builder: (context) => ItemFormWidget(
                    dictionaryId: widget.dictionary.id!.toInt(),
                  ),
                ),
              )
                  .then(
                (value) {
                  if (value != null) {
                    setState(() {
                      itemList = value;
                    });
                  }
                },
              );
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.search),
            label: '検索',
            backgroundColor: MyColors.yellowBrown,
            onTap: () {
              showDialog(
                  context: context,
                  builder: (_) {
                    return AlertDialog(
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 8),
                          TextField(controller: _searchController),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () {
                              if (_searchController.text.isNotEmpty) {
                                setState(() {
                                  searchWord = _searchController.text;
                                });
                                Navigator.pop(context);
                              } else {
                                const snackBar = SnackBar(
                                  content: Text('検索ワードが入力されていません'),
                                  duration: Duration(seconds: 2),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              }
                            },
                            child: const Text('検索'),
                          ),
                        ],
                      ),
                    );
                  });
            },
          ),
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
                      Navigator.of(context)
                          .push(
                        MaterialPageRoute(
                          builder: (context) =>
                              ItemShowWidget(item: itemList[index]),
                        ),
                      )
                          .then((value) {
                        _refreshItemList(); // FIXME: 更新したときのみリフレッシュしたい
                      });
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
