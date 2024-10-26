import 'package:flutter/material.dart';
import 'ongoing_mode.dart';

// InputData クラスを定義
class InputData {
  final String energyDrink;
  final String wakeUpTime;
  final String currentTime;
  final String sleepDuration;

  InputData({
    required this.energyDrink,
    required this.wakeUpTime,
    required this.currentTime,
    required this.sleepDuration,
  });
}

class PreWorkScreen extends StatefulWidget {
  PreWorkScreen({super.key});

  @override
  _PreWorkScreenState createState() => _PreWorkScreenState();
}

class _PreWorkScreenState extends State<PreWorkScreen> {
  String energyDrink = '';
  String wakeUpTime = '';
  String currentTime = '';
  String lastNightSleepDuration = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF181112),
      appBar: AppBar(
        backgroundColor: const Color(0xFF181112),
        title: const Text(
          '入力画面',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            // Energy Drink TextField
            const Text(
              'エナジードリンク名',
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            TextField(
              onChanged: (value) {
                setState(() {
                  energyDrink = value;
                });
              },
              decoration: InputDecoration(
                hintText: '選択',
                hintStyle: const TextStyle(color: Color(0xFFBA9CA2)),
                filled: true,
                fillColor: const Color(0xFF39282B),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 8),
            // Wake up time TextField
            const Text(
              '起床時間',
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            TextField(
              onChanged: (value) {
                setState(() {
                  wakeUpTime = value;
                });
              },
              decoration: InputDecoration(
                hintText: '入力',
                hintStyle: const TextStyle(color: Color(0xFFBA9CA2)),
                filled: true,
                fillColor: const Color(0xFF39282B),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 8),
            // Current time TextField
            const Text(
              '現在時刻',
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            TextField(
              onChanged: (value) {
                setState(() {
                  currentTime = value;
                });
              },
              decoration: InputDecoration(
                hintText: '入力',
                hintStyle: const TextStyle(color: Color(0xFFBA9CA2)),
                filled: true,
                fillColor: const Color(0xFF39282B),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 8),
            // Last night sleep duration TextField
            const Text(
              '前日の睡眠時間',
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            TextField(
              onChanged: (value) {
                setState(() {
                  lastNightSleepDuration = value;
                });
              },
              decoration: InputDecoration(
                hintText: '入力',
                hintStyle: const TextStyle(color: Color(0xFFBA9CA2)),
                filled: true,
                fillColor: const Color(0xFF39282B),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE30D38),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      // InputData インスタンスを作成し、次の画面に渡す
                      InputData inputData = InputData(
                        energyDrink: energyDrink,
                        wakeUpTime: wakeUpTime,
                        currentTime: currentTime,
                        sleepDuration: lastNightSleepDuration,
                      );

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => FocusScreen(data: inputData)),
                      );
                    },
                    child: const Text('スタート'),
                  ),
                ),
                const SizedBox(width: 18),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
