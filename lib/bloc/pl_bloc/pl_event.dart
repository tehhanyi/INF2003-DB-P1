part of 'pl_bloc.dart';

abstract class PLEvent extends Equatable {
  const PLEvent();
}

class GetProfitLoss extends PLEvent {
  final List<Asset> transactions;

  const GetProfitLoss(this.transactions);

  @override
  List<Object?> get props => [];
}