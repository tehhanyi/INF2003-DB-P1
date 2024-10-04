import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:varsity_app/views/user_holding.dart';
import 'package:varsity_app/views/watchlist.dart';
import '../bloc/portfolio_bloc/portfolio_bloc.dart';
import 'landing.dart';

class RootScreen extends StatefulWidget {
  RootScreen({Key? key}) : super(key: key);

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int selectedTab = 0;
  // List<Stocks> stonks = [];

  @override
  void initState() {
    BlocProvider.of<PortfolioBloc>(context).add(GetName());// allStocks();
    BlocProvider.of<PortfolioBloc>(context).add(GetAllTransactions());
    // if (widget.tab != null) selectedTab = widget.tab!;
    super.initState();
  }

  Color selectedColor() =>  Colors.greenAccent;//Theme.of(context).primaryColor,

  // allStocks() async {
  //   stonks = await LocalService().getAllStocks();
  // }


  @override
  Widget build(BuildContext context) {
    final List<Widget> widgetOptions = <Widget>[
      LandingScreen(),
      UserAssetsScreen(),
      // WatchlistScreen(),
    ];

    final rootTab = <BottomNavigationBarItem>[
      BottomNavigationBarItem(icon: Icon(Icons.home_filled),activeIcon: Icon(Icons.home_filled, color: selectedColor()), label: 'Home'),
      BottomNavigationBarItem(icon: Icon(Icons.pie_chart),activeIcon: Icon(Icons.pie_chart, color: selectedColor()), label: 'Portfolio'),
      // BottomNavigationBarItem(icon: Icon(Icons.bar_chart), activeIcon: Icon(Icons.bar_chart, color: selectedColor()), label: 'Watchlist'),
    ];

    // if (!widget.tablet) toastSuccess('No Tablet detected, using mobile view!');
    return Scaffold(
      body: widgetOptions.elementAt(selectedTab),//MerchantLanding(),
      bottomNavigationBar:BottomNavigationBar(
        items: rootTab,
        currentIndex: selectedTab,
        unselectedItemColor: Colors.grey,
        selectedItemColor: selectedColor() ,
        onTap: (index) => setState(() => selectedTab = index),
      ),
    );
  }
}
