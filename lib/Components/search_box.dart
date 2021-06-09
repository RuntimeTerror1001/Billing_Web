import 'package:flutter/material.dart';

class SearchBox extends StatelessWidget {
  const SearchBox({
    Key? key,
    required this.size,
    required TextEditingController searchController,
  })  : _searchController = searchController,
        super(key: key);

  final Size size;
  final TextEditingController _searchController;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width * 0.75,
      height: size.height * 0.10,
      child: Center(
        child: SizedBox(
          width: 500,
          child: TextFormField(
            controller: _searchController,
            decoration: InputDecoration(
              labelText: 'Search',
              prefixIcon: Icon(Icons.search),
            ),
          ),
        ),
      ),
    );
  }
}
