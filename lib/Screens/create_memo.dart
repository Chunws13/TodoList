import 'package:flutter/material.dart';

class CreateMemo extends StatefulWidget {
  final String? content;

  const CreateMemo({
    super.key,
    this.content,
  });

  @override
  State<CreateMemo> createState() => _CreateMemoState();
}

class _CreateMemoState extends State<CreateMemo> {
  final _formKey = GlobalKey<FormState>();
  bool repeat = false;
  bool alarm = false;

  late TextEditingController _contentControler;

  @override
  void initState() {
    super.initState();
    _contentControler = TextEditingController(text: widget.content ?? '');
  }

  void _contentSumbit() {
    if (_formKey.currentState!.validate()) {
      Navigator.pop(context, _contentControler.text);
    }
  }

  void _repeatBtnPress() {
    setState(() {
      repeat = !repeat;
    });
  }

  void _alarmBtnPress() {
    setState(() {
      alarm = !alarm;
    });
  }

  @override
  void dispose() {
    _contentControler.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("새 메모 만들기"),
        ),
        body: Column(
          children: [
            Form(
              key: _formKey,
              child: TextFormField(
                controller: _contentControler,
                decoration: const InputDecoration(labelText: "오늘 할 일"),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "1자 이상 입력하세요";
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(
              height: 36,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _repeatBtnPress,
                  child: const Text("반복"),
                ),
                ElevatedButton(
                  onPressed: _alarmBtnPress,
                  child: const Text("알림"),
                ),
              ],
            ),
            repeat ? const DayWidget() : const Text(""),
            alarm ? const Text("알람 버튼 True") : const Text(""),
          ],
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed: _contentSumbit,
            child: const Text("저장"),
          ),
        ),
      ),
    );
  }
}

class DayWidget extends StatefulWidget {
  const DayWidget({super.key});

  @override
  State<DayWidget> createState() => _DayWidgetState();
}

class _DayWidgetState extends State<DayWidget> {
  Map<String, bool> days = {
    "일": false,
    "월": false,
    "화": false,
    "수": false,
    "목": false,
    "금": false,
    "토": false
  };

  void dayPressed(String day) {
    setState(() {
      days[day] = !days[day]!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      children: days.keys.map((day) {
        return GestureDetector(
          onTap: () => dayPressed(day),
          child: CircleAvatar(
            radius: 20,
            backgroundColor: days[day]! ? Colors.black : Colors.red,
            child: Text(
              day,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        );
      }).toList(),
    );
  }
}
