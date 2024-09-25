import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

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

  Map<String, bool> days = {
    "일": false,
    "월": false,
    "화": false,
    "수": false,
    "목": false,
    "금": false,
    "토": false
  };

  late TextEditingController _contentControler;

  @override
  void initState() {
    super.initState();
    _contentControler = TextEditingController(text: widget.content ?? '');
  }

  void dayPressed(String day) {
    setState(() {
      days[day] = !days[day]!;
    });
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

  DateTime _selectedDate = DateTime.now();

  void _showDatePicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 200,
        color: Colors.white,
        child: Column(
          children: [
            SizedBox(
              height: 150,
              child: CupertinoDatePicker(
                dateOrder: DatePickerDateOrder.ymd,
                initialDateTime: _selectedDate,
                maximumDate: DateTime.now(),
                mode: CupertinoDatePickerMode.date,
                onDateTimeChanged: (DateTime newDate) {
                  setState(() {
                    _selectedDate = newDate;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
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
            const SizedBox(height: 32),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _repeatBtnPress,
                  child: const Text("반복"),
                ),
              ],
            ),
            Expanded(
              child: repeat
                  ? DayWidget(
                      days: days,
                      dayPressed: dayPressed,
                      selectedDate: _selectedDate,
                      textBtnPressed: _showDatePicker,
                    )
                  : const Text(""),
            ),
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

class DayWidget extends StatelessWidget {
  final Map<String, bool> days;
  final Function(String) dayPressed;
  final DateTime selectedDate;
  final Function(BuildContext) textBtnPressed;

  const DayWidget({
    super.key,
    required this.days,
    required this.dayPressed,
    required this.selectedDate,
    required this.textBtnPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      ...days.keys.map((day) {
        return ListTile(
          leading: Icon(Icons.check_circle_outline,
              color: days[day]! ? Colors.red : Colors.grey),
          title: Text("$day요일"),
          onTap: () => dayPressed(day),
        );
      }),
      TextButton(
        child: Text(
          "${selectedDate.toString().split(" ")[0]} 까지",
          style: const TextStyle(fontSize: 16),
        ),
        onPressed: () => textBtnPressed(context),
      ),
    ]);
  }
}
