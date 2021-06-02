import 'dart:convert';

class Goods {
  int id;
  String group;
  String name;
  double qtyTill;
  double amountTill;
  double qtyIn;
  double amountIn;
  double qtyOut;
  double amountOut;
  double qtyOut2;
  double amountOut2;
  double qtyFinal;
  double amountFinal;

  Goods({
    required this.id,
    required this.group,
    required this.name,
    this.qtyTill = 0,
    this.amountTill = 0,
    this.qtyIn = 0,
    this.amountIn = 0,
    this.qtyOut = 0,
    this.amountOut = 0,
    this.qtyOut2 = 0,
    this.amountOut2 = 0,
    this.qtyFinal = 0,
    this.amountFinal = 0
  });

  factory Goods.fromJson(Map<String, dynamic> json) {
    Goods g = Goods(
      id: json["ID"],
      group: json["TYPENAME"],
      name: json["FOODNAME"],
      qtyTill: json["QTY_TILL"] == null ? 0 : json["QTY_TILL"] + .0,
      amountTill: json["AMOUNT_TILL"] == null ? 0 : json["AMOUNT_TILL"] + .0,
      qtyIn: json["QTY_IN"] == null ? 0 : json["QTY_IN"] + .0,
      amountIn: json["AMOUNT_IN"] == null ? 0 : json["AMOUNT_IN"] + .0,
      qtyOut: json["QTY_OUT"] == null ? 0 : json["QTY_OUT"] + .0,
      amountOut: json["AMOUNT_OUT"] == null ? 0 : json["AMOUNT_OUT"] + .0,
      qtyOut2: json["QTY_OUT2"] == null ? 0 : json["QTY_OUT2"] + .0,
      amountOut2: json["AMOUNT_OUT2"] == null ? 0 : json["AMOUNT_OUT2"] + .0,
    );
    g.qtyFinal = g.qtyTill + g.qtyIn - g.qtyOut - g.qtyOut2;
    g.amountFinal = g.amountTill + g.amountIn - g.amountOut - g.amountOut2;
    return g;
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