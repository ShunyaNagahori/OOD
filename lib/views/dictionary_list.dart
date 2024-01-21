import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:ood/my_colors.dart';
import 'package:ood/models/dictionary.dart';
import 'package:ood/sizes.dart';
import 'package:ood/views/item_list.dart';

class DictionaryListWidget extends StatefulWidget {
  const DictionaryListWidget({super.key});

  @override
  State<DictionaryListWidget> createState() => _DictionaryListWidgetState();
}

class _DictionaryListWidgetState extends State<DictionaryListWidget> {
  List<Dictionary> dictionaryList = [];
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();

  Future<void> initializeDictionary() async {
    dictionaryList = await Dictionary.getAllDictionaries();
  }

  Future<void> _refreshDictionaryList() async {
    dictionaryList = await Dictionary.getAllDictionaries();
    setState(() {});
  }

  @override
  void dispose() {
    _titleController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('One’s Own Dictionary'),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) {
              _titleController.clear();
              _categoryController.clear();
              return AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      '新規作成',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text('辞書のタイトル'),
                    TextField(controller: _titleController),
                    const SizedBox(height: 8),
                    const Text('カテゴリー'),
                    TextField(controller: _categoryController),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        if (_titleController.text.isNotEmpty &&
                            _categoryController.text.isNotEmpty) {
                          _saveDictionary();
                          Navigator.pop(context);
                        } else {
                          const snackBar = SnackBar(
                            content: Text('タイトルまたはカテゴリーが入力されていません'),
                            duration: Duration(seconds: 2),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      },
                      child: const Text('作成'),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: FutureBuilder(
          future: initializeDictionary(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return ListView.builder(
                itemCount: dictionaryList.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Slidable(
                        endActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          children: [
                            SlidableAction(
                              flex: 1,
                              onPressed: (context) {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      content: const Text('本当に削除しますか？'),
                                      actions: [
                                        Builder(builder: (context) {
                                          return TextButton(
                                            child: const Text("キャンセル"),
                                            onPressed: () =>
                                                Navigator.pop(context),
                                          );
                                        }),
                                        Builder(builder: (context) {
                                          return TextButton(
                                            child: const Text("削除"),
                                            onPressed: () {
                                              _deleteDictionary(
                                                  dictionaryList[index].id!);
                                              _refreshDictionaryList();
                                              Navigator.pop(context);
                                            },
                                          );
                                        }),
                                      ],
                                    );
                                  },
                                );
                              },
                              backgroundColor: MyColors.red,
                              foregroundColor: MyColors.white,
                              icon: Icons.delete,
                              label: '削除',
                            ),
                            SlidableAction(
                              flex: 1,
                              onPressed: (context) {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    _editController(dictionaryList[index].id!);
                                    return AlertDialog(
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Text(
                                            '編集',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(height: 8),
                                          const Text('辞書のタイトル'),
                                          TextField(
                                              controller: _titleController),
                                          const SizedBox(height: 8),
                                          const Text('カテゴリー'),
                                          TextField(
                                              controller: _categoryController),
                                          const SizedBox(height: 8),
                                          Builder(
                                            builder: (context) {
                                              return ElevatedButton(
                                                onPressed: () {
                                                  if (_titleController
                                                          .text.isNotEmpty &&
                                                      _categoryController
                                                          .text.isNotEmpty) {
                                                    _updateDictionary(
                                                        dictionaryList[index]);
                                                    Navigator.pop(context);
                                                  } else {
                                                    const snackBar = SnackBar(
                                                      content: Text(
                                                          'タイトルまたはカテゴリーが入力されていません'),
                                                      duration:
                                                          Duration(seconds: 2),
                                                    );
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(snackBar);
                                                  }
                                                },
                                                child: const Text('編集'),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                              backgroundColor: MyColors.gray,
                              foregroundColor: MyColors.white,
                              icon: Icons.edit,
                              label: '編集',
                            ),
                          ],
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ItemListWidget(
                                    dictionary: dictionaryList[index]),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 8),
                            decoration: BoxDecoration(
                              border:
                                  Border.all(width: 1, color: MyColors.gray),
                            ),
                            child: ListTile(
                              title: Text(
                                dictionaryList[index].title,
                                style: const TextStyle(
                                  fontSize: Sizes.m,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle:
                                  Text(dictionaryList[index].category ?? ''),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }

  void _saveDictionary() async {
    Dictionary dictionary = Dictionary(
      title: _titleController.text,
      category: _categoryController.text,
    );
    await Dictionary.saveDictionary(dictionary);
    _refreshDictionaryList();
    _titleController.clear();
    _categoryController.clear();
  }

  void _deleteDictionary(int id) async {
    await Dictionary.deleteDictionary(id);
  }

  void _updateDictionary(Dictionary dictionary) async {
    Dictionary updateDictionary = Dictionary(
      id: dictionary.id,
      title: _titleController.text,
      category: _categoryController.text,
    );

    await Dictionary.updateDictionary(updateDictionary);
    _refreshDictionaryList();
    _titleController.clear();
    _categoryController.clear();
  }

  void _editController(int id) async {
    final Dictionary? dictionary = await Dictionary.findById(id);
    if (dictionary != null) {
      _titleController.text = dictionary.title;
      _categoryController.text = dictionary.category!;
    }
  }
}
