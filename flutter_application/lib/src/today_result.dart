import 'package:flutter/material.dart';
import '../main.dart';
import 'input_eveluate.dart';
import 'input_before.dart';


class TMP extends StatelessWidget {
  final String result;
  final InputData data;
  const TMP({Key? key, required this.result, required this.data,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '登録画面',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ListView(
                children: const <Widget>[
                ListTile(
                  title: Text(
                    '日付',
                      style: TextStyle(
                        fontSize: 22,
                      ),
                    ),
                    trailing: Text(
                      '2024年10月26日(Sat)',
                      style: TextStyle(
                        fontSize:22,                      
                    ),
                  ),
                ),
                ListTile(
                  title: Text(
                    'エナジードリンク名',
                      style: TextStyle(
                        fontSize: 22,
                      ),
                    ),
                    trailing: Text(
                      'Red Bull',
                      style: TextStyle(
                        fontSize:22,                      
                    ),
                  ),
                ),                
                ListTile(
                  title: Text(
                    '飲んだ本数',
                      style: TextStyle(
                        fontSize: 22,
                      ),
                    ),
                    trailing: Text(
                      '2',
                      style: TextStyle(
                        fontSize:22,                      
                    ),
                  ),
                ),
                ListTile(
                  title: Text(
                    '作業時間',
                      style: TextStyle(
                        fontSize: 22,
                      ),
                    ),
                    trailing: Text(
                      '3',
                      style: TextStyle(
                        fontSize:22,                      
                    ),
                  ),
                ),
                ListTile(
                  title: Text(
                    '前日の睡眠時間',
                      style: TextStyle(
                        fontSize: 22,
                      ),
                    ),
                    trailing: Text(
                      '8.5',
                      style: TextStyle(
                        fontSize:22,                      
                    ),
                  ),
                ),                
                ListTile(
                  title: Text(
                    '起床からの時間',
                      style: TextStyle(
                        fontSize: 22,
                      ),
                    ),
                    trailing: Text(
                      '8',
                      style: TextStyle(
                        fontSize:22,                      
                    ),
                  ),
                ),                
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(84, 40),
                // primary: const Color(0xFF1980E6),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DashboardScreen()),
                );
              },
              child: const Text(
                '送信',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
 }
}
