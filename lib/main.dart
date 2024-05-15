import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'api.dart';
import 'data.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(DataAdapter());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Namer App',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSwatch(accentColor: Colors.blue),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hive with Flutter'),
      ),
      body: FutureBuilder(
        future: Hive.openBox('myData'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(
                child: Text('Error'),
              );
            } else {
              final myDataBox = Hive.box('myData');
              return ListView.builder(
                itemCount: myDataBox.length,
                itemBuilder: (context, index) {
                  final myData = myDataBox.getAt(index) as Data;
                  return Card(
                    child: ListTile(
                      title: Text(myData.name),
                      subtitle: Text('ID: ${myData.id}'),
                    ),
                  );
                },
              );
            }
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await ApiService.fetchDataAndStoreInHive();
        },
        child: Icon(Icons.refresh),
      ),
    );
  }
}
