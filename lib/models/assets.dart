import 'dart:convert';

class Asset {
  final String name;
  final String symbol;
  final num boughtPrice;
  final int quantity;

  Asset({
    required this.name,
    required this.symbol,
    required this.boughtPrice,
    required this.quantity,
  });

  static List<Asset> decode(List<dynamic> stuff) => stuff.map<Asset>((item) => Asset.fromJson(item)).toList();

  static List<Asset> decodeTopThree(List<dynamic> stuff) => stuff.map<Asset>((item) => Asset.fromTopThreeJson(item)).toList();

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

  static fromTopThreeJson(Map<String, dynamic> json) {
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
