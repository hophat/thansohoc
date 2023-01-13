import 'package:flutter/material.dart';
import 'package:flutter_app_than_so_hoc_2/utils/theme/app_color.dart';
import 'package:flutter_app_than_so_hoc_2/utils/theme/app_theme.dart';

class EventResult extends StatefulWidget {
  final String title, content;
  final bool hasNext;
  final Function(bool) onHasNext;

  const EventResult({Key? key, required this.title, required this.content, this.hasNext = false, required this.onHasNext}) : super(key: key);

  @override
  State<EventResult> createState() => _EventResultState();
}

class _EventResultState extends State<EventResult> {
  SizedBox get spacing => SizedBox(height: 15, width: 15);
  Size get _size => MediaQuery.of(context).size;

  String  get title => widget.title;
  String  get content => widget.content;
  bool get hasNext => widget.hasNext;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      left: false,
      right: false,
      child: TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 500),
          tween: Tween<double>(begin: 0.3, end: 1),
        child: Container(
          color: Colors.transparent,
          child: Column(
            children: [
              spacing,
              _buildContainer(),
              if(hasNext) ...[spacing,
              GestureDetector(
                onTap: () => widget.onHasNext(false),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 15 * 2, vertical: 15),
                  decoration: TSHTheme().cardEventDecoration,
                  child: Text(
                    'Gieo quẻ tiếp ...',
                    style: TextStyle(
                        color: TSHColors().primaryTextColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              )],
              spacing,
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 15 * 2, vertical: 15),
                  decoration: TSHTheme().cardEventDecoration,
                  child: RichText(
                    text: TextSpan(
                        style: TextStyle(
                            color: TSHColors().primaryTextColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                        children: [
                          WidgetSpan(
                            child: Icon(Icons.abc),
                            alignment: PlaceholderAlignment.middle,
                          ),
                          TextSpan(
                            text: ' chia sẻ',
                          )
                        ]),
                  )),
              spacing,
            ],
          ),
        ),
        builder: (_, v, c) {
          return Transform.scale(
            scale: v,
            child: c,
          );
        }
      ),
    );
  }

  _buildContainer() {
    return Expanded(
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/tet/bg_result.png'),
          Align(
              alignment: Alignment(-1.0, 0.0),
              child: Image.asset('assets/tet/cloud2.png')),
          Align(
              alignment: Alignment(-1.0, 0.0),
              child: Image.asset('assets/tet/cloud1.png')),
          Align(
              alignment: Alignment(1.0 - 0.2, -0.65),
              child: Image.asset('assets/tet/cloud2.png')),
          Align(
              alignment: Alignment(1.0 - 0.2, 0.65),
              child: Image.asset('assets/tet/cloud1.png')),

          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: 50,
                horizontal: _size.width/4,
              ),
              child: Scrollbar(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text(title, style: TextStyle(color: TSHColors().titleCardColor3, fontSize: 20, fontWeight: FontWeight.bold),),
                      spacing,
                      Text(content, style: TextStyle(color: TSHColors().titleCardColor3),),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
