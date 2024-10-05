
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:varsity_app/views/widgets/see_more.dart';
import 'package:varsity_app/views/widgets/swipe_cards_item.dart';
import '../bloc/cards_bloc/card_bloc.dart';

class LandingScreen extends StatefulWidget {
  // final List<Stocks> stocks;
  LandingScreen({Key? key}) : super(key: key);

  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  String desc = 'Paper Trades stands at the intersection of technology, education, and finance, offering a unique solution to the modern trades\'s dilemma. By combining a user-friendly interface with powerful technological underpinnings and educational elements, it promises to transform the way individuals engage with the stock market. Whether you\'re a seasoned trader or just starting, Paper Trades is your gateway to mastering the art of trading, one swipe at a time.';
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  Widget About(){
    return Column(
      children: [
        SizedBox(height: 5.5.h,),
        IconButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext builderContext) {
                    return Center(
                        child: Column(mainAxisSize: MainAxisSize.min, children: [
                          Container(
                              width: 88.w,
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(Radius.circular(15))),
                              child: Padding(
                                padding: EdgeInsets.all(14.sp),
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text('About Paper Trades', style: TextStyle(fontSize: 17.sp, color: Colors.black, fontWeight: FontWeight.bold)),
                                      SizedBox(height: 10.sp),
                                      Text(desc, style: TextStyle(fontSize: 11.sp, color: Colors.grey)),
                                      SizedBox(height: 10.sp),
                                      Text('Swipe Right to add security\nSwipe Left to pass a security', style: TextStyle(fontSize: 12.sp, color: Colors.grey),textAlign: TextAlign.center,),
                                      SizedBox(height: 10.sp),
                                      GestureDetector(
                                        onTap: () => Navigator.of(builderContext).pop(),
                                        child: CircleAvatar(backgroundImage: AssetImage("assets/images/logo.png"), radius: 7.w),
                                      )
                                    ]),
                              ))
                        ]));
                  });
            },
            icon:  Icon(Icons.question_mark)),
        Spacer()
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: About(),
        key: _scaffoldKey,
        appBar: AppBar(
            automaticallyImplyLeading: false,
            title:Row(
              mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(backgroundImage: AssetImage("assets/images/logo.png"), radius: 5.w),
                  SizedBox(width: 2.w),
                  Text('Paper Trades', style: TextStyle(fontSize: 20.sp, color: Colors.white, fontWeight: FontWeight.bold))
                ])),//AppBar(title: Text(widget.title!),),
        body: Container(
            child:
                  SlidingUpPanel(
                    maxHeight: 90.h ,
                    minHeight: 10.h,
                    parallaxEnabled: true,
                    parallaxOffset: .5,
                    body: SwipeCardItem(),//(getStocks: ),
                    panelBuilder: (sc) => SeeMore(sc: sc),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(18.0),
                        topRight: Radius.circular(18.0)),
                    onPanelOpened: () => BlocProvider.of<CardsBloc>(context).add(GetMoreInfo())
                      // await updatePanel(_matchEngine?.currentItem);
                      // _fabHeight = pos * (_panelHeightOpen - _panelHeightClosed) + _fabHeight;
                  ),
        ));
  }
}