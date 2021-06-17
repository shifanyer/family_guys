import 'package:family_guys/card_page.dart';
import 'package:family_guys/db_methods/db_main_methods.dart';
import 'package:family_guys/lines/lines.dart';
import 'package:family_guys/person_card/person_card.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'info_objects/person_info.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // print(WidgetsFlutterBinding.ensureInitialized().locked.toString());
  // print(Firebase.apps.length);
  // final fb = FirebaseDatabase.instance;
  // print(fb.databaseURL ?? 'nullBITCHES');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Future<FirebaseApp> fbApp = Firebase.initializeApp();
    // final databaseReference = FirebaseDatabase.instance.reference();
    // databaseReference.push().set({'name': 'data', 'comment': 'A good season'});
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder(
        future: fbApp,
        builder: (BuildContext context, AsyncSnapshot<FirebaseApp> snapshot) {
          if (snapshot.hasError) {
            return Text('ERROR: ${snapshot.error.toString()}');
          } else {
            if (snapshot.hasData) {
              return MyHomePage(title: 'Family guys');
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }
        },
      ),
      // home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map>(
      future: DbMainMethods.downloadPerson('-McQMEZhnEAk5s6nf_d_'),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return CardPage(
          personInfo: DbMainMethods.makePersonInfo(snapshot.data!),
        );
        }
        else{
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      }
    );
  }
}
