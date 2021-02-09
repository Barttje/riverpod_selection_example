import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Class1>(
          create: (_) => Class1(),
        ),
        // ProxyProvider<Class1, Class2>(
        //   update: (context, class1, class2) => Class2(class1),
        //)
        ChangeNotifierProxyProvider<Class1, Class2>(
          create: (BuildContext context) => Class2(null),
          update: (context, class1, class2) => Class2(class1),
        ),
      ],
      child: MaterialApp(initialRoute: HomePage.id, routes: {
        HomePage.id: (context) => HomePage(),
      }),
    );
  }
}

class HomePage extends StatelessWidget {
  static const String id = 'home_page';
  @override
  Widget build(BuildContext context) {
    return Consumer2<Class1, Class2>(
      builder: (context, class1, class2, child) {
        return Scaffold(
          backgroundColor: Colors.blueAccent,
          body: Container(
            alignment: Alignment.center,
            color: Colors.blueAccent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(class1.number.toString()),
                SizedBox(height: 50),
                MaterialButton(
                  color: Colors.deepOrangeAccent,
                  height: 100,
                  minWidth: 100,
                  child: Text(
                    '5',
                    style: TextStyle(fontSize: 40),
                  ),
                  onPressed: () {
                    class1.addNumber(5);
                    class2.addNumberFromClass1();
                    print("${class1.number} on pressed class1 number");
                    print(
                        "${class2.getNumberFromClass1} on pressed class2 number");
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class Class1 extends ChangeNotifier {
  int number = 1; //This stays always the same.
  void addNumber(value) {
    number = number +
        value; //after adding value to number, the new calculated number should be stored in number.
    notifyListeners();
  }

  get getNumber {
    return number;
  }
}

class Class2 extends ChangeNotifier {
  int numberFromClass1;

  Class2(Class1 class1) {
    if (class1 != null) {
      numberFromClass1 = class1.getNumber;
      print("$numberFromClass1 updated");
    }
  }

  void addNumberFromClass1() {
    print("$numberFromClass1 addNumberFromClass1 called");
    notifyListeners();
  }

  get getNumberFromClass1 {
    return numberFromClass1;
  }
}
