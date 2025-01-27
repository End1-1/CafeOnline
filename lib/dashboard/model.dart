import 'dart:async';
import 'dart:convert';

import 'package:cafe_online/config.dart';
import 'package:cafe_online/goodsdriver.dart';
import 'package:cafe_online/screens/filter/screen.dart';
import 'package:cafe_online/web.dart';
import 'package:flutter/cupertino.dart';
import 'package:cafe_online/consts.dart' as Const;
import 'package:flutter/material.dart';

class DashboardModel {
  GoodsList goodsList = GoodsList();
  GoodsList proxyGoodsList = GoodsList();
  TextEditingController searchInGoodsController = TextEditingController();
  final gridController = StreamController();

  var object = Const.cafeNames[0];
  var store = Const.storeNames[0];
  var month = _currentMonthName();
  var year = _currentYearName();

  void filter() {
    Navigator.push(Const.navigatorKey.currentContext!, MaterialPageRoute(builder: (builder) => StoreFilter(this))).then((value) {
      if (value != null && value) {
        showStore();
      }
    });
  }

  void showStore() async {
    gridController.add(true);
    var web = Web(link: Config.server_jzstore);
    web.addParam("key", "adsfgjlsdkajfkskadfj")
        .addParam("request", "store")
        .addParam("cafe", Const.cafeIds[Const.cafeNames.indexOf(object)].toString())
        .addParam("store", Const.storeIds[Const.storeNames.indexOf(store)].toString())
        .addParam("month", Const.months.indexOf(month).toString())
        .addParam("year", Const.years.indexOf(year).toString());
    try {
      if (await web.GET()) {
        goodsList = GoodsList.fromJson(jsonDecode(web.body!));
        proxyGoodsList.goods.clear();
        proxyGoodsList.goods.addAll(goodsList.goods);
        gridController.add(1);
      }
      if (web.httpCode > 299) {
        gridController.add(web.body);
      }
    } catch (e) {
      gridController.add(e.toString());
    }
  }

  void searchInGoods(String s) {
    proxyGoodsList.goods.clear();
    for (Goods g in goodsList.goods) {
      if (g.name.toLowerCase().contains(s.toLowerCase())) {
        proxyGoodsList.goods.add(g);
      }
    }
    gridController.add(1);
  }

  void clearSearch() {
    searchInGoodsController.clear();
    proxyGoodsList.goods.clear();
    proxyGoodsList.goods.addAll(goodsList.goods);
  }

  static String _currentMonthName() {
    var now = DateTime.now();
    return Const.months[now.month - 1];
  }

  static String _currentYearName() {
    var now = DateTime.now();
    return now.year.toString();
  }
}