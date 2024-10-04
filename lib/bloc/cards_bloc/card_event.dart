part of 'card_bloc.dart';

abstract class CardEvent extends Equatable {
  const CardEvent();
}

class GetAllCardsItems extends CardEvent {
  @override
  List<Object?> get props => [];
}

class UpdateCurrentStock extends CardEvent {
  final Stocks currentItem;

  const UpdateCurrentStock(this.currentItem);

  @override
  List<Object?> get props => [];
}

class UpdateEngine extends CardEvent {
  final MatchEngine engine;

  const UpdateEngine(this.engine);

  @override
  List<Object?> get props => [];
}

class GetMoreInfo extends CardEvent {

  // final Stocks stock;

  const GetMoreInfo();

  @override
  List<Object?> get props => [];
}
//
// class RemoveFoodCartItem extends FoodCartEvent {
//   final FoodCartItem foodCartItem;
//
//   const RemoveFoodCartItem(this.foodCartItem);
//
//   @override
//   List<Object?> get props => [foodCartItem];
// }

// class ClearFoodCart extends FoodCartEvent {
//   @override
//   List<Object?> get props => [];
// }
//
// class ChangeMerchantWithPendingItem extends FoodCartEvent {
//   @override
//   List<Object?> get props => [];
// }
//
// class IncrementQuantityByOne extends FoodCartEvent {
//   final FoodCartItem foodCartItem;
//
//   const IncrementQuantityByOne(this.foodCartItem);
//
//   @override
//   List<Object?> get props => [foodCartItem];
// }
//
// class DecrementQuantityByOne extends FoodCartEvent {
//   final FoodCartItem foodCartItem;
//
//   const DecrementQuantityByOne(this.foodCartItem);
//
//   @override
//   List<Object?> get props => [foodCartItem];
// }

// class UpdateFoodCartItem extends CardEvent {
//   // final items foodCartItem;
//   final Stocks item;
//
//   const UpdateFoodCartItem(this.item);
//
//   @override
//   List<Object?> get props => [item];
// }
//
// class RedeemFoodCartItem extends CardEvent {
//   final FoodCartItem foodCartItem;
//   final num foodCartItemPoints;
//   // final num totalLoyaltyBalance;
//   final List<num> loyaltyPointsArray;
//
//   const RedeemFoodCartItem(this.foodCartItem, this.foodCartItemPoints, this.loyaltyPointsArray);
//
//   @override
//   List<Object?> get props => [foodCartItem];
// }
//
// class UnredeemFoodCartItem extends CardEvent {
//   final FoodCartItem? foodCartItem;
//   // final num foodCartItemPoints;
//   // final num totalLoyaltyBalance;
//
//   const UnredeemFoodCartItem(this.foodCartItem,);
//
//   @override
//   List<Object?> get props => [foodCartItem];
// }
