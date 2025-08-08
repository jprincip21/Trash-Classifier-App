import 'package:flutter/material.dart';

class CustomSearchDelegate extends SearchDelegate {
  //TODO: Following the same logic as the saved Data page we need to pull all of the files and have the file names be the search terms
  //TODO: We then also need to update the listView Builers to follow the same logic as the saved Data page
  //TODO: We can most likely pull logic from the saved data page and create seperate global functions instead of repeating the creation of the same function.
  List<String> searchTerms = ["a", "b", "c"];

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<String> matchQuery = [];
    for (var search in searchTerms) {
      if (search.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(search);
      }
    }
    return (ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(title: Text(result));
      },
    ));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = [];
    for (var search in searchTerms) {
      if (search.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(search);
      }
    }
    return (ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(title: Text(result));
      },
    ));
  }
}
