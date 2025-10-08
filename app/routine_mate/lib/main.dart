import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(
    const ProviderScope(
      child: RoutineMateApp(),
    ),
  );
}

class RoutineMateApp extends StatelessWidget {
  const RoutineMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RoutineMate',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1), // Indigo
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        fontFamily: 'Pretendard',
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        fontFamily: 'Pretendard',
      ),
      themeMode: ThemeMode.system,
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'RoutineMate',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 80,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 24),
            Text(
              '오늘의 루틴을 시작해보세요!',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            Text(
              '매일 작은 실천으로 큰 변화를 만들어요',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                  ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: 루틴 추가 기능
        },
        icon: const Icon(Icons.add),
        label: const Text('루틴 추가'),
      ),
    );
  }
}