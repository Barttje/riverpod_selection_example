import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  runApp(ProviderScope(child: MultipleCategorySelection()));
}

final categoryListProvider =
    StateNotifierProvider((_) => createCategoryList(["a", "b"]));

final selectedCategories = Provider((ref) => ref
    .watch(categoryListProvider)
    .entries
    .where((MapEntry<String, bool> category) => category.value)
    .map((e) => e.key)
    .toList());

final allCategories =
    Provider((ref) => ref.watch(categoryListProvider).keys.toList());

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
        body: Column(
          children: [
            CategoryFilter(),
            Container(
              color: Colors.green,
              height: 2,
            ),
            SelectedCategories()
          ],
        ),
      ),
    );
  }
}

class CategoryFilter extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategoryList = ref.watch(selectedCategories);
    final categoryList = ref.watch(allCategories);
    final provider = ref.watch(categoryListProvider.notifier);

    return Flexible(
      child: ListView.builder(
          itemCount: categoryList.length,
          itemBuilder: (BuildContext context, int index) {
            return CheckboxListTile(
              value: selectedCategoryList.contains(categoryList[index]),
              onChanged: (bool? selected) {
                provider.toggle(categoryList[index]);
              },
              title: Text(categoryList[index]),
            );
          }),
    );
  }
}

class SelectedCategories extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoryList = ref.watch(selectedCategories);
    return Flexible(
      child: ListView.builder(
          itemCount: categoryList.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(categoryList[index]),
            );
          }),
    );
  }
}

CategoryList createCategoryList(List<String> values) {
  final Map<String, bool> categories = Map();
  values.forEach((value) {
    categories.putIfAbsent(value, () => false);
  });
  return CategoryList(categories);
}

class CategoryList extends StateNotifier<Map<String, bool>> {
  CategoryList(Map<String, bool> state) : super(state);

  void toggle(String item) {
    final currentValue = state[item];
    if (currentValue != null) {
      state[item] = !currentValue;
      state = state;
    }
  }
}
