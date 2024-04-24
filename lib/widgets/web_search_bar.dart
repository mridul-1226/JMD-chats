import 'package:chatting_app/data/colors.dart';
import 'package:flutter/material.dart';

class WebSearchBar extends StatelessWidget {
  const WebSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: MediaQuery.of(context).size.width * 0.25,
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: dividerColor)
        ),
      ),
      child: TextField(
        decoration: InputDecoration(
          fillColor: searchBarColor,
          filled: true,
          prefixIcon: const Icon(Icons.search),
          hintText: 'Search or start a new chat',
          hintStyle: const TextStyle(fontSize: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(
              width: 0,
              style: BorderStyle.none
            )
          )
        ),
      ),
    );
  }
}