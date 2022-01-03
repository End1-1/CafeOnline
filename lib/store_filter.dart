import 'package:cafe_online/consts.dart' as Const;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cafe_online/ishowstore.dart';

class StoreFilter extends StatefulWidget {

  IShowStore ishowstore;

  StoreFilter({required this.ishowstore});

  @override
  _StoreFilterState createState() => _StoreFilterState();
}

class _StoreFilterState extends State<StoreFilter> {

  late String _object;
  late String _store;
  late String _month;
  late String _year;

  @override
  void initState() {
    super.initState();
    _object = Const.cafeNames[0];
    _store = Const.storeNames[0];
    _month = _currentMonthName();
    _year = _currentYearName();
  }

  @override
  Widget build(BuildContext context) {
    return Column (
        children: [
          Row (
            children: [
              Text("Տարի"),
              Expanded(
                  child: Container()
              ),
              Container(
                  margin: EdgeInsets.only(left: 5, top: 5, bottom: 5, right: 5),
                  child: DropdownButton (
                    value: _year,
                    items: _yearDropdownMenu(),
                    onChanged: _yearChanged,
                  )
              )
            ],
          ),
          Row (
            children: [
            Container(width: 5),
            Text("Ամիս"),
              Expanded(
                  child: Container()
              ),
            Container(
                margin: EdgeInsets.only(left: 5, top: 5, bottom: 5, right: 5),
                child: DropdownButton (
                    value: _month,
                    items: _monthDropdownMenu(),
                    onChanged: _monthChanged,
                )
            )
          ]
      ),
      Row (
        children: [
          Container(width: 5),
          Text("Մասնաճուղ"),
          Expanded(
              child: Container()
          ),
          Container(
            margin: EdgeInsets.only(left: 5, top: 5, bottom: 5, right: 5),
            child: DropdownButton (
              value: _object,
              items: _cafeDropdownMenu(),
              onChanged: _cafeChanged
          )
        )]),
        Row (
          children: [
            Container(width: 5),
            Text("Պահեստ"),
            Expanded(
              child: Container()
            ),
        Container(
          margin: EdgeInsets.only(left: 5, top: 5, bottom: 5, right: 5),
          child: DropdownButton (
            value: _store,
            items: _storeDropDownMenu(),
            onChanged: _storeChanged
            )
          ),
      ]),
      Row (
        children: [
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
    ]);
  }

  List<DropdownMenuItem<String>> _storeDropDownMenu() {
    List<DropdownMenuItem<String>> items = [];
    for (String s in Const.storeNames) {
      items.add(DropdownMenuItem(
          value: s,
          child: Text(s)
      ));
    }
    return items;
  }

  List<DropdownMenuItem<String>> _monthDropdownMenu() {
    List<DropdownMenuItem<String>> items = [];
    for (String s in Const.months) {
      items.add(DropdownMenuItem(
          value: s,
          child: Text(s)
      ));
    }
    return items;
  }

  List<DropdownMenuItem<String>> _yearDropdownMenu() {
    List<DropdownMenuItem<String>> items = [];
    for (String s in Const.years) {
      items.add(DropdownMenuItem(
        value: s,
        child: Text(s)
      ));
    }
    return items;
  }

  List<DropdownMenuItem<String>> _cafeDropdownMenu() {
    List<DropdownMenuItem<String>> items = [];
    for (String s in Const.cafeNames) {
      items.add(DropdownMenuItem(
          value: s,
          child: Text(s)
      ));
    }
    return items;
  }

  void _cafeChanged(String? s) {
    setState((){
      _object = s!;
    });
  }

  void _storeChanged(String? s) {
    setState((){
      _store = s!;
    });
  }

  void _monthChanged(String? s) {
    setState(() {
      _month = s!;
    });
  }

  void _yearChanged(String? s) {
    setState(() {
      _year = s!;
    });
  }

  String _currentMonthName() {
    var now = DateTime.now();
    return Const.months[now.month - 1];
  }

  String _currentYearName() {
    var now = DateTime.now();
    return now.year.toString();
  }

  void _showStore() {
    int cafeid = Const.cafeIds[Const.cafeNames.indexOf(_object)];
    int storeid = Const.storeIds[Const.storeNames.indexOf(_store)];
    int monthid = Const.months.indexOf(_month);
    int yearid = Const.years.indexOf(_year);
    widget.ishowstore.showStore(monthid, cafeid, storeid, yearid);
  }
}