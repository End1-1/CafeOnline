import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'config.dart';
import 'web.dart';
import 'goodsdriver.dart';

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
  GoodsList _goodsList = GoodsList();
  GoodsList _proxyGoodsList = GoodsList();
  TextEditingController _searchInGoods = TextEditingController();

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
            Container(
              margin: EdgeInsets.only(left: 5, top: 5, bottom: 5),
              height: 30,
              child: Row(
                children: [
                  Container(
                    width: 100,
                    child:  TextField(
                      controller: _searchInGoods,
                      onChanged: searchInGoods,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Փնտրել",
                      ),
                    )
                  ),
                  Container(
                    child: IconButton(
                      icon: Image.asset("images/close.png"),
                      onPressed: (){
                        _searchInGoods.clear();
                        searchInGoods("");
                      },
                    )
                  )
                ],
              ),
            ),
            Expanded(
                child: Container (
                  child: GridView.builder(
                          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 500,
                              childAspectRatio: 10,
                              crossAxisSpacing: 5,
                              mainAxisSpacing: 5),
                          itemCount: _proxyGoodsList.goods.length + 1,
                          itemBuilder: (BuildContext ctx, index) {
                            if (index == 0) {
                              return getRow("Անվանում", "Սկիզբ", "Մուտք", "Վաճառք", "Դուրս գրում", "Մնացորդ");
                            } else {
                              Goods g = _proxyGoodsList.goods[index - 1];
                              return getRow(
                                  g.name, g.qtyTill.toStringAsFixed(1),
                                  g.qtyIn.toStringAsFixed(1),
                                  g.qtyOut.toStringAsFixed(1),
                                  g.qtyOut2.toStringAsFixed(1),
                                  g.qtyFinal.toStringAsFixed(1));
                            }
                          }
                    )
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
    var web = Web(link: Config.server_jzstore);
    web.addParam("key", "adsfgjlsdkajfkskadfj")
        .addParam("request", "store")
        .addParam("cafe", _cafeIds[_cafeNames.indexOf(_object!)].toString())
        .addParam("store", _storeIds[_storeNames.indexOf(_store!)].toString());
    if (await web.GET()) {
      setState(() {
        _goodsList = GoodsList.fromJson(jsonDecode(web.body!));
        _proxyGoodsList.goods.clear();
        for (Goods g in _goodsList.goods) {
          _proxyGoodsList.goods.add(g);
        }
      });
    }
  }

  Widget getRow(String c1, String c2, String c3, String c4, String c5, String c6) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(left: 4),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          Container (
            width: 150,
            child: Text(c1),
          ),
          Container(
            alignment: Alignment.topCenter,
            width: 50,
            child: Text(c2)
          ),
          Container(
            alignment: Alignment.topCenter,
            width: 60,
            child: Text("+" + c3)
          ),
          Container(
            alignment: Alignment.topCenter,
            width: 60,
            child: Text("-" + c4)
          ),
          Container(
            alignment: Alignment.topCenter,
            width: 50,
            child: Text("-" + c5)
          ),
          Container(
            alignment: Alignment.topCenter,
            width: 50,
            child: Text(c6)
          )
        ],
      ),
      decoration: BoxDecoration(
          color: Colors.amber,
          borderRadius: BorderRadius.circular(15)),
    );
  }

  void searchInGoods(String s) {
    _proxyGoodsList.goods.clear();
    for (Goods g in _goodsList.goods) {
      if (g.name.toLowerCase().contains(s.toLowerCase())) {
        _proxyGoodsList.goods.add(g);
      }
    }
    setState((){});
  }
}
