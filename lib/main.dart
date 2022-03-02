import 'package:flutter/material.dart';
import 'package:gsheets_app/DataFields.dart';
import 'package:gsheets_app/Sheets.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SheetsApi.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Student> student = [];
  @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   getStudent();
  // }
  //
  // Future getStudent() async {
  //   final student = await SheetsApi.getAll();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Google Sheets',
          style: TextStyle(fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: SizedBox(
          width: 200,
          height: 60,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0)),
              primary: Colors.blueAccent,
              onPrimary: Colors.white,
            ),
            onPressed: () async {
              final spreadsheet =
                  await SheetsApi.gsheets.spreadsheet(SheetsApi.spreadsheetId);
              SheetsApi.resultSheet =
                  await SheetsApi.getWorksheet(spreadsheet, title: 'Result');
              final firstRow = DataFields.getFields();
              SheetsApi.resultSheet!.values.insertRow(1, firstRow);
              final student = await SheetsApi.getAll();
              final jsonStudent =
                  student.map((student) => student.toJson()).toList();
              await SheetsApi.insert(jsonStudent);
              final col3 = await SheetsApi.dataSheet!.values.map.column(3);
              await SheetsApi.resultSheet!.values.map.appendColumn(col3);
              List<String> Col4 = [
                'Result',
                int.parse(col3.values.elementAt(1)) >= 40 ? 'pass' : 'fail',
                int.parse(col3.values.elementAt(2)) >= 40 ? 'pass' : 'fail',
                int.parse(col3.values.elementAt(3)) >= 40 ? 'pass' : 'fail',
                int.parse(col3.values.elementAt(4)) >= 40 ? 'pass' : 'fail',
                int.parse(col3.values.elementAt(5)) >= 40 ? 'pass' : 'fail',
                int.parse(col3.values.elementAt(6)) >= 40 ? 'pass' : 'fail',
                int.parse(col3.values.elementAt(7)) >= 40 ? 'pass' : 'fail',
              ].toList(growable: true);
              SheetsApi.resultSheet!.values.appendColumn(Col4);
            },
            child: const Text(
              'TRIGGER',
              style: TextStyle(fontSize: 25),
            ),
          ),
        ),
      ),
    );
  }
}
