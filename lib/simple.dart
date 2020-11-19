import 'package:flutter/material.dart';

void main() {
  runApp(MultipleCategorySelection());
}

class MultipleCategorySelection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        appBar: AppBar(title: Text("Select categories")),
        body: CategorySelector(
            ["Banana", "Pear", "Apple", "Strawberry", "Pineapple"]),
      ),
    );
  }
}

class CategorySelector extends StatefulWidget {
  final List<String> categories;

  CategorySelector(this.categories);

  @override
  _CategorySelectorState createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {
  final _selectedCategories = List<String>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Flexible(
          child: ListView.builder(
              itemCount: widget.categories.length,
              itemBuilder: (BuildContext context, int index) {
                return CheckboxListTile(
                  value: _selectedCategories.contains(widget.categories[index]),
                  onChanged: (bool selected) {
                    setState(() {
                      if (selected) {
                        _selectedCategories.add(widget.categories[index]);
                      } else {
                        _selectedCategories.remove(widget.categories[index]);
                      }
                    });
                  },
                  title: Text(widget.categories[index]),
                );
              }),
        ),
        RaisedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SelectedCategories(
                        categories: _selectedCategories,
                      )),
            );
          },
          child: Text("Done"),
        )
      ],
    );
  }
}

class SelectedCategories extends StatelessWidget {
  final List<String> categories;

  const SelectedCategories({Key key, this.categories}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Selected categories")),
      body: Container(
        child: ListView.builder(
            itemCount: categories.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(categories[index]),
              );
            }),
      ),
    );
  }
}
