// import 'package:flutter/material.dart';
// import 'package:sizer/sizer.dart';
// import 'package:varsity_app/views/watchlist_user.dart';
//
// class WatchlistScreen extends StatefulWidget {
//   WatchlistScreen({Key? key}) : super(key: key);
//
//   @override
//   State<WatchlistScreen> createState() => _WatchlistScreenState();
// }
//
// class _WatchlistScreenState extends State<WatchlistScreen> with SingleTickerProviderStateMixin {
//   // late TabController _tabController;
//
//   @override
//   void initState() {
//     // _tabController =TabController(length: 2, vsync: this);
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title:Row(children: [
//             Image.asset('assets/images/logo.png', height: 12.h, fit: BoxFit.fitHeight),
//             SizedBox(width: 10,),
//             Text('Watchlist', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 24.sp)),
//           ]),
//           automaticallyImplyLeading: false,
//           // bottom:
//         //   TabBar(
//         //   controller: _tabController,
//         //   unselectedLabelColor: Colors.grey,
//         //   labelColor: Theme.of(context).primaryColor,
//         //   indicatorColor: Theme.of(context).primaryColor,
//         //   tabs: [
//         //     Tab(child: FittedBox(fit: BoxFit.scaleDown, child:Text('Added', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.greenAccent)))),
//         //     Tab(child: FittedBox(fit: BoxFit.scaleDown, child:Text('Others', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.greenAccent))))
//         //   ],
//         ),
//         //
//         body:
//         //     child:
//           // TabBarView(
//         //   controller:_tabController,
//         //   children: [
//         //     WatchlistUserScreen(),
//             WatchlistUserScreen()
//             // const ClaimsOrders()
//           // ], // OnGoingOrders(), ClaimsOrders()],
//         // ),
//     );
//   }
// }