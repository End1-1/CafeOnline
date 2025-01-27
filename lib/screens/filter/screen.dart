import 'package:cafe_online/consts.dart' as Const;
import 'package:cafe_online/dashboard/model.dart';
import 'package:flutter/material.dart';

class StoreFilter extends StatefulWidget {
  final DashboardModel model;

  StoreFilter(this.model);

  @override
  _StoreFilterState createState() => _StoreFilterState();
}

class _StoreFilterState extends State<StoreFilter> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text('Ֆիլտր'),
    ),
    body:Column(children: [
      Row(
        children: [
          Text("Տարի"),
          Expanded(child: Container()),
          Container(
              margin: EdgeInsets.only(left: 5, top: 5, bottom: 5, right: 5),
              child: DropdownButton(
                value: widget.model.year,
                items: _yearDropdownMenu(),
                onChanged: _yearChanged,
              ))
        ],
      ),
      Row(children: [
        Container(width: 5),
        Text("Ամիս"),
        Expanded(child: Container()),
        Container(
            margin: EdgeInsets.only(left: 5, top: 5, bottom: 5, right: 5),
            child: DropdownButton(
              value: widget.model.month,
              items: _monthDropdownMenu(),
              onChanged: _monthChanged,
            ))
      ]),
      Row(children: [
        Container(width: 5),
        Text("Մասնաճուղ"),
        Expanded(child: Container()),
        Container(
            margin: EdgeInsets.only(left: 5, top: 5, bottom: 5, right: 5),
            child: DropdownButton(
                value: widget.model.object,
                items: _cafeDropdownMenu(),
                onChanged: _cafeChanged))
      ]),
      Row(children: [
        Container(width: 5),
        Text("Պահեստ"),
        Expanded(child: Container()),
        Container(
            margin: EdgeInsets.only(left: 5, top: 5, bottom: 5, right: 5),
            child: DropdownButton(
                value: widget.model.store,
                items: _storeDropDownMenu(),
                onChanged: _storeChanged)),
      ]),
      Row(
        children: [
          Expanded(child: Container()),
          Container(
              child: TextButton(onPressed: (){Navigator.pop(context, true);}, child: Text("Դիտել")))
        ],
      ),
    ]));
  }

  List<DropdownMenuItem<String>> _storeDropDownMenu() {
    List<DropdownMenuItem<String>> items = [];
    for (String s in Const.storeNames) {
      items.add(DropdownMenuItem(value: s, child: Text(s)));
    }
    return items;
  }

  List<DropdownMenuItem<String>> _monthDropdownMenu() {
    List<DropdownMenuItem<String>> items = [];
    for (String s in Const.months) {
      items.add(DropdownMenuItem(value: s, child: Text(s)));
    }
    return items;
  }

  List<DropdownMenuItem<String>> _yearDropdownMenu() {
    List<DropdownMenuItem<String>> items = [];
    for (String s in Const.years) {
      items.add(DropdownMenuItem(value: s, child: Text(s)));
    }
    return items;
  }

  List<DropdownMenuItem<String>> _cafeDropdownMenu() {
    List<DropdownMenuItem<String>> items = [];
    for (String s in Const.cafeNames) {
      items.add(DropdownMenuItem(value: s, child: Text(s)));
    }
    return items;
  }

  void _cafeChanged(String? s) {
    setState(() {
      widget.model.object = s!;
    });
  }

  void _storeChanged(String? s) {
    setState(() {
      widget.model.store = s!;
    });
  }

  void _monthChanged(String? s) {
    setState(() {
      widget.model.month = s!;
    });
  }

  void _yearChanged(String? s) {
    setState(() {
      widget.model.year = s!;
    });
  }
}
