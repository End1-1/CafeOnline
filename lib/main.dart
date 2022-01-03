import 'dart:convert';

import 'package:cafe_online/store_filter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cafe_online/config.dart';
import 'package:cafe_online/web.dart';
import 'package:cafe_online/goodsdriver.dart';
import 'package:cafe_online/consts.dart' as Const;
import 'package:cafe_online/ishowstore.dart';

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

class MyHomePage extends StatefulWidget  {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> implements IShowStore {


  GoodsList _goodsList = GoodsList();
  GoodsList _proxyGoodsList = GoodsList();
  TextEditingController _searchInGoods = TextEditingController();
  bool _hideFilter = false;

  @override
  void initState() {
    super.initState();
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
            _hideFilter ? Container() : StoreFilter(ishowstore: this),
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
                  ),
                  Expanded(
                      child: Container()
                  ),
                  Container(
                      child: IconButton(
                        icon: Image.asset("images/filter.png"),
                        onPressed: (){
                          setState((){_hideFilter = !_hideFilter;});
                        },
                      )
                  ),
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

  @override
  void showStore(int month, int cafeid, int storeid, int year) async {
    var web = Web(link: Config.server_jzstore);
      web.addParam("key", "adsfgjlsdkajfkskadfj")
          .addParam("request", "store")
          .addParam("cafe", cafeid.toString())
          .addParam("store", storeid.toString())
          .addParam("month", month.toString())
          .addParam("year", year.toString());
      if (await web.GET())
        setState(() {
          _hideFilter = true;
          _goodsList = GoodsList.fromJson(jsonDecode(web.body!));
          _proxyGoodsList.goods.clear();
          for (Goods g in _goodsList.goods) {
          _proxyGoodsList.goods.add(g);
        }
      });
    }

}
