import 'dart:convert';

class Asset {
  final String name;
  final String symbol;
  final num boughtPrice;
  final int quantity;
  final num profit;

  Asset({
    this.name ='',
    this.symbol = '',
    this.boughtPrice = 0,
    this.quantity = 0,
    this.profit = 0
  });

  static List<Asset> decode(List<dynamic> stuff) => stuff.map<Asset>((item) => Asset.fromJson(item)).toList();

  static List<Asset> decodePL(List<dynamic> stuff) => stuff.map<Asset>((item) => Asset.fromPLJson(item)).toList();

  static List<Asset> decodeTopTen(List<dynamic> stuff) => stuff.map<Asset>((item) => Asset.fromTopTenJson(item)).toList();

  static String encode(List<Asset> stuff) =>
      json.encode(stuff.map<Map<String, dynamic>>((stuff) => Asset.toJson(stuff)).toList());

  static fromJson(Map<String, dynamic> json) {
    return Asset(
      name: json['asset_name'],
      symbol: json['symbol'],
      boughtPrice: json['bought_price'],
      quantity: json['quantity'],
    );
  }

  static fromPLJson(Map<String, dynamic> json) {
    return Asset(
      name: json['asset_name'],
      profit:json ['profit_loss'],
      symbol: '',
      boughtPrice: 0 ,
      quantity: 0,
    );
  }

  static fromTopTenJson(Map<String, dynamic> json) {
    return Asset(
      name: json['asset_name'],
      symbol: json['symbol'],
      quantity: json['total_quantity'],
      boughtPrice: 0
    );
  }

  static Map<String, dynamic> toJson(Asset item) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['asset_name'] = item.name;
    data['symbol'] = item.symbol;
    data['bought_price'] = item.boughtPrice;
    data['quantity'] = item.quantity;
    return data;
  }
}
