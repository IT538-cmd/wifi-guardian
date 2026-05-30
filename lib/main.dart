import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WiFi Security Guardian',
      theme: ThemeData.dark(),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SecurityReport {
  final int score;
  final String level;
  final String emoji;
  final List<String> strengths;
  final List<String> weaknesses;
  final List<String> recommendations;
  final String summary;
  
  SecurityReport({
    required this.score,
    required this.level,
    required this.emoji,
    required this.strengths,
    required this.weaknesses,
    required this.recommendations,
    required this.summary,
  });
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String wifiName = "Не обнаружена";
  String wifiBSSID = "Неизвестно";
  String ipAddress = "Неизвестно";
  bool isScanning = false;
  SecurityReport? securityReport;
  int scanCount = 0;

  SecurityReport analyzeNetworkSecurity() {
    Random random = Random(scanCount);
    
    // Генерируем реалистичный анализ
    int score = 65 + random.nextInt(35); // от 65 до 100
    
    String level;
    String emoji;
    if (score >= 85) {
      level = "Отличный";
      emoji = "🛡️";
    } else if (score >= 70) {
      level = "Хороший";
      emoji = "✅";
    } else {
      level = "Требует внимания";
      emoji = "⚠️";
    }
    
    List<String> strengths = [];
    List<String> weaknesses = [];
    List<String> recommendations = [];
    
    // Сильные стороны (случайные)
    List<String> possibleStrengths = [
      "Стандартный протокол шифрования активен",
      "Обнаружена защита от ARP-spoofing",
      "Скрытое SSID не обнаружено",
      "Актуальная версия прошивки",
      "WPA2 шифрование настроено",
      "Гостевая сеть изолирована",
    ];
    
    // Слабые стороны (случайные)
    List<String> possibleWeaknesses = [
      "Не изменён пароль администратора по умолчанию",
      "WPS функция активна",
      "Устаревший протокол WPA/TKIP обнаружен",
      "Отключено журналирование событий",
      "Удалённый доступ разрешён",
      "Не настроен фаервол",
    ];
    
    // Рекомендации
    List<String> possibleRecommendations = [
      "Смените пароль администратора роутера",
      "Отключите WPS в настройках роутера",
      "Обновите прошивку роутера",
      "Включите WPA3 если поддерживается",
      "Смените SSID на уникальное имя",
      "Отключите удалённый доступ",
      "Включите журналирование атак",
      "Создайте гостевую сеть для посетителей",
    ];
    
    // Выбираем случайные элементы
    for (int i = 0; i < 3; i++) {
      if (random.nextBool() && strengths.length < 3) {
        strengths.add(possibleStrengths[random.nextInt(possibleStrengths.length)]);
      }
      if (random.nextBool() && weaknesses.length < 3) {
        weaknesses.add(possibleWeaknesses[random.nextInt(possibleWeaknesses.length)]);
      }
      if (random.nextBool() && recommendations.length < 3) {
        recommendations.add(possibleRecommendations[random.nextInt(possibleRecommendations.length)]);
      }
    }
    
    // Гарантируем минимум по 1 элементу
    if (strengths.isEmpty) strengths.add(possibleStrengths[0]);
    if (weaknesses.isEmpty && score < 80) weaknesses.add(possibleWeaknesses[0]);
    if (recommendations.isEmpty) recommendations.add(possibleRecommendations[0]);
    
    String summary;
    if (score >= 85) {
      summary = "Ваша сеть хорошо защищена. Продолжайте следовать рекомендациям по безопасности.";
    } else if (score >= 70) {
      summary = "Базовый уровень защиты присутствует, но есть возможности для улучшения.";
    } else {
      summary = "Обнаружены критические уязвимости. Немедленно примените рекомендации!";
    }
    
    return SecurityReport(
      score: score,
      level: level,
      emoji: emoji,
      strengths: strengths,
      weaknesses: weaknesses,
      recommendations: recommendations,
      summary: summary,
    );
  }

  Future<void> performSecurityScan() async {
    setState(() {
      isScanning = true;
    });
    
    // Имитация сканирования
    await Future.delayed(const Duration(seconds: 2));
    
    // Генерируем демо-данные
    setState(() {
      scanCount++;
      wifiName = "Домашняя WiFi Сеть";
      wifiBSSID = "C8:3A:35:${(scanCount % 100).toString().padLeft(2, '0')}:AB:CD";
      ipAddress = "192.168.1.${100 + scanCount % 50}";
      
      securityReport = analyzeNetworkSecurity();
      isScanning = false;
    });
    
    Fluttertoast.showToast(
      msg: "✅ Сканирование завершено! Найдено ${securityReport?.weaknesses.length ?? 0} проблем",
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 3,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WiFi Security Guardian'),
        centerTitle: true,
        backgroundColor: Colors.blue.shade900,
        elevation: 0,
        actions: [
          Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.blue.shade700,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(Icons.verified, size: 16),
                const SizedBox(width: 4),
                Text("v1.0", style: const TextStyle(fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade900.withOpacity(0.3),
              Colors.black,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Приветствие
                const Text(
                  "Безопасность вашей WiFi сети",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Профессиональный анализ уязвимостей",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade400,
                  ),
                ),
                const SizedBox(height: 20),
                
                // Карточка сети
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blue.shade900.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.blue.shade700, width: 1),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade800,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: const Icon(Icons.wifi, color: Colors.white, size: 32),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Текущая сеть",
                                  style: TextStyle(color: Colors.grey, fontSize: 12),
                                ),
                                Text(
                                  wifiName,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.green),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.circle, color: Colors.green, size: 10),
                                const SizedBox(width: 4),
                                Text("Активна", style: TextStyle(color: Colors.green, fontSize: 12)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Divider(color: Colors.grey.shade800),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _networkDetail(Icons.settings_input_antenna, "BSSID", wifiBSSID),
                          _networkDetail(Icons.computer, "IP", ipAddress),
                        ],
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Кнопка сканирования
                ElevatedButton(
                  onPressed: isScanning ? null : performSecurityScan,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 5,
                  ),
                  child: isScanning
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          ),
                          const SizedBox(width: 12),
                          Text("Анализ безопасности...", style: TextStyle(fontSize: 16)),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.shield, size: 24),
                          const SizedBox(width: 12),
                          Text("Начать сканирование", style: TextStyle(fontSize: 16)),
                        ],
                      ),
                ),
                
                // Результаты анализа
                if (securityReport != null) ...[
                  const SizedBox(height: 20),
                  
                  // Score card
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          _getScoreColor(securityReport!.score),
                          _getScoreColor(securityReport!.score).withOpacity(0.7),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Text(
                          securityReport!.emoji,
                          style: const TextStyle(fontSize: 40),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          securityReport!.level,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            "${securityReport!.score}/100",
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          securityReport!.summary,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 15),
                  
                  // Strengths
                  if (securityReport!.strengths.isNotEmpty)
                    _buildSection(
                      title: "✅ Сильные стороны",
                      icon: Icons.thumb_up,
                      items: securityReport!.strengths,
                      color: Colors.green,
                    ),
                  
                  // Weaknesses
                  if (securityReport!.weaknesses.isNotEmpty)
                    _buildSection(
                      title: "⚠️ Найденные проблемы",
                      icon: Icons.warning,
                      items: securityReport!.weaknesses,
                      color: Colors.orange,
                    ),
                  
                  // Recommendations
                  _buildSection(
                    title: "💡 Рекомендации",
                    icon: Icons.lightbulb,
                    items: securityReport!.recommendations,
                    color: Colors.blue,
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Экспорт
                  OutlinedButton.icon(
                    onPressed: () {
                      Fluttertoast.showToast(msg: "Отчёт сохранён (демо-режим)");
                    },
                    icon: const Icon(Icons.download),
                    label: const Text("Сохранить отчёт"),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: BorderSide(color: Colors.blue.shade700),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _networkDetail(IconData icon, String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: Colors.grey),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(color: Colors.grey, fontSize: 10)),
          Text(
            value,
            style: const TextStyle(color: Colors.white, fontSize: 12, fontFamily: 'monospace'),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
  
  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<String> items,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...items.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("• ", style: TextStyle(color: color, fontSize: 14)),
                Expanded(child: Text(item, style: const TextStyle(fontSize: 13))),
              ],
            ),
          )),
        ],
      ),
    );
  }
  
  Color _getScoreColor(int score) {
    if (score >= 85) return Colors.green.shade700;
    if (score >= 70) return Colors.orange.shade700;
    return Colors.red.shade700;
  }
}
