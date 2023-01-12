import 'package:flutter/material.dart';
import 'package:flutter_app_than_so_hoc_2/components/box_card.dart';
import 'package:flutter_app_than_so_hoc_2/utils/theme/app_color.dart';

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

  SizedBox get spacing => SizedBox(height: 15, width: 15);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: ListView(
        padding: EdgeInsets.all(20.0),
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          spacing,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _buildCircle(widget.tuoi_1.toString()),
                Expanded(child: Container(color: TSHColors().lineCircleColor, height: 4)),
                _buildCircle(widget.tuoi_2.toString()),
                Expanded(child: Container(color: TSHColors().lineCircleColor, height: 4)),
                _buildCircle(widget.tuoi_3.toString()),
                Expanded(child: Container(color: TSHColors().lineCircleColor, height: 4)),
                _buildCircle(widget.tuoi_4.toString()),
              ],
            ),
          ),
          spacing,
          widget.data1 == null
              ? Text('loadding')
              : box_card(
              data_box: widget.data1, dinh: widget.tuoi_1.toString()),
          spacing,
          widget.data2 == null
              ? Text('loadding')
              : box_card(
              data_box: widget.data2, dinh: widget.tuoi_2.toString()),
          spacing,
          widget.data3 == null
              ? Text('loadding')
              : box_card(
              data_box: widget.data3, dinh: widget.tuoi_3.toString()),
          spacing,
          widget.data4 == null
              ? Text('loadding')
              : box_card(
              data_box: widget.data4, dinh: widget.tuoi_4.toString()),
          spacing, spacing, spacing
        ],
      ),
    );
  }

  _buildCircle(String title) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                offset: Offset(1,3),
                blurRadius: 12,
                color: Color.fromARGB(0, 0, 0, 25)
            )
          ],
          shape: BoxShape.circle,
          border: Border.all(
            color: TSHColors().borderCircleColor,
          ),
          gradient: LinearGradient(
            colors: TSHColors().gradiantCircleColor,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          )
      ),
      child: Text(
        title,
        style: TextStyle(fontSize: 24, color: TSHColors().primaryTextColor, fontWeight: FontWeight.w500),
      ),
    );
  }
}
