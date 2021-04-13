import 'package:flutter_app_than_so_hoc_2/components/box_card.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class diengiai_tab2_Page extends StatefulWidget {
  final data1;
  final data2;
  final data3;
  final data4;

  final tuoi_1;
  final tuoi_2;
  final tuoi_3;
  final tuoi_4;

  const diengiai_tab2_Page({
    this.data1,
    this.data2,
    this.data3,
    this.data4,
    this.tuoi_1,
    this.tuoi_2,
    this.tuoi_3,
    this.tuoi_4,
  });

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _My_tab2();
  }
}

// ignore: camel_case_types
class _My_tab2 extends State<diengiai_tab2_Page> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/bg01.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: ListView(
        padding: EdgeInsets.all(20.0),
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 20,
            width: 100,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                widget.tuoi_1.toString(),
                style: TextStyle(fontSize: 20, color: Colors.white70),
              ),
              Text(
                widget.tuoi_2.toString(),
                style: TextStyle(fontSize: 20, color: Colors.white70),
              ),
              Text(
                widget.tuoi_3.toString(),
                style: TextStyle(fontSize: 20, color: Colors.white70),
              ),
              Text(
                widget.tuoi_4.toString(),
                style: TextStyle(fontSize: 20, color: Colors.white70),
              ),
            ],
          ),
          SizedBox(
            height: 20,
            width: 100,
          ),
          widget.data1 == null
              ? Text('loadding')
              : box_card(
                  data_box: widget.data1, dinh: widget.tuoi_1.toString()),
          SizedBox(
            height: 20,
            width: 100,
          ),
          widget.data2 == null
              ? Text('loadding')
              : box_card(
                  data_box: widget.data2, dinh: widget.tuoi_2.toString()),
          SizedBox(
            height: 20,
            width: 100,
          ),
          widget.data3 == null
              ? Text('loadding')
              : box_card(
                  data_box: widget.data3, dinh: widget.tuoi_3.toString()),
          SizedBox(
            height: 20,
            width: 100,
          ),
          widget.data4 == null
              ? Text('loadding')
              : box_card(
                  data_box: widget.data4, dinh: widget.tuoi_4.toString()),
        ],
      ),
    );
  }
}
