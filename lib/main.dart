// Copyright 2019 the Dart project authors. All rights reserved.
// Use of this source code is governed by a BSD-style license
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:table_calendar/table_calendar.dart';
import 'database.dart';
import 'Screens/create_memo.dart';
import 'Screens/memo_list.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('ko', ''),
        Locale('en', ''),
      ],
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  String _memoDay = DateTime.now().toString().split(' ')[0];
  final ValueNotifier<List<Map<String, dynamic>>> _todoListNotifier =
      ValueNotifier([]);

  @override
  void initState() {
    super.initState();
    _requestDateTodoList();
  }

  void _onDaySelected(DateTime selecetedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selecetedDay;
      _focusedDay = focusedDay;
      _memoDay = _selectedDay.toString().split(' ')[0];
      _requestDateTodoList();
    });
  }

  Future<void> _requestDateTodoList() async {
    final data = await DatabaseHelper.instance.readDateTodo(_memoDay);
    _todoListNotifier.value = data;
  }

  Future<void> _createMemo() async {
    final result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => const CreateMemo()));

    if (result != null) {
      _memoDay = _selectedDay.toString().split(' ')[0];
      await DatabaseHelper.instance.createTodo(_memoDay, result);
      _requestDateTodoList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("메모 앱"),
      ),
      body: Center(
        child: Column(
          children: [
            TableCalendar(
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: _onDaySelected,
            ),
            const SizedBox(
              height: 20,
            ),
            ValueListenableBuilder<List<Map<String, dynamic>>>(
                valueListenable: _todoListNotifier,
                builder: (context, items, _) {
                  return Expanded(
                    child: MemoList(
                        items: items, updatedItem: _requestDateTodoList),
                  );
                })
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createMemo,
        child: const Icon(Icons.add),
      ),
    );
  }
}
