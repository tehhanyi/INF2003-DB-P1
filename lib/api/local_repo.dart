import '../models/assets.dart';
import '../models/stocks.dart';
import 'local_service.dart';

class LocalRepository {
  const LocalRepository({
    required this.service,
  });
  final LocalService service;

  Future<List<Stocks>> getAllStocks() async => service.getAllStocks();

  Future<Profile?> getCompanyProfile(String symbol) async => service.getCompanyProfile(symbol);

  Future<MarketInfo?> getMarketInfo(String symbol) async => service.getMarketInfo(symbol);

  Future<String> getName() => service.getName();

  Future<String?> updateName(String name) => service.updateName(name);

  Future<bool> deleteUser() => service.deleteUser();

  Future<List<Asset>> getAllTransaction() => service.getAllTransaction();

// Future<bool> addWatchlist(Stocks stock) => service.addWatchlist(stock);
  //
  // Future<bool> updateWatchlist(List<Stocks> stock) => service.updateWatchlist(stock);
  //
  // Future<List<Stocks>> getAllWatchlist() async => service.getAllWatchlist();

}
