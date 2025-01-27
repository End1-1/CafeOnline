import 'package:cafe_online/dashboard/model.dart';
import 'package:cafe_online/goodsdriver.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  final model = DashboardModel();

  DashboardScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
          actions: [
            IconButton(onPressed: model.filter, icon: Icon(Icons.filter_alt))
          ],
        ),
        body: Center(
            child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(left: 5, top: 5, bottom: 5),
              height: 30,
              child: Row(
                children: [
                  Container(
                      width: 200,
                      child: TextField(
                        controller: model.searchInGoodsController,
                        onChanged: model.searchInGoods,
                        style: const TextStyle(fontSize: 12),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Փնտրել",
                        ),
                      )),
                  Container(
                      child: IconButton(
                    icon: Image.asset("images/close.png"),
                    onPressed: model.clearSearch,
                  )),
                  Expanded(child: Container()),
                ],
              ),
            ),
            Expanded(
                child: StreamBuilder(
                    stream: model.gridController.stream,
                    builder: (builder, snapshot) {
                      if (!snapshot.hasData) {
                        return Container();
                      }
                      if (snapshot.data is bool) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (snapshot.data is String) {
                        return Center(
                          child: Text(
                              snapshot.data,
                              textAlign: TextAlign.center,
                          ),
                        );
                      }
                      return GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 500,
                                  childAspectRatio: 10,
                                  crossAxisSpacing: 5,
                                  mainAxisSpacing: 5),
                          itemCount: model.proxyGoodsList.goods.length + 1,
                          itemBuilder: (BuildContext ctx, index) {
                            if (index == 0) {
                              return getRow("Անվանում", "Սկիզբ", "Մուտք",
                                  "Վաճառք", "Դուրս գրում", "Մնացորդ");
                            } else {
                              Goods g = model.proxyGoodsList.goods[index - 1];
                              return getRow(
                                  g.name,
                                  g.qtyTill.toStringAsFixed(1),
                                  g.qtyIn.toStringAsFixed(1),
                                  g.qtyOut.toStringAsFixed(1),
                                  g.qtyOut2.toStringAsFixed(1),
                                  g.qtyFinal.toStringAsFixed(1));
                            }
                          });
                    }))
          ],
        )));
  }

  Widget getRow(
      String c1, String c2, String c3, String c4, String c5, String c6) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(left: 4),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          Container(
            width: 150,
            child: Text(c1),
          ),
          Container(alignment: Alignment.topCenter, width: 50, child: Text(c2)),
          Container(
              alignment: Alignment.topCenter, width: 60, child: Text("+" + c3)),
          Container(
              alignment: Alignment.topCenter, width: 60, child: Text("-" + c4)),
          Container(
              alignment: Alignment.topCenter, width: 50, child: Text("-" + c5)),
          Container(alignment: Alignment.topCenter, width: 50, child: Text(c6))
        ],
      ),
      decoration: BoxDecoration(
          color: Colors.amber, borderRadius: BorderRadius.circular(15)),
    );
  }
}
