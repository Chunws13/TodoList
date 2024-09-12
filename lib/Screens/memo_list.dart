import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../database.dart';

class MemoList extends StatefulWidget {
  const MemoList({
    super.key,
    required this.items,
    required this.updatedItem,
  });

  final List<Map<String, dynamic>> items;
  final void Function() updatedItem;

  @override
  State<MemoList> createState() => _MemoListState();
}

class _MemoListState extends State<MemoList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: widget.items.length,
        itemBuilder: (context, index) {
          final item = widget.items[index];
          return EachMemo(
            item: item,
            onTap: () async {
              final updatedItem = {
                ...item,
                'status': (item['status'] + 1) % 2,
              };
              await DatabaseHelper.instance.updateTodo(updatedItem);
              widget.updatedItem();
            },
          );
        });
  }
}

class EachMemo extends StatelessWidget {
  const EachMemo({
    super.key,
    required this.item,
    required this.onTap,
  });

  final Map<String, dynamic> item;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: ValueKey(item['id'].toString()),
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) async {},
            label: "Edit",
            icon: Icons.archive,
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 8),
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: BoxDecoration(
            color: item['status'] == 1 ? Colors.green : Colors.amber,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            item['content'],
          ),
        ),
      ),
    );
  }
}
