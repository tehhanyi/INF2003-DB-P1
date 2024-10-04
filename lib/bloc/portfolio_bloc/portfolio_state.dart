part of 'portfolio_bloc.dart';

enum PortfolioStatus { initial, success, error, loading, cardLoading, cardLoaded }

extension WatchListStatusX on PortfolioStatus {
  bool get isInitial => this == PortfolioStatus.initial;
  bool get isSuccess => this == PortfolioStatus.success;
  bool get isError => this == PortfolioStatus.error;
  bool get isLoading => this == PortfolioStatus.loading;
  // bool get isDetailsLoading => this == WatchListStatus.cardLoading;
  // bool get isDetailsLoaded => this == WatchListStatus.cardLoaded;

// bool get isDataChange => this == FoodCartStatus.dataChange;
  // bool get isMerchantChange => this == FoodCartStatus.merchantChange;
}

class PortfolioState extends Equatable {
  final List<Asset> transactions;
  // final List<Stocks> others;
  final String name;
  final PortfolioStatus status;

  // final FoodCartItem? pendingFoodCartItem;
  // final num? deductedBalance;
  // final num totalDeductedPoints;

  PortfolioState({
    this.status = PortfolioStatus.initial,
    this.name = 'unknown',
    List<Asset>? transactions,
    // List<Stocks>? others,
    // this.pendingFoodCartItem,
    // this.deductedBalance,
    // this.totalDeductedPoints = 0,
  }):transactions = transactions ?? [];//, others = others ?? [];

  @override
  List<Object?> get props => [status, transactions];

  PortfolioState copyWith({
    PortfolioStatus? status,
    String? name,
    List<Asset>? transactions,
    // List<Stocks>? others,
  }) {
    return PortfolioState(
      status: status ?? this.status,
      name: name ?? this.name,
      transactions: transactions ?? this.transactions,
        // others: others ?? this.others,
        // matchEngine: matchEngine ?? this.matchEngine
        // pendingFoodCartItem: pendingFoodCartItem ?? this.pendingFoodCartItem,
        // // deductedBalance: deductedBalance ?? this.deductedBalance,
        // totalDeductedPoints: totalDeductedPoints ?? this.totalDeductedPoints
    );
  }
}
