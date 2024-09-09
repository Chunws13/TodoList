import 'package:flutter/material.dart';

class CreateMemo extends StatefulWidget {
  const CreateMemo({super.key});

  @override
  State<CreateMemo> createState() => _CreateMemoState();
}

class _CreateMemoState extends State<CreateMemo> {
  final _formKey = GlobalKey<FormState>();

  String? _content;

  final TextEditingController _contentControler = TextEditingController();

  void _contentSumbit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Navigator.pop(context, _content);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("새 메모 만들기"),
        ),
        body: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _contentControler,
                decoration: const InputDecoration(labelText: "오늘 할 일"),
                onSaved: (String? value) => _content = value,
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "1자 이상 입력하세요";
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: _contentSumbit,
                child: const Text("저장"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
