import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'config.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jazzve Online',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Jazzve Online'),
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

  String? _object;
  String? _store;
  String? _monthName;
  List<String> _months = <String>['Հունվար','Փետրվար','Մարտ','Ապրիլ','Մայիս','Հունիս','Հուլիս','Օգոստոս','Սեպտեմբեր','Հոկտեմբեր','Նոյեմբեր','Դեկտեմբեր'];
  List<String> _cafeNames = <String>['Օպերա', 'Թումանյան','Կոմիտաս', 'Աբովյան', 'Արմենիա', 'Երևան Մոլլ'];
  List<String> _storeNames = <String>['Բար', 'Խոհանոց', 'Սառնարան'];
  List<int> _cafeIds = <int>[2,3,4,6,7,8];
  List<int> _storeIds = <int>[2,3,4];


  @override
  void initState() {
    super.initState();
    _object = _cafeNames[0];
    _store = _storeNames[0];
    _monthName = _currentMonthName();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column (
          children: [
            Row (
              children: [
                Container(
                  margin: EdgeInsets.only(left: 5, top: 5, bottom: 5, right: 5),
                  child: Text(_monthName!)
                ),
                Container(
                  margin: EdgeInsets.only(left: 5, top: 5, bottom: 5, right: 5),
                  child: DropdownButton (
                    value: _object,
                    items: _cafeDropdownMenu(),
                    onChanged: _cafeChanged
                  )
                ),
                Container(
                    margin: EdgeInsets.only(left: 5, top: 5, bottom: 5, right: 5),
                    child: DropdownButton (
                        value: _store,
                        items: _storeDropDownMenu(),
                        onChanged: _storeChanged
                    )
                ),
                Expanded(
                  child: Container(

                  )
                ),
                Container(
                  child: TextButton(
                    onPressed: _showStore,
                    child: Text("Դիտել")
                  )
                )
              ],
            ),
            Expanded(
                child: Container (

                )
            )
          ],
        )
      )
    );
  }

  List<DropdownMenuItem<String>> _cafeDropdownMenu() {
    List<DropdownMenuItem<String>> items = [];
    for (String s in _cafeNames) {
      items.add(DropdownMenuItem(
        value: s,
        child: Text(s)
      ));
    }
    return items;
  }

  void _cafeChanged(String? s) {
    setState((){
      _object = s;
    });
  }

  List<DropdownMenuItem<String>> _storeDropDownMenu() {
    List<DropdownMenuItem<String>> items = [];
    for (String s in _storeNames) {
      items.add(DropdownMenuItem(
          value: s,
          child: Text(s)
      ));
    }
    return items;
  }

  void _storeChanged(String? s) {
    setState((){
      _store = s;
    });
  }

  String _currentMonthName() {
    var now = DateTime.now();
    return _months[now.month - 1];
  }

  void _showStore() async {
    try {
      final response = await http.get(Uri.parse(Config.server_jzstore)).timeout(Duration(seconds: 2), onTimeout: (){
        throw Exception("Server timeout. ${Config.server_jzstore}");
      });
      if (response.statusCode == 200) {
        print(response.body);
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print(e);
    }
  }
}
