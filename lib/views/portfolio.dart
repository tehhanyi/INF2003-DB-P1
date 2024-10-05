import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:varsity_app/bloc/pl_bloc/pl_bloc.dart';
import 'package:varsity_app/bloc/portfolio_bloc/portfolio_bloc.dart';

import '../models/assets.dart';
import 'login.dart';

class UserAssetsScreen extends StatefulWidget {
  UserAssetsScreen({Key? key}) : super(key: key);

  @override
  State<UserAssetsScreen> createState() => _UserAssetsScreenState();
}

class _UserAssetsScreenState extends State<UserAssetsScreen> {

  @override
  void initState() {
    BlocProvider.of<PortfolioBloc>(context).add(GetName());// allStocks();
    BlocProvider.of<PortfolioBloc>(context).add(GetAllTransactions());
    // BlocProvider.of<PLBloc>(context).add(GetProfitLoss(PortfolioBloc));

    super.initState();
  }

  TextEditingController nameController = TextEditingController();

  num formatPrice(String price) => num.parse(price.replaceAll(new RegExp(r'[^0-9.]'),''));
  List<Widget> _renderTransactionItems(List<Asset> portfolio) {
    List<Widget> widgets = [];

    for (var asset in portfolio) {
      widgets.add(AssetItem(asset));
      widgets.add(const Divider(height: 1));
    }
    if (widgets.isNotEmpty) {
      widgets.removeLast();
    }
    widgets.add(Center(
        child: Padding(
            padding: const EdgeInsets.only(bottom: 0),
            child: const Text('You have reached the end!', style: TextStyle(fontWeight: FontWeight.bold)))));

    return widgets;
  }

  Widget AssetItem(Asset asset){
    // List<String> dates = [
    //   DateFormat('dd-MM').format(DateTime(2024, 3, 20)),
    //   DateFormat('dd-MM').format(DateTime(2024, 3, 21)),
    //   DateFormat('dd-MM').format(DateTime(2024, 3, 22)),
    //   DateFormat('dd-MM').format(DateTime.now())];
    return Container(
        margin: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 5.w),
        child:  Row(
            children: [
              Container(
                  width: 50.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(asset.name, style: TextStyle(),maxLines: 1),
                      Text('Bought at \$${asset.boughtPrice}',style: TextStyle(color:Colors.blueGrey),)// style: TextStyle(color: Colors.grey)
                    ],
                  )),
              Container(width: 20.w, child: Text(asset.quantity.toString())),
              Container(
                  width: 15.w,
                  child: Text('\$${asset.quantity * asset.boughtPrice}'.toString())),
              // Container(
              //     width: 37.w,
              //     height: 5.h,
              //     child:
              //     FittedBox(
              //       fit: BoxFit.fitHeight,
              //       child: SfSparkLineChart.custom(
              //         //Enable the trackball
              //         trackball: SparkChartTrackball(activationMode: SparkChartActivationMode.longPress),
              //         //Enable marker
              //         marker: SparkChartMarker(displayMode: SparkChartMarkerDisplayMode.last),
              //         //Enable data label
              //         labelDisplayMode: SparkChartLabelDisplayMode.last,
              //         xValueMapper: (int index) => dates[index],
              //         yValueMapper: (int index) => changes[index],
              //         dataCount: dates.length,
              //         color: (formatPrice(price) > changes[changes.length-2]) ?  Colors.greenAccent : Colors.redAccent,
              //       ),
              //     )
              //   // Text('\$${}',style: TextStyle(color: stock.info!.change.contains('-') ? Colors.red : Colors.green)),// style: TextStyle(color: Colors.grey)
              //   // ],
              //   // )
              // )
            ]
        ));
  }
  Widget User(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Column(
        children: [
          Image.asset('assets/images/user.png', height: 12.h, fit: BoxFit.fitHeight, color: Colors.white,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Hi, ', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20.sp)),
              BlocBuilder<PortfolioBloc, PortfolioState>(builder: (context, state){
                return Text('${state.name}!', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20.sp));
              }),
              // Text('$name!', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20.sp)),
              IconButton(onPressed: (){
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                          title: Text('Edit Name?'),
                          content: TextField(
                              controller: nameController,
                              maxLines: 1,
                              maxLength: 30,
                              decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.black54,
                                  hoverColor: Colors.white,
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
                                  hintText: 'Name')),//Text(''),
                          actions: [
                            TextButton(onPressed: () {
                              nameController.clear();
                              Navigator.of(context).pop();
                            }, child: Text('No', style: TextStyle(color: Colors.grey))),
                            TextButton(onPressed: (){
                              BlocProvider.of<PortfolioBloc>(context).add(UpdateName(nameController.text));
                              nameController.clear();
                              Navigator.of(context).pop();
                            }, child: Text('Yes'),)
                          ]);
                    });
              }, icon: Icon(Icons.edit))
            ],
          ),
        ],
      ),
    );
  }
  Widget PL(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text('Profit / Loss'),
        BlocBuilder<PLBloc, PLState>(builder: (context, state){
          if(state.status.isSuccess)
            return Text('${(state.price > 0) ? '+' : '-'}\$${state.price.toString().replaceAll(RegExp('-'), '')}',
              style: TextStyle(fontWeight: FontWeight.bold, color: (state.price > 0) ? Colors.green : Colors.red, fontSize: 24.sp));
          else return const Center(child: CircularProgressIndicator());

        })
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:Row(children: [
            Text('Portfolio', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 24.sp)),
            Spacer(),
            IconButton(onPressed: (){
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                        title: Text('Delete Account?'),
                        content: Text('Once delete, all data will be permanently deleted including your portfolio stats. Would you like to proceed?'),//Text(''),
                        actions: [
                          TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('No', style: TextStyle(color: Colors.grey))),
                          TextButton(onPressed: () async {
                            BlocProvider.of<PortfolioBloc>(context).add(DeleteUser());
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                            await Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                            }, child: Text('Yes', style: TextStyle(color: Colors.red),),)
                        ]);
                  });
            }, icon: Icon(Icons.delete, color: Colors.red[900],))
            // Image.asset('assets/images/logo.png', height: 12.h, fit: BoxFit.fitHeight),
          ]),
          automaticallyImplyLeading: false,
        ),
        //
        body: Column(
          children: [
            Row(children:[
              Expanded(flex: 5, child: User()),
              Flexible(flex: 4, child: PL())
            ]),
            Padding(
              padding: EdgeInsets.symmetric( horizontal: 5.w),
              child: Row(
                  children: [
                    Container(width: 45.w, child: Text('Assets',style: TextStyle(color:Colors.grey))),
                    Container(width: 23.w, child: Text('Quantity',style: TextStyle(color:Colors.grey))),
                    Text('Total Price', style: TextStyle(color:Colors.grey))
                  ]
              ),
            ),
            BlocBuilder<PortfolioBloc, PortfolioState>(builder: (context, state) {
              if (state.status.isSuccess || state.status.isTransactionLoaded) {
                return Container(
                  height: 60.h,
                  child: ListView(children: _renderTransactionItems(state.transactions)),
                );
              }
              else if(state.status.isLoading || state.status.isTransactionLoading){
                return const Center(child: CircularProgressIndicator());
              } else {
                // return RefreshIndicator(
                    // onRefresh: {{_pullRefresh,
                    // child:
                    return SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: SizedBox(
                            child: Text('There seem to be an error, please try again.',),
                            height: 60.h));
              }
            })
            // Asset('Apple Inc.', 3 , '\$172.28 USD', [172.28, 176.04, 171.03, 172.28]),
            // Asset('BlackRock Inc', 1 , '\$824.83 USD', [804.68, 834.79, 834.47,824.83]),
            // Asset('Nestle (Malaysia) Berhad', 1 , '117.90 MYR',[119.30, 117.90, 118.00, 117.90]),
          ],
    ));
  }
}