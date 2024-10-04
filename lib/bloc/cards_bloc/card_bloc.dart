import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:swipe_cards/swipe_cards.dart';

import '../../api/local_repo.dart';
import '../../models/stocks.dart';

part 'card_event.dart';
part 'card_state.dart';

class CardsBloc extends Bloc<CardEvent, CardsState> {
  final LocalRepository repository;

  CardsBloc({
    required this.repository,
  }) : super(CardsState()) {
    on<GetAllCardsItems>(_mapGetAllCardsItemsEventToState);
    on<UpdateCurrentStock>(_mapUpdateStockEventToState);
    on<UpdateEngine>(_mapUpdateEngineEventToState);
    on<GetMoreInfo>(_mapGetMoreInfoEventToState);
  }

  void _mapGetAllCardsItemsEventToState(GetAllCardsItems event, Emitter<CardsState> emit) async {
    try {
      final stocks = await repository.getAllStocks();

      emit(state.copyWith(status:CardStatus.cardLoaded, items: stocks, currentStock: stocks[0]));
    } catch (error) {
      emit(state.copyWith(status: CardStatus.error));
    }
  }

  void _mapUpdateStockEventToState(UpdateCurrentStock event, Emitter<CardsState> emit) async {
    emit(state.copyWith(currentStock: event.currentItem));
  }

  void _mapUpdateEngineEventToState(UpdateEngine event, Emitter<CardsState> emit) async {
    emit(state.copyWith(matchEngine: event.engine, currentStock: event.engine.currentItem!.content));
  }

  void _mapGetMoreInfoEventToState(GetMoreInfo event, Emitter<CardsState> emit) async {
    try {
      emit(state.copyWith(status: CardStatus.loading));
      Stocks currentStock = state.currentStock!; //event.stock;
      final profile = await repository.getCompanyProfile(currentStock.symbol);//state.matchEngine!.currentItem!.content.symbol);
      // Stocks currentStock = state.matchEngine!.currentItem!.content;
      currentStock.setCompanyDetails(profile);

      emit(state.copyWith(status: CardStatus.success, currentStock: currentStock));
    } catch (error) {
      print(error);
      emit(state.copyWith(status: CardStatus.error));
    }
  }




// void _mapUpdateCardEventToState(AddFoodCartItem event, Emitter<FoodCartState> emit) async {
  //   try {
  //     emit(state.copyWith(status: FoodCartStatus.dataChange));
  //
  //     // Check if new item is from the same merchant as the other items.
  //     bool isSameMerchant = true;
  //     for (var foodCartItem in state.foodCartItems) {
  //       if (foodCartItem.product.merchantId != event.foodCartItem.product.merchantId) {
  //         isSameMerchant = false;
  //       }
  //     }
  //
  //     if (isSameMerchant) {
  //       if (state.foodCartItems.contains(event.foodCartItem)) {
  //         for (var foodCartItem in state.foodCartItems) {
  //           if (foodCartItem == event.foodCartItem) {
  //             foodCartItem.quantity = foodCartItem.quantity + event.foodCartItem.quantity;
  //           }
  //         }
  //       } else {
  //         state.foodCartItems.add(event.foodCartItem);
  //       }
  //
  //       await repository.replaceFoodCartItems(state.foodCartItems);
  //       emit(state.copyWith(status: FoodCartStatus.success, foodCartItems: state.foodCartItems));
  //     } else {
  //       emit(state.copyWith(status: FoodCartStatus.merchantChange, pendingFoodCartItem: event.foodCartItem));
  //       emit(state.copyWith(status: FoodCartStatus.success));
  //     }
  //   } catch (error) {
  //     print(error);
  //     emit(state.copyWith(status: FoodCartStatus.error));
  //   }
  // }

  // void _mapRemoveFoodCartItemEventToState(RemoveFoodCartItem event, Emitter<FoodCartState> emit) async {
  //   try {
  //     emit(state.copyWith(status: FoodCartStatus.dataChange));
  //
  //     state.foodCartItems.remove(event.foodCartItem);
  //     await repository.replaceFoodCartItems(state.foodCartItems);
  //
  //     emit(state.copyWith(status: FoodCartStatus.success, foodCartItems: state.foodCartItems));
  //   } catch (error) {
  //     emit(state.copyWith(status: FoodCartStatus.error));
  //   }
  // }
  //
  // void _mapClearFoodCartEventToState(ClearFoodCart event, Emitter<FoodCartState> emit) async {
  //   try {
  //     emit(state.copyWith(status: FoodCartStatus.dataChange));
  //
  //     state.foodCartItems.clear();
  //     await repository.replaceFoodCartItems(state.foodCartItems);
  //
  //     emit(state.copyWith(status: FoodCartStatus.success, foodCartItems: state.foodCartItems, totalDeductedPoints: 0));
  //   } catch (error) {
  //     emit(state.copyWith(status: FoodCartStatus.error));
  //   }
  // }
  //
  // void _mapChangeMerchantWithPendingItemEventToState(ChangeMerchantWithPendingItem event, Emitter<FoodCartState> emit) async {
  //   try {
  //     if (state.pendingFoodCartItem != null) {
  //       // Clear food cart and place only new pending food cart item.
  //       emit(state.copyWith(status: FoodCartStatus.dataChange));
  //       state.foodCartItems.clear();
  //       state.foodCartItems.add(state.pendingFoodCartItem!);
  //       await repository.replaceFoodCartItems(state.foodCartItems);
  //       emit(state.copyWith(status: FoodCartStatus.success, foodCartItems: state.foodCartItems, pendingFoodCartItem: null));
  //     }
  //   } catch (error) {
  //     emit(state.copyWith(status: FoodCartStatus.error));
  //   }
  // }
  //
  // void _mapUpdateFoodCartItemEventToState(UpdateFoodCartItem event, Emitter<FoodCartState> emit) async {
  //   try {
  //     print('UpdateFoodCartItem');
  //     emit(state.copyWith(status: FoodCartStatus.dataChange));
  //     var initialOrderIndex = state.foodCartItems.indexOf(event.foodCartItem);
  //
  //     state.foodCartItems[initialOrderIndex] = event.newFoodCartItem;
  //     print(initialOrderIndex);
  //     await repository.replaceFoodCartItems(state.foodCartItems);
  //     emit(state.copyWith(status: FoodCartStatus.success, foodCartItems: state.foodCartItems));
  //   } catch (error) {
  //     emit(state.copyWith(status: FoodCartStatus.error));
  //   }
  // }
  //
  // void _mapUpdateRedeemEventToState(RedeemFoodCartItem event, Emitter<FoodCartState> emit) async {
  //   try {
  //     emit(state.copyWith(status: FoodCartStatus.dataChange));
  //     // num deductedBal = 0;
  //     num overAllDeductedPoints = state.totalDeductedPoints;
  //     for (var foodCartItem in state.foodCartItems) {
  //       if (foodCartItem == event.foodCartItem) {
  //         foodCartItem.redeemPoints();
  //
  //         //ASSIGN POINTS FOR MAIN PRODUCT
  //         foodCartItem.assignPoints(event.loyaltyPointsArray);
  //
  //         //ASSIGN POINTS FOR ADDONS
  //         for (int i = 0; i < foodCartItem.product.addOns.length; i++) {
  //           if (foodCartItem.product.addOns[i].quantity > 0) {
  //             foodCartItem.product.addOns[i].assignPoints(event.loyaltyPointsArray[i + 1]);
  //           }
  //         }
  //
  //         overAllDeductedPoints += event.foodCartItemPoints;
  //         // deductedBal = event.totalLoyaltyBalance - overAllDeductedPoints;
  //       }
  //     }
  //     await repository.replaceFoodCartItems(state.foodCartItems);
  //     emit(state.copyWith(
  //         status: FoodCartStatus.success,
  //         foodCartItems: state.foodCartItems,
  //         // deductedBalance: deductedBal,
  //         totalDeductedPoints: overAllDeductedPoints));
  //   } catch (error) {
  //     emit(state.copyWith(status: FoodCartStatus.error));
  //   }
  // }
  //
  // void _mapUpdateUnredeemEventToState(UnredeemFoodCartItem event, Emitter<FoodCartState> emit) async {
  //   try {
  //     emit(state.copyWith(status: FoodCartStatus.dataChange));
  //     // num deductedBal = event.totalLoyaltyBalance;
  //     num overAllDeductedPoints = state.totalDeductedPoints;
  //     for (var foodCartItem in state.foodCartItems) {
  //       if (foodCartItem == event.foodCartItem || event.foodCartItem == null) {
  //         if (foodCartItem.redeemed == true) {
  //           print('1overAllDeductedPoints $overAllDeductedPoints');
  //           overAllDeductedPoints -= foodCartItem.points!;
  //           print('2overAllDeductedPoints $overAllDeductedPoints');
  //
  //           // deductedBal += foodCartItem.points!;
  //           foodCartItem.unredeemPoints();
  //           // overAllDeductedPoints -= event.foodCartItemPoints;
  //           // deductedBal = event.totalLoyaltyBalance + event.foodCartItemPoints;
  //         }
  //       }
  //     }
  //     await repository.replaceFoodCartItems(state.foodCartItems);
  //     emit(state.copyWith(
  //       status: FoodCartStatus.success,
  //       foodCartItems: state.foodCartItems,
  //       // deductedBalance: deductedBal,
  //       totalDeductedPoints: overAllDeductedPoints,
  //     ));
  //   } catch (error) {
  //     emit(state.copyWith(status: FoodCartStatus.error));
  //   }
  // }

  // void _mapGetTotalFoodCartPointsEventToState(GetTotalFoodCartPoints event, Emitter<FoodCartState> emit) async {
  //   try {
  //
  //     //CALCULATING TOTAL LOYALTY POINTS IN A FOODCARTITEM ARRAY
  //     for (var amt in event.convertedLoyaltyPointsArray) {
  //       totalFoodCartItemPoints += amt.round();
  //     }
  //
  //     emit(state.copyWith(
  //       status: FoodCartStatus.success,
  //         totalFoodCartItemPoints: totalFoodCartItemPoints
  //
  //     ));
  //
  //   } catch (error) {
  //     print(error);
  //     emit(state.copyWith(status: FoodCartStatus.error));
  //   }
  // }
}


