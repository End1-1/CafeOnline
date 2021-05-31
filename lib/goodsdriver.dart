import 'dart:convert';

class Goods {
  int id;
  String group;
  String name;
  double qtyTill;
  double amountTill;

  Goods({
    required this.id,
    required this.group,
    required this.name,
    this.qtyTill = 0,
    this.amountTill = 0
  });

  factory Goods.fromJson(Map<String, dynamic> json) {
    return Goods(
      id: json["ID"],
      group: json["TYPENAME"],
      name: json["FOODNAME"],
      qtyTill: json["QTY_TILL"] == null ? 0 : json["QTY_TILL"] + .0,
      amountTill: json["AMOUNT_TILL"] == null ? 0 : json["AMOUNT_TILL"] + .0
    );
  }
}

class GoodsList {
  List<Goods> goods = [];

  GoodsList();

  factory GoodsList.fromJson(Map<String, dynamic> json) {
    GoodsList gl = GoodsList();
    List<dynamic> goods = jsonDecode(json["data"]);
    goods.forEach((element) {
      gl.goods.add(Goods.fromJson(element));
    });
    return gl;
  }
}