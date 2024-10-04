import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sizer/sizer.dart';

import '../../bloc/cards_bloc/card_bloc.dart';
import '../../models/stocks.dart';

class SeeMore extends StatefulWidget {
  // final SwipeItem? swipeItem;
  final ScrollController sc;

  SeeMore({Key? key, required this.sc}) : super(key: key);

  @override
  _SeeMoreState createState() => _SeeMoreState();
}

class _SeeMoreState extends State<SeeMore> {

  Widget info(String title, String desc){
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
            SizedBox(height: 1.h),
            Text(desc, softWrap: true, style: TextStyle(color: Colors.black),),
          ],
        ));
  }

  dynamic formatImagePath(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) {
      return Image.network('https://cpworldgroup.com/wp-content/uploads/2021/01/placeholder.png', width: 30.w, fit: BoxFit.cover);
    } else if (imagePath.contains('png')) {
      return Image.network(imagePath, width: 30.w, fit: BoxFit.cover);
    } else if (imagePath.contains('svg')){
      return SvgPicture.network(imagePath, width: 30.w, fit: BoxFit.cover);
  }
  }

  Widget stockDetails(Stocks stocks){
    List<Widget> widgets = [];
    widgets.add(Row(mainAxisAlignment: MainAxisAlignment.center,
      children: [
        formatImagePath(stocks.details!.imagePath)
      ]
        // SvgPicture.network(stocks.details!.imagePath, width: 30.w, fit: BoxFit.cover)],
    ));
    widgets.add(Center(child:Container(padding: EdgeInsets.all(5), child:Text("${stocks.name}", style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: Colors.blueGrey)))));
    widgets.add(info("Industry", stocks.details!.industry));
    if (stocks.details!.currency != '') widgets.add(info("Currency", stocks.details!.currency!));
    if (stocks.details!.website != '') widgets.add(info("Website", stocks.details!.website));
    widgets.add(info("Market Capitalisation", "\$${stocks.details!.marketCapitalisation.toStringAsFixed(2)}"));
    if (stocks.details!.shareOutstanding != 0) widgets.add(info("Share Outstanding", "\$${stocks.details!.shareOutstanding.toStringAsFixed(2)}"));

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: widgets);
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ListView(
          controller: widget.sc,
          children: [
            SizedBox(height: 1.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(width: 30, height: 5, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.all(Radius.circular(12.0))),),
              ],
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 3.h),
              alignment: Alignment.center,
              child: Text("Read more of security", style: TextStyle(fontSize: 20.sp, color: Colors.black)),
            ),
            BlocBuilder<CardsBloc, CardsState>(builder: (context, state){
              if (state.currentStock!= null && state.status.isSuccess && state.currentStock!.details != null)
                return stockDetails(state.currentStock!);
              else if (state.status.isLoading)
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.all(20.sp),
                      height: 100,
                      width: 100,
                      child: CircularProgressIndicator(),
                    ),
                    Text('Retrieving data...please wait!')
                  ]);
              else return Center(
                    child:Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: Text('We could not fetch market information for this security, please try again later!', style: TextStyle(color: Colors.black),softWrap: true, textAlign: TextAlign.center))
                );
            }),
          ],
        ));
  }

}
