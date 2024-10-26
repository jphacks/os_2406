import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'today_result.dart';
import 'input_before.dart';

class InputEvaluate extends StatefulWidget {
  final InputData data;

  const InputEvaluate({Key? key, required this.data}) : super(key: key);

  @override
  _InputEvaluateState createState() => _InputEvaluateState();
}

class _InputEvaluateState extends State<InputEvaluate> {
  int? _focusedRating; // ラジオボタンの値
  int? _sleepyRating;  // ラジオボタンの値

  // FastAPIからデータを取得するメソッド
  Future<void> sendData() async {
    late Uri url;
    if (Platform.isAndroid) {
      url = Uri.parse('http://10.0.2.2:8000/submit');
    } else if (Platform.isIOS) {
      url = Uri.parse('http://127.0.0.1:8000/submit');
    } else {
      throw Exception('Unsupported platform');
    }
    // final url = Uri.parse('http://10.0.2.2:8000/submit'); // 適切なAPIエンドポイントに変更
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'energyDrink': widget.data.energyDrink,
        'wakeUpTime': widget.data.wakeUpTime,
        'currentTime': widget.data.currentTime,
        'sleepDuration': widget.data.sleepDuration,
        'focusedRating': _focusedRating,
        'sleepyRating': _sleepyRating,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to submit data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {},
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          widget.data.energyDrink,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  'How focused were you after work?',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              RatingRow(
                groupValue: _focusedRating, // 選択されている値を渡す
                onChanged: (value) {
                  setState(() {
                    _focusedRating = value; // 選択された値を更新
                  });
                },
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  'How sleepy are you now?',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              RatingRow(
                groupValue: _sleepyRating, // 選択されている値を渡す
                onChanged: (value) {
                  setState(() {
                    _sleepyRating = value; // 選択された値を更新
                  });
                },
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(84, 40),
                  ),
                  onPressed: () async {
                    try {
                      await sendData(); // データを送信
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TMP(result: 'Success', data: widget.data),
                        ),
                      );
                    } catch (e) {
                      print("Error: $e");
                    }
                  },
                  child: const Text(
                    'Submit',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class RatingRow extends StatelessWidget {
  final ValueChanged<int?> onChanged;
  final int? groupValue; // 選択されている値を保持

  const RatingRow({Key? key, required this.onChanged, this.groupValue}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(
          5,
          (index) => Radio<int>(
            value: index + 1,
            groupValue: groupValue, // 選択されている値をここで使用
            onChanged: (value) {
              onChanged(value); // 親ウィジェットに値を渡す
            },
          ),
        ),
      ),
    );
  }
}
