import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class FAQPage extends StatefulWidget {
  const FAQPage({super.key});

  @override
  State<FAQPage> createState() => _FAQPageState();
}

class _FAQPageState extends State<FAQPage> {
  final List<FAQItem> faqs = [
    FAQItem(
      icon: LucideIcons.map,
      question: "What is the City Guide app?",
      answer: "City Guide helps you explore local attractions, restaurants, events, and hidden gems with our curated purple guide collection.",
    ),
    FAQItem(
      icon: LucideIcons.search,
      question: "How can I search for a place?",
      answer: "Use the search bar with purple accent or explore our categorized collections. Try voice search for hands-free discovery!",
    ),
    FAQItem(
      icon: LucideIcons.user,
      question: "Do I need an account?",
      answer: "Browse freely, but signing up unlocks personalized purple-themed recommendations and favorites saving.",
    ),
    FAQItem(
      icon: LucideIcons.messageSquare,
      question: "How do I leave a review?",
      answer: "Tap the purple review button on any location page. Premium users get featured reviews!",
    ),
    FAQItem(
      icon: LucideIcons.mapPin,
      question: "Is there a map feature?",
      answer: "Yes! Our interactive purple-themed map shows attractions, your location, and curated routes.",
    ),
    FAQItem(
      icon: LucideIcons.wifiOff,
      question: "Can I use it offline?",
      answer: "Download purple guide collections for offline access to maps and essential info.",
    ),
  ];

  List<FAQItem> filteredFAQs = [];

  @override
  void initState() {
    super.initState();
    filteredFAQs = faqs;  // Initialize with all FAQs
  }

  void _filterFAQs(String query) {
    final filtered = faqs.where((faq) {
      return faq.question.toLowerCase().contains(query.toLowerCase());
    }).toList();
    setState(() {
      filteredFAQs = filtered;  // Update the filtered FAQs list
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("FAQs"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search FAQs...",
                prefixIcon: const Icon(LucideIcons.search, color: Colors.deepPurple),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
              onChanged: (value) {
                _filterFAQs(value);  // Call filter function on change
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: filteredFAQs.length,  // Display filtered FAQs
              itemBuilder: (context, index) {
                final faq = filteredFAQs[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        dividerColor: Colors.transparent,
                      ),
                      child: ExpansionTile(
                        leading: Icon(
                          faq.icon,
                          color: Colors.deepPurple,
                        ),
                        title: Text(
                          faq.question,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.deepPurple,
                          ),
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                            child: Text(
                              faq.answer,
                              style: TextStyle(
                                color: Colors.grey[700],
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class FAQItem {
  final IconData icon;
  final String question;
  final String answer;

  FAQItem({
    required this.icon,
    required this.question,
    required this.answer,
  });
}
