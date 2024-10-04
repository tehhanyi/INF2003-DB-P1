part of 'card_bloc.dart';

enum CardStatus { initial, success, error, loading, cardLoading, cardLoaded }

extension CardStatusX on CardStatus {
  bool get isInitial => this == CardStatus.initial;
  bool get isSuccess => this == CardStatus.success;
  bool get isError => this == CardStatus.error;
  bool get isLoading => this == CardStatus.loading;
  bool get isCardLoading => this == CardStatus.cardLoading;
  bool get isCardLoaded => this == CardStatus.cardLoaded;

// bool get isDataChange => this == FoodCartStatus.dataChange;
  // bool get isMerchantChange => this == FoodCartStatus.merchantChange;
}

class CardsState extends Equatable {
  final List<Stocks> items;
  final Stocks? currentStock;
  final MatchEngine? matchEngine;

  // final FoodCartItem? pendingFoodCartItem;
  final CardStatus status;
  // final num? deductedBalance;
  // final num totalDeductedPoints;

  CardsState({
    this.status = CardStatus.initial,
    List<Stocks>? items,
    this.currentStock,
    this.matchEngine
    // this.pendingFoodCartItem,
    // this.deductedBalance,
    // this.totalDeductedPoints = 0,
  }) : items = items ?? [];

  @override
  List<Object?> get props => [status, items, items];

  CardsState copyWith({
    List<Stocks>? items,
    CardStatus? status,
    Stocks? currentStock,
    MatchEngine? matchEngine
    // FoodCartItem? pendingFoodCartItem,
    //   // num? deductedBalance,
    // num? totalDeductedPoints
  }) {
    return CardsState(
        status: status ?? this.status,
        items: items ?? this.items,
        currentStock: currentStock ?? this.currentStock,
        matchEngine: matchEngine ?? this.matchEngine
        // pendingFoodCartItem: pendingFoodCartItem ?? this.pendingFoodCartItem,
        // // deductedBalance: deductedBalance ?? this.deductedBalance,
        // totalDeductedPoints: totalDeductedPoints ?? this.totalDeductedPoints
    );
  }
}
