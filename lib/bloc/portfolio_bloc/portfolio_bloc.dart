import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../api/local_repo.dart';
import '../../models/assets.dart';
import '../../models/stocks.dart';

part 'portfolio_event.dart';
part 'portfolio_state.dart';

class PortfolioBloc extends Bloc<PortfolioEvent, PortfolioState> {
  final LocalRepository repository;

  PortfolioBloc({
    required this.repository,
  }) : super(PortfolioState()) {
    on<GetName>(_mapGetName);
    on<UpdateName>(_mapUpdateName);
    on<DeleteUser>(_mapDeleteUser);
    on<GetAllTransactions>(_mapGetAllTransactions);
    // on<AddWatchList>(_mapAddWatchListEventToState);
    // on<RemoveWatchList>(_mapRemoveWatchListEventToState);
    // on<GetMoreInfo>(_mapGetMoreInfoEventToState);
  }

  void _mapGetName(GetName event, Emitter<PortfolioState> emit) async {
    try {
      emit(state.copyWith(status: PortfolioStatus.loading));
      final name = await repository.getName();
      emit(state.copyWith(name: name,status: PortfolioStatus.success));
    } catch (error) {
      emit(state.copyWith(status: PortfolioStatus.error));
    }
  }

  void _mapUpdateName(UpdateName event, Emitter<PortfolioState> emit) async {
    try {
      emit(state.copyWith(status: PortfolioStatus.loading));
      final name = await repository.updateName(event.name);

      emit(state.copyWith(name: name, status: PortfolioStatus.success));
    } catch (error) {
      emit(state.copyWith(status: PortfolioStatus.error));
    }
  }

  void _mapDeleteUser(DeleteUser event, Emitter<PortfolioState> emit) async {
    try {
      await repository.deleteUser();
      emit(state.copyWith(status: PortfolioStatus.initial));
    } catch (error) {
      emit(state.copyWith(status: PortfolioStatus.error));
    }
  }

  void _mapGetAllTransactions(GetAllTransactions event, Emitter<PortfolioState> emit) async {
    try {
      emit(state.copyWith(status: PortfolioStatus.loading));
      final items = await repository.getAllTransaction();
      emit(state.copyWith(transactions: items, status: PortfolioStatus.success));
    } catch (error) {
      emit(state.copyWith(status: PortfolioStatus.error));
    }
  }

  void _mapAddWatchListEventToState(AddWatchList event, Emitter<PortfolioState> emit) async {
    try {
      // List<Stocks> list = state.watchlist;
      Stocks currentItem = event.item;
      final info = await repository.getMarketInfo(currentItem.symbol);
      if (info == null){
        print('API limit reached :(');
      } else {
        print('AddWatchList setted');
        currentItem.setMarketInfo(info);
        // list.add(currentItem);
        // await repository.updateWatchlist(list);
      }
      // await repository.addWatchlist(currentItem);

      // emit(state.copyWith(watchlist: list));
    } catch(error){
      print (error);
    }
  }

  void _mapRemoveWatchListEventToState(RemoveWatchList event, Emitter<PortfolioState> emit) async {
    try {
      // List<Stocks> list = state.watchlist;
      Stocks currentItem = event.item;
      // list.remove(currentItem);
      // await repository.updateWatchlist(list);
      // emit(state.copyWith(watchlist: list));
    } catch(error){
      print (error);
    }
  }

  // void _mapGetMoreInfoEventToState(GetMoreInfo event, Emitter<WatchListState> emit) async {
  //   try {
  //     emit(state.copyWith(status: WatchListStatus.loading));
  //     // final profile = await repository.getCompanyProfile(state.matchEngine!.currentItem!.content.symbol);
  //     // Stocks currentStock = state.matchEngine!.currentItem!.content;
  //     // currentStock.setCompanyDetails(profile);
  //
  //     emit(state.copyWith(status: WatchListStatus.success, watchlist: []));
  //   } catch (error) {
  //     print(error);
  //     emit(state.copyWith(status: WatchListStatus.error));
  //   }
  // }


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


