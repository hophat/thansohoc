import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_than_so_hoc_2/app/locator/app_locator.dart';
import 'package:flutter_app_than_so_hoc_2/main.dart';
import 'package:flutter_app_than_so_hoc_2/network/data/res_model/daily_res.dart';
import 'package:flutter_app_than_so_hoc_2/network/repository/user_repository.dart';
import 'package:flutter_app_than_so_hoc_2/utils/theme/app_color.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';

class DailyScreen extends StatefulWidget {
  final DailyRes? daily;

  const DailyScreen({super.key, this.daily});

  @override
  State<DailyScreen> createState() => _DailyScreenState();
}

class _DailyScreenState extends State<DailyScreen> {
  DailyRes? daily;

  List<bool> _isOpens = [true, false, false];

  bool _isLoading = false;

  @override
  void initState() {
    daily = widget.daily;

    if (daily == null) {
      _isLoading = true;
      getIt.get<UserRepository>().daily().then((v) {
        _isLoading = false;
        v.fold((l) {
          // ScaffoldMessenger.of(context)
          //     .showSnackBar(SnackBar(content: Text(l.message ?? 'Error')));
        }, (r) {
          daily = r;
        });
        if (!mounted) return;
        setState(() {});
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Colors.white
            // image: DecorationImage(
            //   // image: AssetImage('assets/tet/bg.png'),
            //   fit: BoxFit.cover,
            // ),
            ),
        child: Column(
          children: [
            AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Text('Tử vi hôm nay'),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Skeletonizer(
                  enabled: _isLoading,
                  child: Column(
                    children: [
                      _date(),
                      ...() {
                        if (daily == null && !_isLoading)
                          return [
                            SizedBox(height: 150),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Center(
                                child: Text(
                                  'Chưa tìm thấy thông tin tử vi của bạn! Quay lại vào ngày hôm sau nhé!',
                                  style: TextStyle(fontSize: 16),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )
                          ];
                        return [
                          // _tarotCard(),
                          // SizedBox(height: 12),
                          // Text(
                          //   daily?.card ?? '',
                          //   style: TextStyle(
                          //       fontSize: 16, fontWeight: FontWeight.bold),
                          // ),
                          // Text(
                          //   daily?.category != null
                          //       ? '(${daily?.category})'
                          //       : '',
                          //   style: TextStyle(
                          //       fontSize: 16,
                          //       fontWeight: FontWeight.w400,
                          //       fontStyle: FontStyle.italic),
                          // ),
                          _content(),
                        ];
                      }(),
                      SizedBox(height: 150),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _date() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        daily?.createdAt != null
            ? DateFormat('dd MMM yyyy', langCur).format(daily!.createdAt!)
            : '',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  _content() {
    return ExpansionPanelList(
      children: [
        ExpansionPanel(
          headerBuilder: (context, isExpanded) {
            return ListTile(
              title: Text('Tình yêu'),
              leading: _isOpens[0]
                  ? Icon(Icons.favorite)
                  : Icon(Icons.favorite_border),
              onTap: () {
                _isOpens[0] = !isExpanded;
                setState(() {});
              },
            );
          },
          body: ListTile(
            title: Text(daily?.love ?? ''),
          ),
          isExpanded: _isOpens[0],
        ),
        ExpansionPanel(
          headerBuilder: (context, isExpanded) {
            return ListTile(
              title: Text('Sự nghiệp'),
              leading:
                  _isOpens[1] ? Icon(Icons.work) : Icon(Icons.work_outline),
              onTap: () {
                _isOpens[1] = !isExpanded;
                setState(() {});
              },
            );
          },
          body: ListTile(
            title: Text(daily?.career ?? ''),
          ),
          isExpanded: _isOpens[1],
        ),
        ExpansionPanel(
          headerBuilder: (context, isExpanded) {
            return ListTile(
              title: Text('Tài chính'),
              leading: _isOpens[2]
                  ? Icon(Icons.monetization_on)
                  : Icon(Icons.monetization_on_outlined),
              onTap: () {
                _isOpens[2] = !isExpanded;
                setState(() {});
              },
            );
          },
          body: ListTile(
            title: Text(daily?.finance ?? ''),
          ),
          isExpanded: _isOpens[2],
        ),
      ],
      expansionCallback: (int index, isExpanded) {
        _isOpens[index] = isExpanded;
        setState(() {});
      },
    );
  }

  Widget _tarotCard() {
    final skeleton = Skeletonizer(
        child: Container(
      color: Colors.grey,
      height: 300,
      width: 150,
    ));
    return Row(
      children: [
        Expanded(
            child: CachedNetworkImage(
          imageUrl: daily?.image ?? '',
          height: 300,
          placeholder: (context, url) => skeleton,
          errorWidget: (context, url, error) => skeleton,
        )),
        SizedBox(width: 12),
        Expanded(
            child: CachedNetworkImage(
          imageUrl: daily?.image2 ?? '',
          height: 300,
          placeholder: (context, url) => skeleton,
          errorWidget: (context, url, error) => skeleton,
        )),
      ],
    );
  }
}
