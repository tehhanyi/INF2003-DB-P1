import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_podium/flutter_podium.dart';
import 'package:sizer/sizer.dart';

import '../bloc/portfolio_bloc/portfolio_bloc.dart';
import '../models/assets.dart';

class LeaderBoardScreen extends StatefulWidget {
  LeaderBoardScreen({Key? key}) : super(key: key);

  @override
  State<LeaderBoardScreen> createState() => _LeaderBoardScreenState();
}

class _LeaderBoardScreenState extends State<LeaderBoardScreen> with SingleTickerProviderStateMixin {

  @override
  void initState() {
    BlocProvider.of<PortfolioBloc>(context).add(GetLeaderboard());// allStocks();
    super.initState();
  }

  List<Widget> _renderLeaderboardItems(List<Asset> portfolio) {
    List<Widget> widgets = [];
    widgets.add(
        Padding(
          padding: EdgeInsets.symmetric( horizontal: 5.w),
          child: Row(
              children: [
                Expanded(flex: 1, child: Text('Rank',style: TextStyle(color:Colors.grey))),
                Expanded(flex: 5, child: Text('Stock',style: TextStyle(color:Colors.grey))),
                Flexible(flex: 1, child: Text('Qty', style: TextStyle(color:Colors.grey)))
              ]
          ),
        )
    );
    for (int i = 3; i < portfolio.length; i ++) {
      widgets.add(Container(
          margin: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 5.w),
          child:  Row(
              children: [
                Expanded(
                    flex: 1,
                    child: Text((i+1).toString())),
                Expanded(
                    flex: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(portfolio[i].name, style: TextStyle(),maxLines: 1),
                        Text(portfolio[i].symbol,style: TextStyle(color:Colors.blueGrey))
                      ],
                    )),
                Flexible(
                    child: Text('${portfolio[i].quantity}'.toString())),
              ]
          )));
      widgets.add(const Divider(height: 1));
    }
    if (widgets.isNotEmpty) {
      widgets.removeLast();
    }
    // widgets.add(Center(
    //     child: Padding(
    //         padding: const EdgeInsets.only(bottom: 0),
    //         child: const Text('You have reached the end!', style: TextStyle(fontWeight: FontWeight.bold)))));

    return widgets;
  }
  Widget podium(List<Asset> assets){
    if (assets.length < 3) assets = [Asset(), Asset(), Asset()];
    return
      // Column(children: [
      Podium(
        color: Colors.greenAccent,
        firstPosition:
        Column(children: [
          Text('1st (${assets[0].quantity})',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18.sp)),
          Text(assets[0].name, textAlign: TextAlign.center, style: TextStyle(color: Colors.blueGrey),maxLines: 2),
        ]),
        firstRankingText: assets[0].symbol.toString(),
        secondPosition:
        Column(children: [
          Text('2nd (${assets[1].quantity})',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 14.sp)),
          Text(assets[1].name,textAlign: TextAlign.center, style: TextStyle(color: Colors.blueGrey)),
        ]),
        secondRankingText: assets[1].symbol.toString(),
        thirdPosition:
        Column(children: [
          Text('3rd (${assets[2].quantity})',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 14.sp)),
          Text(assets[2].name, textAlign: TextAlign.center, style: TextStyle(color: Colors.blueGrey)),
        ]),
        thirdRankingText: (assets[2].symbol.length < 3)? assets[2].symbol : assets[2].symbol.substring(0,3) ,
      );
      // Padding(
      //   padding: EdgeInsets.symmetric( horizontal: 5.w),
      //   child: Row(
      //       children: [
      //         Expanded(flex: 1, child: Text('Rank',style: TextStyle(color:Colors.grey))),
      //         Expanded(flex: 5, child: Text('Stock',style: TextStyle(color:Colors.grey))),
      //         Expanded(flex: 1, child: Text('Qty', style: TextStyle(color:Colors.grey)))
      //       ]
      //   ),
      // )
    // ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Leaderboard', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 24.sp)),
          automaticallyImplyLeading: false,
        ),
        body:
        BlocBuilder<PortfolioBloc, PortfolioState>(builder: (context, state) {
          if (state.status.isSuccess) {
            return Column(children: [
              Text('Top 10 Users\' Favourite Stocks', style: TextStyle(color: Colors.white, fontSize: 16.sp)),
              podium(state.transactions),
              SizedBox(height: 2.h,),
              if (state.transactions.length > 3)
                Container(height: 30.h, child: ListView(children: _renderLeaderboardItems(state.transactions)))
            ]);
          }
          else return const Center(child: CircularProgressIndicator());
        })
    );
  }
}