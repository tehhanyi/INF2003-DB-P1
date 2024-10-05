part of 'portfolio_bloc.dart';

abstract class PortfolioEvent extends Equatable {
  const PortfolioEvent();
}

class GetName extends PortfolioEvent{
  @override
  List<Object?> get props => [];
}

class UpdateName extends PortfolioEvent{
  final String name;

  const UpdateName(this.name);

  @override
  List<Object?> get props => [];
}

class DeleteUser extends PortfolioEvent{

  @override
  List<Object?> get props => [];
}

class GetAllTransactions extends PortfolioEvent {

  @override
  List<Object?> get props => [];
}

class GetLeaderboard extends PortfolioEvent {

  @override
  List<Object?> get props => [];
}
// class AddWatchList extends PortfolioEvent {
//   final Stocks item;
//
//   const AddWatchList(this.item);
//
//   @override
//   List<Object?> get props => [];
// }
//
// class RemoveWatchList extends PortfolioEvent {
//   final Stocks item;
//
//   const RemoveWatchList(this.item);
//
//   @override
//   List<Object?> get props => [];
// }


