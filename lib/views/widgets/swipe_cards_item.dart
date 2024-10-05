import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:swipe_cards/draggable_card.dart';
import 'package:swipe_cards/swipe_cards.dart';
import 'package:varsity_app/api/local_service.dart';
import 'package:varsity_app/bloc/cards_bloc/card_bloc.dart';

import '../../models/assets.dart';
import '../../models/stocks.dart';

class SwipeCardItem extends StatefulWidget {
  SwipeCardItem({Key? key}) : super(key: key);

  @override
  _SwipeCardItemState createState() => _SwipeCardItemState();
}

class _SwipeCardItemState extends State<SwipeCardItem> {
  final controller = ConfettiController();
  bool isCelebrating = false;
  List<SwipeItem> _swipeItems = [];
  MatchEngine matchEngine = MatchEngine();

  void snackBar(String text) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text), duration: Duration(milliseconds: 500),));

  Widget flag(String text){
    return Container(
      margin: const EdgeInsets.all(15.0),
      padding: const EdgeInsets.all(3.0),
      child: Text(text),
    );
  }

    buyDialog(Stocks stock, BuildContext dContext) async {
    int qty = 1;
    var marketInfo = await LocalService().getMarketInfo(stock.symbol);

    if (marketInfo != null)
    showDialog(
        context: dContext,
        builder: (BuildContext builderContext) {
          return StatefulBuilder(builder: (stfContext, stfSetState) {
            return Center(
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Container(
                      width: 90.w,
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      child: Padding(
                        padding: EdgeInsets.all(14.sp),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text('Buy ${stock.name} Asset?', style: TextStyle(
                                  fontSize: 16.sp,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                              SizedBox(height: 5.sp),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                      iconSize: 20,
                                      icon: const Icon(Icons.remove_circle,
                                          color: Colors.black),
                                      onPressed: () =>
                                          stfSetState(() {
                                            if (qty > 1) qty--;
                                          }
                                          )),
                                  Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: Text(qty.toString(),
                                          style: TextStyle(fontSize: 15.sp,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black))),
                                  IconButton(
                                      iconSize: 20,
                                      icon: const Icon(Icons.add_circle,
                                          color: Colors.black),
                                      onPressed: () => stfSetState(() => qty++)),
                                ],
                              ),
                              Text('\$${(qty * num.parse(marketInfo.openPrice)).toStringAsFixed(2)}',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp, color: Colors.blueGrey)),
                              TextButton(onPressed: () async {
                                await LocalService().createTransaction(Asset(name: stock.name!, symbol: stock.symbol, boughtPrice: num.parse(marketInfo.openPrice), quantity: qty));
                                controller.play();
                                Navigator.of(dContext).pop();
                                Future.delayed(Duration(seconds: 1)).then((value) => controller.stop());
                              },
                                  child: Text('Buy Paper Asset',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15.sp),))
                              // CircleAvatar(backgroundImage: AssetImage("assets/images/logo.png"), radius: 7.w),

                            ])))
                ]));
          });
        });
  }

  @override
  void initState() {
    BlocProvider.of<CardsBloc>(context).add(GetAllCardsItems());
    // for (var stock in BlocProvider.of<CardsBloc>(context).state.items) {
    //   _swipeItems.add(SwipeItem(
    //       content: stock,
    //       likeAction: () {
    //         snackBar("Added ${stock.name} to Watchlist");
    //         BlocProvider.of<WatchListBloc>(context).add(AddWatchList(stock));
    //         controller.play();
    //         Future.delayed(Duration(seconds: 1)).then((value) => controller.stop());
    //       },
    //       nopeAction: () => snackBar("Not Interested in ${stock.name}"),
    //       superlikeAction: () => snackBar("Buying ${stock.name}"),
    //       onSlideUpdate: (SlideRegion? region) async {
    //         print("Region $region");
    //       }
    //   ));
    // }
    // matchEngine = MatchEngine(swipeItems: _swipeItems);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 5.w),
      margin: EdgeInsets.only(bottom: 30.h),
      height: MediaQuery.of(context).size.height - kToolbarHeight,
      child: BlocListener<CardsBloc, CardsState>(listener: (context, state) {
        if (state.status.isCardLoaded) {
          for (var stock in state.items) {
            _swipeItems.add(SwipeItem(
                content: stock,
                likeAction: () async {
                  snackBar("Buying ${stock.name}");
                  await buyDialog(stock, context);
                  // snackBar("Added ${stock.name} to Portfolio");
                  // BlocProvider.of<WatchListBloc>(context).add(AddWatchList(stock));
                },
                nopeAction: () => snackBar("Not Interested in ${stock.name}"),
                superlikeAction: () => snackBar("Buying ${stock.name}"),
                onSlideUpdate: (SlideRegion? region) async {
                  print("Region $region");
                }
            ));
          }
          matchEngine = MatchEngine(swipeItems: _swipeItems);
          BlocProvider.of<CardsBloc>(context).add(UpdateEngine(matchEngine));
          setState(() => _swipeItems = _swipeItems);
        }}, child: BlocBuilder<CardsBloc, CardsState>(builder: (context, state){
        if (state.items.isNotEmpty) {
          return Stack(
              children: [
                SwipeCards(
                  matchEngine: matchEngine,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: _swipeItems[index].content.color,
                        ),
                        padding: EdgeInsets.all(1.w),
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(_swipeItems[index].content.symbol,
                                style: TextStyle(fontSize: 48.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.greenAccent)),
                            Text(_swipeItems[index].content.name,
                                style: TextStyle(
                                    fontSize: 16.sp, color: Colors.grey),
                                textAlign: TextAlign.center),
                          ],
                        )
                    );
                  },
                  onStackFinished: () {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Stack Finished"),
                      duration: Duration(milliseconds: 500),
                    ));
                  },
                  itemChanged: (SwipeItem item, int index){
                    print("item: ${item.content.symbol}, index: $index");
                    BlocProvider.of<CardsBloc>(context).add(UpdateCurrentStock(matchEngine.currentItem!.content));
                  },
                  leftSwipeAllowed: true,
                  rightSwipeAllowed: true,
                  upSwipeAllowed: false,
                  fillSpace: true,
                  likeTag: flag('Add to Watchlist'),
                  nopeTag: flag('Not Interested'),
                  superLikeTag: flag('Buy paper stocks'),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                          onPressed: () =>matchEngine.currentItem?.nope(),
                          child: Icon(Icons.cancel)),
                      // ElevatedButton(
                      //     onPressed: () {matchEngine.currentItem?.superLike();},
                      //     child:Icon(Icons.add)),// Text("Superlike")),
                      ElevatedButton(
                          onPressed: () =>matchEngine.currentItem?.like(),
                          child: Icon(Icons.add_chart))
                    ],
                  ),
                ),
                Align(alignment: Alignment.topCenter,
                    child: ConfettiWidget(
                      confettiController: controller,
                      shouldLoop: false,
                      blastDirectionality: BlastDirectionality.explosive,
                    )
                ),
              ]);
        } else
          // if (state.status.isLoading){
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                child: CircularProgressIndicator(),
              )
            ],
          );
        // } else {// if (state.status.isError){
        //   return Center(child: Text('There seems to be an error getting cards, please try again later'));
        // }
    })));

  }

}
