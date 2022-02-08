import 'package:flutter/material.dart';
import 'package:sqlite_db_flutter/model/Grocery.dart';
import 'package:sqlite_db_flutter/sqlDb/DatabaseHelper.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(SqliteApp());
}

class SqliteApp extends StatefulWidget {
  const SqliteApp({Key? key}) : super(key: key);

  @override
  _SqliteAppState createState() => _SqliteAppState();
}

class _SqliteAppState extends State<SqliteApp> {
  int? selectedItem;
  final textControler = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: TextField(
            controller: textControler
          ),
        ),
        body: Center(
          child: FutureBuilder<List<Grocery>>(
            future: DatabaseHelper.instance.getGroceries(),
            builder: (BuildContext context, AsyncSnapshot<List<Grocery>> snapshot) {
              if(!snapshot.hasData) {
                return Center(child: Text('Loading...'));
              }
              return snapshot.data!.isEmpty
                ? Center( child: Text('No groceries in list...'),)
                : ListView(
                children: snapshot.data!.map((grocery) {
                  return Center(
                    child: ListTile(
                      title: Text(grocery.name),
                      onTap: () {
                        setState(() {
                          textControler.text = grocery.name;
                          selectedItem = grocery.id;
                        });
                      },
                      onLongPress: () {
                        setState(() {
                          DatabaseHelper.instance.remove(grocery.id!);
                        });
                      },
                    ),
                  );
                }).toList(),
              );
            }
          ),
        ),

        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            if(textControler.text.isNotEmpty){

              selectedItem != null ? await DatabaseHelper.instance.update(
                Grocery(id: selectedItem, name: textControler.text)
              )
              : await DatabaseHelper.instance.add(
                  Grocery(name: textControler.text, id: null));
            } else {
              print('=====================> Enter data...');
            }
            //print(textControler.text);
            setState(() {
              textControler.clear();
            });
          },
          child: Icon(Icons.save),
        ),
      ),
    );
  }
}


