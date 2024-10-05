import 'dart:convert';
import 'dart:core';

import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:varsity_app/api/secret.dart';
import 'package:varsity_app/models/assets.dart';

import '../models/stocks.dart';
import 'api_FH.dart';
import 'api_SB.dart';

class LocalService {
  LocalService();

  Future<List<Stocks>> getAllStocks() async {
    final String response =  await rootBundle.loadString('assets/data/listed_stocks.json');
    var list = List<Stocks>.from(json.decode(response).map((data) => Stocks.fromJson(data)));
    // var c = a.where((m) => b.contains(m['id'])).map((m) => m['name']);
    list.shuffle();
    return list. sublist(0,50);
    // sharedPreferences.setString('watchlist', response.toString());
  }

  Future<Profile?> getCompanyProfile(String symbol) async {
    print("https://finnhub.io/api/v1/stock/profile2?symbol=$symbol&token=$FHApiKey");
    var response = await ApiFH().dio.get('/stock/profile2?symbol=$symbol&token=$FHApiKey');
    Map responseBody = response.data;
    print('getCompanyProfile\n$response');
    if(responseBody.isEmpty) return null;

    return Profile.fromJson(responseBody);
  }

  Future<MarketInfo?> getMarketInfo(String symbol) async {
    print("https://finnhub.io/api/v1/quote?symbol=$symbol&token=$FHApiKey");
    var response = await ApiFH().dio.get('/quote?symbol=$symbol&token=$FHApiKey');
    Map responseBody = response.data;
    print('getMarketInfo\n$response');
    // print('function=GLOBAL_QUOTE&symbol=$symbol&apikey=$vantageApiKey');
    // var url = Uri.parse("https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=$symbol&apikey=406CCPGVE4VPOVG7");
    // var response = await http.get(url,);// headers: {"apikey" : "$vantageApiKey"});
    // Map responseBody = json.decode(response.body);
    // if (responseBody['Information'] != null){
    //   print(responseBody['Information']);
    //   return null;
    // }
    // print('getMarketInfo ${response.body}');
    return MarketInfo.fromJson(responseBody); //['Global Quote']
  }

  Future<String?> getExistingUser() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    String? userId = sharedPreferences.getString('user_id');
    print ('userId $userId');
    // if (userId != null){
    //   var response = await ApiSB().dio.get('/User', data: jsonEncode({'phone_number': phone}));
    //
    // }
    return userId;
  }

  Future<String?> createUser(String phone) async {
    var sharedPreferences = await SharedPreferences.getInstance();
    // var response = await ApiSB().dio.post('/User', data: jsonEncode({'phone_number': phone}));
    var response = await ApiSB().dio.post('/rpc/find_or_create_user', data: jsonEncode({'p_phone_number': phone}));
    print('findorcreateUser ${response.data}');
    String? userId = response.data[0]['user_id'].toString();
    String? name = response.data[0]['name'].toString();
    sharedPreferences.setString('user_id', userId);
    sharedPreferences.setString('name', name);
    return userId;
  }

  Future<String> getName() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString('name') ?? 'null';
  }

  Future<String?> updateName(String name) async {
    var sharedPreferences = await SharedPreferences.getInstance();
    String? userId = sharedPreferences.getString('user_id');
    var response = await ApiSB().dio.patch('/User?user_id=eq.$userId', data: jsonEncode({'name': name}));
    // var response = await ApiSB().dio.post('/rpc/update_username', data: jsonEncode({'p_user_id': userId, 'new_username': name}));
    if (response != ''){
      sharedPreferences.setString('name', name);
      return response.data[0]['name'];
    } else return null;
  }

  Future<bool> deleteUser() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    String? userId = sharedPreferences.getString('user_id');

    var response = await ApiSB().dio.delete('/User?user_id=eq.$userId');
    if (response != ''){
      print('user_id $userId successfully deleted');
      sharedPreferences.clear();
      return true;
    } else return false;
  }

  Future<List<Asset>> getAllTransaction() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    String? userId = sharedPreferences.getString('user_id');
    var response = await ApiSB().dio.get('/rpc/get_user_portfolio?user_id_param=$userId'); //18
    List<Asset> list = [];
    if (response != ''){
      print('getAllTransaction $response');
      try{
      // print(response.runtimeType);
      list = Asset.decode(response.data);
      }catch(e){
        print('error $e');
      }
    }
    return list;
  }

  Future<bool> createTransaction(Asset asset) async{
    var sharedPreferences = await SharedPreferences.getInstance();
    String? userId = sharedPreferences.getString('user_id');
    var data = jsonEncode({
      'user_id': userId,
      "asset_name": asset.name,
      "symbol": asset.symbol,
      "bought_price": asset.boughtPrice,
      "quantity": asset.quantity
    });
    try{
      var response = await ApiSB().dio.post('/rpc/add_transaction_with_asset', data: data);
      print('createTransaction $response');
      } catch(e){
        print('error $e');
      }
    return true;
  }

  Future<num> getProfitLoss(List<Asset> assets) async{
    List<String> assetSymbols = assets.map((asset) => asset.symbol).toList().toSet().toList();
    for (var symbol in assetSymbols){
      var realTimeStock = await getMarketInfo(symbol);
      if (realTimeStock != null)
        await ApiSB().dio.patch('/Asset?symbol=eq.${symbol}',
            data: jsonEncode({'current_price': realTimeStock.openPrice}));
      print('updated ${symbol}');
    }
    var sharedPreferences = await SharedPreferences.getInstance();
    String? userId = sharedPreferences.getString('user_id');
    var response = await ApiSB().dio.post('/rpc/get_user_profit_loss', data: jsonEncode({'p_user_id': userId}));
    List<Asset> list = [];
    if (response != ''){
      print('getProfitLoss $response');
      try{
        list = Asset.decodePL(response.data);
      }catch(e){
        print('error $e');
      }
    }
    num totalPL = 0;
    for (var asset in list){
      totalPL += asset.profit;
    }
    return (totalPL * 100).truncateToDouble() / 100;


  }

  Future<List<Asset>> getTopTen() async{
    var response = await ApiSB().dio.post('/rpc/get_top_10_assets_by_quantity');
    List<Asset> list = [];
    if (response != ''){
      try{
        list = Asset.decodeTopTen(response.data);
      }catch(e){
        print('error $e');
      }
    }
    return list;
  }

  Future<bool> addWatchlist(Stocks stock) async {
    var sharedPreferences = await SharedPreferences.getInstance();
    List<Stocks> list = await getAllWatchlist();
    list.add(stock);
    sharedPreferences.setString('watchlist', Stocks.encode(list));
    return true;
  }

  Future<bool> updateWatchlist(List<Stocks> stocks) async {
    var sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString('watchlist', Stocks.encode(stocks));
    return true;
  }

  Future<List<Stocks>> getAllWatchlist() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    final String? response =  sharedPreferences.getString('watchlist');
    List<Stocks> list = [];
    if (response != '' && response != null){
      list = Stocks.decode(response);
    }
    return list;
  }
}
