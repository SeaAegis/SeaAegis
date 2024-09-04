import 'package:flutter/material.dart';

class SearchTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  const SearchTextField({super.key, this.controller, required this.hintText});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        prefixIcon: const Icon(
          Icons.search,
          size: 26,
        ),
        // suffixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide.none,
        ),
        filled: true,
        // fillColor: const Color.fromARGB(117, 192, 223, 251),
        fillColor: Colors.grey.shade100,
        contentPadding: const EdgeInsets.all(0),
      ),
    );
  }
}
