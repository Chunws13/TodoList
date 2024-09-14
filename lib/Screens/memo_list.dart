import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../database.dart';
import '../Screens/create_memo.dart';

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
  Future<void> _completeItem(Map<String, dynamic> item) async {
    final completeItem = {...item, 'status': (item['status'] + 1) % 2};
    await DatabaseHelper.instance.updateTodo(completeItem);
    widget.updatedItem();
  }

  Future<void> _deleteItem(Map<String, dynamic> item) async {
    await DatabaseHelper.instance.deleteTodo(item['id']);
    widget.updatedItem();
  }

  Future<void> _updateItem(Map<String, dynamic> item) async {
    final updateContent = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CreateMemo(content: item['content'])));

    final updateItem = {...item, 'content': updateContent};
    await DatabaseHelper.instance.updateTodo(updateItem);
    widget.updatedItem();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: widget.items.length,
        itemBuilder: (context, index) {
          final item = widget.items[index];
          return EachMemo(
            item: item,
            complete: _completeItem,
            delete: _deleteItem,
            update: _updateItem,
          );
        });
  }
}

class EachMemo extends StatelessWidget {
  const EachMemo({
    super.key,
    required this.item,
    required this.complete,
    required this.delete,
    required this.update,
  });

  final Map<String, dynamic> item;
  final Future<void> Function(Map<String, dynamic>) complete;
  final Future<void> Function(Map<String, dynamic>) delete;
  final Future<void> Function(Map<String, dynamic>) update;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      child: Slidable(
        key: ValueKey(item['id'].toString()),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          extentRatio: 0.4,
          children: [
            const SizedBox(
              width: 5,
            ),
            SlidableAction(
                onPressed: (BuildContext context) => update(item),
                backgroundColor: Colors.green,
                borderRadius: BorderRadius.circular(12),
                icon: Icons.edit),
            const SizedBox(
              width: 5,
            ),
            SlidableAction(
              onPressed: (BuildContext context) => delete(item),
              backgroundColor: Colors.red,
              borderRadius: BorderRadius.circular(12),
              icon: Icons.delete,
            ),
          ],
        ),
        child: InkWell(
          onTap: () => complete(item),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: item['status'] == 1 ? Colors.green : Colors.amber,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              item['content'],
            ),
          ),
        ),
      ),
    );
  }
}
