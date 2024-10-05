import 'package:flutter/material.dart';
import 'package:varsity_app/views/portfolio.dart';
import 'package:varsity_app/views/leaderboard.dart';
import 'landing.dart';

class RootScreen extends StatefulWidget {
  RootScreen({Key? key}) : super(key: key);

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int selectedTab = 1;
  // List<Stocks> stonks = [];

  @override
  void initState() {
    // if (widget.tab != null) selectedTab = widget.tab!;
    super.initState();
  }

  Color selectedColor() =>  Colors.greenAccent;//Theme.of(context).primaryColor,

  @override
  Widget build(BuildContext context) {
    final List<Widget> widgetOptions = <Widget>[
      LeaderBoardScreen(),
      LandingScreen(),
      UserAssetsScreen(),
    ];

    final rootTab = <BottomNavigationBarItem>[
      BottomNavigationBarItem(icon: Icon(Icons.bar_chart), activeIcon: Icon(Icons.bar_chart, color: selectedColor()), label: 'Watchlist'),
      BottomNavigationBarItem(icon: Icon(Icons.home_filled),activeIcon: Icon(Icons.home_filled, color: selectedColor()), label: 'Home'),
      BottomNavigationBarItem(icon: Icon(Icons.pie_chart),activeIcon: Icon(Icons.pie_chart, color: selectedColor()), label: 'Portfolio'),
    ];

    // if (!widget.tablet) toastSuccess('No Tablet detected, using mobile view!');
    return  Scaffold(
            body: widgetOptions.elementAt(selectedTab), //MerchantLanding(),
            bottomNavigationBar: BottomNavigationBar(
              items: rootTab,
              currentIndex: selectedTab,
              unselectedItemColor: Colors.grey,
              selectedItemColor: selectedColor(),
              onTap: (index) => setState(() => selectedTab = index),
            )
    );
  }
}
