import 'package:flutter/material.dart';
import 'package:ood/models/dictionary.dart';

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
                        _saveDictionary();
                        Navigator.pop(context);
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
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
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
                  return GestureDetector(
                    onTap: () {},
                    child: Card(
                      child: ListTile(
                        title: Text(dictionaryList[index].title),
                        subtitle: Text(dictionaryList[index].category),
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

  void _saveDictionary() async {
    Dictionary dictionary = Dictionary(
      title: _titleController.text,
      category: _categoryController.text,
    );
    await Dictionary.saveDictionary(dictionary);
    final List<Dictionary> dictionaries = await Dictionary.getAllDictionaries();
    setState(() {
      dictionaryList = dictionaries;
    });
    _titleController.clear();
    _categoryController.clear();
  }
}
