// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:sizer/sizer.dart';
// import 'package:varsity_app/bloc/watchlist_bloc/portfolio_bloc.dart';
//
// import '../models/stocks.dart';
//
// class WatchlistUserScreen extends StatefulWidget {
//   WatchlistUserScreen({Key? key}) : super(key: key);
//
//   @override
//   State<WatchlistUserScreen> createState() => _WatchlistScreenState();
// }
//
// class _WatchlistScreenState extends State<WatchlistUserScreen> {
//
//   @override
//   void initState(){
//     super.initState();
//     BlocProvider.of<WatchListBloc>(context)..add(GetAllItemsItems());
//   }
//
//
//   List<Widget> renderWatchlist(List<Stocks> stocks){
//     List<Widget> widgets = [];
//     for (var stock in stocks){
//     widgets.add(
//         Dismissible(
//           key: Key(stock.symbol),
//           onDismissed: (direction) {
//             setState(() {
//               stocks.remove(stock);
//               BlocProvider.of<WatchListBloc>(context)..add(RemoveWatchList(stock));
//             });
//             // Then show a snackbar.
//             ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${stock.name} removed from watchlist')));
//           },
//           // Show a red background as the item is swiped away.
//           background: Container(color: Colors.red, child: Icon(Icons.restore_from_trash),),
//           child:
//           InkWell(
//             onTap: ()=> buyDialog(stock),
//             child:
//           Container(
//               margin: EdgeInsets.symmetric(vertical: 0.6.h, horizontal: 5.w),
//               padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.w),
//               decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)), color: Colors.white),
//               child: Row(
//                   children: [
//                     Container(
//                         width: 60.w,
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(stock.name ?? stock.symbol, style: TextStyle(color: Colors.black),maxLines: 1),
//                             Text('Market price: \$${stock.info?.openPrice}',style: TextStyle(color:Colors.blueGrey),)// style: TextStyle(color: Colors.grey)
//                           ],
//                         )),
//                     Container(
//                       width: 20.w,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.end,
//                         children: [
//                           Text('\$${stock.info!.change}',style: TextStyle(color: stock.info!.change.contains('-') ? Colors.red : Colors.green)),// style: TextStyle(color: Colors.grey)
//                           Text('${stock.info!.changePercent}%' ,style: TextStyle(color: stock.info!.changePercent.contains('-') ? Colors.red : Colors.green))// style: TextStyle(color: Colors.grey)
//                         ],
//                       ),
//                     )
//
//                   ]
//               )),
//         )
//         // Divider(color: Colors.grey,)
//     ));
//     }
//
//     return widgets;
//   }
//
//   Widget build(BuildContext context) {
//     return BlocBuilder<WatchListBloc, WatchListState>(builder: (context, state){
//       if (state.watchlist.isNotEmpty){
//         // return SliverToBoxAdapter(child: ListView(children: renderWatchlist(state.watchlist)));
//           return CustomScrollView(
//             slivers: [
//               SliverList(
//                 delegate: SliverChildBuilderDelegate(
//                       (context, index) => renderWatchlist(state.watchlist)[index],
//                   childCount: renderWatchlist(state.watchlist).length,
//                 ),
//               ),
//             ],
//           );
//             // SliverToBoxAdapter(child: ListView(children: renderWatchlist(state.watchlist)));
//       } else
//       return Center(
//           child:Container(
//             padding: EdgeInsets.symmetric(horizontal: 10.w),
//           child: Text('You have not added any securities to your watchlist yet, start swiping now!', softWrap: true, textAlign: TextAlign.center,))
//       );
//       // if ()
//     });
//   }
// }