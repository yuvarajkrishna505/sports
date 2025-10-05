import 'package:flutter/material.dart';
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SkillsScreen(),
    );
  }
}

class SkillsScreen extends StatefulWidget {
  const SkillsScreen({super.key});

  @override
  State<SkillsScreen> createState() => _SkillsScreenState();
}

class _SkillsScreenState extends State<SkillsScreen> {
  // JSON Data
  final String jsonData = '''
  [
    {"name": "Dribbling", "level": "Basic", "image": "https://via.placeholder.com/120x80?text=Dribbling"},
    {"name": "Passing", "level": "Basic", "image": "https://via.placeholder.com/120x80?text=Passing"},
    {"name": "Vault", "level": "Intermediate", "image": "https://via.placeholder.com/120x80?text=Vault"},
    {"name": "Agility", "level": "Advanced", "image": "https://via.placeholder.com/120x80?text=Agility"},
    {"name": "Defense", "level": "Advanced", "image": "https://via.placeholder.com/120x80?text=Defense"}
  ]
  ''';

  int currentIndex = 0;
  late List<dynamic> basic;
  late List<dynamic> intermediate;
  late List<dynamic> advanced;
  late List<Map<String, dynamic>> sections;

  @override
  void initState() {
    super.initState();
    final skills = json.decode(jsonData);
    basic = skills.where((s) => s['level'] == 'Basic').toList();
    intermediate = skills.where((s) => s['level'] == 'Intermediate').toList();
    advanced = skills.where((s) => s['level'] == 'Advanced').toList();

    sections = [
      {"title": "Basic", "skills": basic},
      {"title": "Intermediate", "skills": intermediate},
      {"title": "Advanced", "skills": advanced},
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sports Skills'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Category selector with animation
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(sections.length, (index) {
                bool isActive = index == currentIndex;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      currentIndex = index;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                    decoration: BoxDecoration(
                      color: isActive ? Colors.blueAccent : Colors.grey[200],
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: isActive
                          ? [
                        BoxShadow(
                          color: Colors.blueAccent.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        )
                      ]
                          : [],
                    ),
                    child: Text(
                      sections[index]['title'],
                      style: TextStyle(
                        color: isActive ? Colors.white : Colors.black87,
                        fontWeight:
                        isActive ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),

          const SizedBox(height: 10),

          // Animated skill list transition
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              transitionBuilder: (child, animation) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.3, 0),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                      parent: animation, curve: Curves.easeInOut)),
                  child: FadeTransition(opacity: animation, child: child),
                );
              },
              child: skillSection(
                sections[currentIndex]['title'],
                sections[currentIndex]['skills'],
                key: ValueKey(currentIndex),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget skillSection(String title, List<dynamic> skills, {Key? key}) {
    return Container(
      key: key,
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: skills.length,
        itemBuilder: (context, index) {
          final skill = skills[index];
          return Container(
            width: 150,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: Colors.blueAccent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.blueAccent, width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(15)),
                  child: Image.network(
                    skill['image'],
                    height: 100,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  skill['name'],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
