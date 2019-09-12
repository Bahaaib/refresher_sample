import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'dart:async';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(
        title: 'Refresher App',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Refresher Sample'),
          backgroundColor: Colors.green,
        ),
        body: OrientationBuilder(builder: (context, orientation) {
          double _width = MediaQuery.of(context).size.width;

          return LiquidPullToRefresh(
            child: ListView.builder(
                itemCount: 10,
                itemBuilder: (BuildContext context, int position) =>
                    buildListItems(context, position, _width)),
            onRefresh: _refreshList,
            key: _refreshIndicatorKey,
          );
        }));
  }

  Widget buildListItems(BuildContext context, int position, double width) {
    return Center(
      child: Container(
          margin: EdgeInsets.only(top: width > 400 ? 15.0 : 10.0, bottom: 10.0),
          width: width > 400 ? 380.0 : 340.0,
          height: 90.0,
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
                color: Colors.grey[400], blurRadius: 20.0, spreadRadius: 5.0),
          ], color: Colors.white, borderRadius: BorderRadius.circular(10.0)),
          child: Material(
            type: MaterialType.transparency,
            borderRadius: BorderRadius.circular(15.0),
            child: InkWell(
              onTap: () {
                Scaffold.of(context).showSnackBar(
                    SnackBar(content: Text('Item #${position + 1} Clicked')));
              },
              child: Row(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 12.0),
                    width: 60.0,
                    height: 60.0,
                    decoration: BoxDecoration(
                        color: Colors.grey[300], shape: BoxShape.circle),
                    child: Image.asset(
                      'assets/ic_avatar.png',
                      color: Colors.grey[400],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(
                            top: 20.0, left: width > 400 ? 20.0 : 15.0),
                        child: Text(
                          'Keria S.',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            top: 15.0, left: width > 400 ? 20.0 : 15.0),
                        child: Text(
                          'Really Great Experience',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                    ],
                  ),
                  Spacer(
                    flex: 1,
                  ),
                  Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(
                            top: width > 400 ? 20.0 : 25.0,
                            right: width > 400 ? 20.0 : 12.0),
                        child: Text(
                          'Verified User',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.green),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            top: 10.0, right: width > 400 ? 20.0 : 12.0),
                        child: Text(
                          '2 days ago',
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: width > 400 ? 14.0 : 12.0),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )),
    );
  }

  //Your call to remote DB here
  Future<void> _refreshList() {
    final Completer<void> completer = Completer<void>();
    Timer(const Duration(seconds: 3), () {
      completer.complete();
    });
    return completer.future.then<void>((_) {
      _scaffoldKey.currentState?.showSnackBar(SnackBar(
          content: const Text('Refresh complete'),
          action: SnackBarAction(
              label: 'RETRY',
              onPressed: () {
                _refreshIndicatorKey.currentState.show();
              })));
    });
  }
}
