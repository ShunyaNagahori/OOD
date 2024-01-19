import 'package:flutter/material.dart';
import 'package:ood/models/item.dart';
import 'package:ood/sizes.dart';

class ItemShowWidget extends StatefulWidget {
  const ItemShowWidget({super.key, required this.item});
  final Item item;
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
        child: Icon(Icons.edit),
        onPressed: () {},
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
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Text(
                          widget.item.title,
                          style: const TextStyle(
                            fontSize: Sizes.xl,
                            fontWeight: FontWeight.bold,
                          ),
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
                  padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
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
