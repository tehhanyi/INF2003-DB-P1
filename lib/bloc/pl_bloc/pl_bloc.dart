import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:varsity_app/bloc/portfolio_bloc/portfolio_bloc.dart';

import '../../api/local_repo.dart';
import '../../models/assets.dart';

part 'pl_event.dart';
part 'pl_state.dart';

class PLBloc extends Bloc<PLEvent, PLState> {
  final LocalRepository repository;
  final PortfolioBloc transactionBloc;
  StreamSubscription? transactionSubscription;

  PLBloc({
    required this.repository,
    required this.transactionBloc
  }) : super(PLState()) {
    on<GetProfitLoss>(_mapGetProfitLossEventToState);

    transactionSubscription = transactionBloc.stream.listen((state) {
      ('listening to transactionSubscription');
      if (state.status.isTransactionLoaded) {
        add(GetProfitLoss(state.transactions));
      }
    });
  }

  void _mapGetProfitLossEventToState(GetProfitLoss event, Emitter<PLState> emit) async {
    try {
      print('GetProfitLoss');
      emit(state.copyWith(status:PLStatus.loading));
      final price = await repository.getProfitLoss(event.transactions);

      emit(state.copyWith(status:PLStatus.success, price: price));
    } catch (error) {
      emit(state.copyWith(status: PLStatus.error));
    }
  }
}


