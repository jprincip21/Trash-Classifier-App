import 'package:flutter/material.dart';
import 'package:trash_classifier_app/data/classes/custom_search_delegate.dart';

class SearchBarWidget extends StatefulWidget {
  const SearchBarWidget({super.key});

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        showSearch(context: context, delegate: CustomSearchDelegate());
      },
      icon: Icon(Icons.search),
    );
  }
}
