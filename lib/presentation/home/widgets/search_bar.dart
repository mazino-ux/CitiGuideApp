import 'package:flutter/material.dart';
// import 'package:citi_guide_app/core/theme/app_theme.dart';

class SearchBar extends StatefulWidget {
  final Function(String) onChanged;

  const SearchBar({super.key, required this.onChanged});

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final TextEditingController _searchController = TextEditingController();
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _isTyping = _searchController.text.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: _isTyping ? '' : 'Search for cities...', // Hides hint when typing
          hintStyle: const TextStyle(color: Colors.grey),
          prefixIcon: Icon(Icons.search, color: Theme.of(context).colorScheme.primary),
          filled: false, // Ensures transparent background
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 1.5),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
        style: const TextStyle(fontSize: 16, color: Colors.black), // Ensures text visibility
        onChanged: widget.onChanged,
      ),
    );
  }
}
