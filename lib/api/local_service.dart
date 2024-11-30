import 'dart:convert';
import 'dart:core';

import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:varsity_app/api/secret.dart';
import 'package:varsity_app/constant.dart';
import 'package:varsity_app/models/assets.dart';

import '../models/stocks.dart';
import 'api_FH.dart';
import 'api_NodeJS.dart';
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
    print ('current existing userId $userId');
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
    List<Asset> list = [];
    try{
      print('$nodeJSUrl/api/getUserPortfolio?userId=$userId');
      var response = await ApiNode().dio.get('/api/getUserPortfolio?userId=$userId'); //18
      if (response != '') {
        Map responseBody = response.data;
        print('get all transaction from user_id $userId: $response');
        list = Asset.decode(responseBody['portfolio']);
      }
    }catch(e){
      print('error $e');
    }
    return list;
  }

  Future<bool> createTransaction(Asset asset) async{
    var sharedPreferences = await SharedPreferences.getInstance();
    String? userId = sharedPreferences.getString('user_id');
    var data = jsonEncode({
      'userId': userId,
      "assetName": asset.name,
      "symbol": asset.symbol,
      "boughtPrice": asset.boughtPrice,
      "quantity": asset.quantity
    });
    try{
      print('$nodeJSUrl/api/addTransactionWithAsset\n$data');

      var response = await ApiNode().dio.post('/api/addTransactionWithAsset', data: data);
      if (response != '') {
        print('${response.data['message']}');
      }} catch(e){
        print('error $e');
        return false;
      }
    return true;
  }

  Future<num> getProfitLoss(List<Asset> assets) async{

    var sharedPreferences = await SharedPreferences.getInstance();
    String? userId = sharedPreferences.getString('user_id');

    try{
      print('GET $nodeJSUrl/api/getUserProfitLoss?userId=$userId');
      var response = await ApiNode().dio.get('/api/getUserProfitLoss?userId=$userId'); //18
      if (response != '') {
        Map responseBody = response.data;
        return (responseBody['Profit'] * 100).truncateToDouble() / 100;
      }
    }catch(e){
      print('error $e');
    }
    return 0;
  }

  Future<List<Asset>> getTopTen() async{
    var response = await ApiNode().dio.get('/api/top10assets');
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
}
