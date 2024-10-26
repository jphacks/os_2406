import 'dart:async';
import 'package:flutter/material.dart';
import 'input_eveluate.dart';
import 'input_before.dart';

class FocusScreen extends StatefulWidget {
  final InputData data;

  FocusScreen({Key? key, required this.data}) : super(key: key);

  @override
  _FocusScreenState createState() => _FocusScreenState();
}

class _FocusScreenState extends State<FocusScreen> {
  late Timer _timer;
  int _elapsedSeconds = 0;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _elapsedSeconds++;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hours = _elapsedSeconds ~/ 3600; // 3600秒ごとに1時間
    final minutes = (_elapsedSeconds % 3600) ~/ 60; // 60秒ごとに1分
    final seconds = _elapsedSeconds % 60; // 残りの秒数

    return Scaffold(
      backgroundColor: const Color(0xFF181112),
      appBar: AppBar(
        backgroundColor: const Color(0xFF181112),
        title: Text(
          widget.data.sleepDuration,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Color(0xFF181112),
                  ),
                  child: const Center(
                    child: Text(
                      '集中モード',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "あなたは集中モードに入っています。",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  "経過時間: ${hours}時間 ${minutes}分 ${seconds}秒",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => InputEvaluate(data: widget.data)),
                    );
                  },
                  child: const Text('次へ'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
