import 'package:flutter/material.dart';
import '../main.dart';


class TMP extends StatelessWidget {
  const TMP({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF181112),
      appBar: AppBar(
        backgroundColor: const Color(0xFF181112),
        title: const Text(
          'TodayResult',
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
                      'TodayResult',
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
                  "Today Result",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  "Today Result",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  height: 150,
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                      image: NetworkImage(
                          "https://cdn.usegalileo.ai/sdxl10/06319e20-6369-40b9-85b7-7116bc3651df.png"),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                ElevatedButton(
                onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const DashboardScreen()),
                      );
                    },
                child: const Text('finish'),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
