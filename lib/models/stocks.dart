// import 'package:equatable/equatable.dart';

import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';

class Stocks {
  final String symbol;
  final String? name;
  final String exchange;
  final String assetType;
  // final DateTime ipoDate;
  final Color? color;
  Profile? details;
  MarketInfo? info;
  // final DateTime? delisting;
  // bool swiped;

  Stocks({
    required this.symbol,
    this.name,
    required this.exchange,
    required this.assetType,
    // required this.ipoDate,
    // this.delisting,
    // required this.swiped,
    required this.color,
    this.details,
    this.info
  });

  static List<Stocks> decode(String stuff) =>
      (json.decode(stuff) as List<dynamic>).map<Stocks>((item) => Stocks.fromJson(item)).toList();

  static String encode(List<Stocks> stuff) =>
      json.encode(stuff.map<Map<String, dynamic>>((stuff) => Stocks.toJson(stuff)).toList());

  static fromJson(Map<String, dynamic> json) {
    return Stocks(
        symbol: json['symbol'],
        name: json['name'],
        exchange: json['exchange'],
        assetType: json['assetType'],
        // ipoDate: DateTime.parse(json['ipoDate']) ,
        // swiped: json['swiped'] == 0? false: true,
        color: json['assetType'] == 'Stock' ? Colors.red[50] : Colors.blue[50],
        details: json['profile'] != null ? Profile.fromJson(json['profile']) : null,
        info: json['market'] != null ? MarketInfo.fromJson(json['market']) : null
    );
  }

  static Map<String, dynamic> toJson(Stocks item) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['symbol'] = item.symbol;
    data['name'] = item.name;
    data['exchange'] = item.exchange;
    data['assetType'] = item.assetType;
    // data['ipoDate'] = item.ipoDate;
    data['assetType'] = item.assetType == Colors.red[50] ? 'Stock' : 'ETF';
    data['profile'] = item.details;
    data['market'] = item.info;
    return data;
  }

  setCompanyDetails (Profile? profile) => details = profile;
  setMarketInfo (MarketInfo market) => info = market;

}


class Profile {
  final String country;
  final String? currency;
  final String industry;
  final String imagePath;
  final num marketCapitalisation;
  final num shareOutstanding;
  final String website;

  Profile({
    this.country = '',
    this.currency = '',
    this.industry = '',
    this.imagePath = '',
    this.marketCapitalisation = 0,
    this.shareOutstanding = 0,
    this.website ='www.example.com',
  });

  static fromJson(Map<dynamic, dynamic> json) {
    return Profile(
        country: json['country'].toString(),
        currency: json['currency'].toString(),
        industry: json['finnhubIndustry'].toString(),
        imagePath: json['logo'].toString() ,
        marketCapitalisation: json ['marketCapitalization'] ?? 0,
        shareOutstanding: json ['shareOutstanding'] ?? 0,
        website: json['weburl'] ?? ''
    );
  }

  Map<String, dynamic> toJson() => {
    "country": country,
    "currency": currency,
    "finnhubIndustry": industry,
    "logo": imagePath,
    "marketCapitalization": marketCapitalisation,
    "shareOutstanding" : shareOutstanding,
    "weburl" : website
  };
}

class MarketInfo {
  final String openPrice;
  final String change;
  final String changePercent;
  // final num lastPrice;

  MarketInfo({
    this.openPrice = '',
    this.change = '',
    this.changePercent = '%'
    // this.lastPrice = 0
  });

  // static fromJson(Map<String, dynamic> json) => MarketInfo(
  //   openPrice: json["05. price"],
  //   change: json["09. change"],
  //   changePercent: json["10. change percent"],
  // );
  static fromJson(Map<dynamic, dynamic> json) => MarketInfo(
    openPrice: json["c"].toString(),
    change: json["d"].toString(),
    changePercent: json["dp"].toString(),
  );

  Map<String, dynamic> toJson() => {
    "c": openPrice,
    "d": change,
    "dp": changePercent,
  };
}

