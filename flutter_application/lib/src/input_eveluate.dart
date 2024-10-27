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

class RatingRow extends StatelessWidget {
  final ValueChanged<int?> onChanged;
  final int? groupValue;

  const RatingRow({Key? key, required this.onChanged, this.groupValue}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> labels = ['1', '2', '3', '4', '5'];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(
          5,
              (index) => Column(
            children: [
              Radio<int>(
                value: index + 1,
                groupValue: groupValue,
                onChanged: (value) {
                  onChanged(value);
                },
                activeColor: Colors.blueAccent,
              ),
              Text(
                labels[index],
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
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
      throw Exception('データの送信に失敗しました');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: Text(widget.data.energyDrink, style: const TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1F1F1F),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  '仕事後、どれくらい集中できましたか？\n(1: 全く集中できない、5: 非常に集中できた)',
                  style: TextStyle(
                    fontSize: 18, // テキストサイズを小さく
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              RatingRow(
                groupValue: _focusedRating,
                onChanged: (value) {
                  setState(() {
                    _focusedRating = value;
                  });
                },
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  '今、どれくらい眠たいですか？\n(1: 全く眠くない、5: 非常に眠い)',
                  style: TextStyle(
                    fontSize: 18, // テキストサイズを小さく
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              RatingRow(
                groupValue: _sleepyRating,
                onChanged: (value) {
                  setState(() {
                    _sleepyRating = value;
                  });
                },
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all(const Size(84, 40)),
                backgroundColor: MaterialStateProperty.all(Colors.blue), // 青色のボタン
              ),
              onPressed: () async {
                try {
                  await sendData();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TMP(result: '成功', data: widget.data),
                    ),
                  );
                } catch (e) {
                  print("Error: $e");
                }
              },
              child: const Text(
                '送信',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
