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
        body: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _contentControler,
                decoration: const InputDecoration(labelText: "오늘 할 일"),
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
