import 'package:flutter/material.dart';
import 'package:ood/models/item.dart';
import 'package:ood/sizes.dart';
import 'package:ood/views/item_form.dart';

class ItemShowWidget extends StatefulWidget {
  ItemShowWidget({super.key, required this.item});
  Item item;
  @override
  State<ItemShowWidget> createState() => _ItemShowWidgetState();
}

class _ItemShowWidgetState extends State<ItemShowWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.star),
            onPressed: () {},
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.edit),
        onPressed: () {
          Navigator.of(context)
              .push(
            MaterialPageRoute(
              builder: (context) => ItemFormWidget(
                  dictionaryId: widget.item.dictionaryId, item: widget.item),
            ),
          )
              .then((value) {
            if (value != null) {
              setState(() {
                widget.item = value;
              });
            }
          });
        },
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(bottom: 16),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.item.title,
                        style: const TextStyle(
                          fontSize: Sizes.xl,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (widget.item.subTitle != null &&
                          widget.item.subTitle!.isNotEmpty)
                        Text(
                          '【${widget.item.subTitle}】',
                          style: const TextStyle(
                            fontSize: Sizes.l,
                          ),
                        ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 10),
                  child: Column(
                    children: [
                      Text(
                        widget.item.text,
                        style: const TextStyle(
                          fontSize: Sizes.m,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
