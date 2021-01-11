import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
        appBar: AppBar(title: Text("Interactive categories")),
        body: ChangeNotifierProvider(
            create: (context) => CategoryList(
                ["Banana", "Pear", "Apple", "Strawberry", "Pineapple"]),
            child: Column(
              children: [
                CategoryFilter(),
                Container(
                  color: Colors.green,
                  height: 2,
                ),
                SelectedCategories()
              ],
            )),
      ),
    );
  }
}

class CategoryFilter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryList>(builder: (context, categoryList, child) {
      return Flexible(
        child: ListView.builder(
            itemCount: categoryList.categories.length,
            itemBuilder: (BuildContext context, int index) {
              return CheckboxListTile(
                value: categoryList.selectedCategories
                    .contains(categoryList.categories[index]),
                onChanged: (bool selected) {
                  var categoriesModel = context.read<CategoryList>();
                  categoriesModel.toggle(categoryList.categories[index]);
                },
                title: Text(categoryList.categories[index]),
              );
            }),
      );
    });
  }
}

class SelectedCategories extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryList>(
      builder: (context, categoryList, child) {
        return Flexible(
          child: ListView.builder(
              itemCount: categoryList.selectedCategories.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(categoryList.selectedCategories[index]),
                );
              }),
        );
      },
    );
  }
}

class CategoryList extends ChangeNotifier {
  CategoryList(List<String> categories) {
    categories.forEach((value) {
      _categories.putIfAbsent(value, () => false);
    });
  }

  final Map<String, bool> _categories = Map();

  List<String> get categories => _categories.keys.toList();

  List<String> get selectedCategories =>
      _categories.entries.where((e) => e.value).map((e) => e.key).toList();

  void toggle(String item) {
    _categories[item] = !_categories[item];
    notifyListeners();
  }
}
