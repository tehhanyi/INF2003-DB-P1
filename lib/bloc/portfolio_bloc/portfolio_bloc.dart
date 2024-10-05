import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../api/local_repo.dart';
import '../../models/assets.dart';

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
    on<GetLeaderboard>(_mapGetTopTenEventToState);
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
      emit(state.copyWith(status: PortfolioStatus.tranLoading));
      final items = await repository.getAllTransaction();
      emit(state.copyWith(transactions: items, status: PortfolioStatus.tranLoaded));
      emit(state.copyWith(status: PortfolioStatus.success));
    } catch (error) {
      print(error);
      emit(state.copyWith(status: PortfolioStatus.error));
    }
  }

  void _mapGetTopTenEventToState(GetLeaderboard event, Emitter<PortfolioState> emit) async {
    try {
      emit(state.copyWith(status: PortfolioStatus.loading));
      final items = await repository.getTopTen();
      emit(state.copyWith(transactions: items, status: PortfolioStatus.success));
    } catch(error){
      print (error);
    }
  }

}


