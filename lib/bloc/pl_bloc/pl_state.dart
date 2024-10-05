part of 'pl_bloc.dart';

enum PLStatus { initial, success, error, loading }

extension CardStatusX on PLStatus {
  bool get isInitial => this == PLStatus.initial;
  bool get isSuccess => this == PLStatus.success;
  bool get isError => this == PLStatus.error;
  bool get isLoading => this == PLStatus.loading;
}

class PLState extends Equatable {
  final PLStatus status;
  final num price;
  // final List<Stocks> items;

  PLState({
    this.status = PLStatus.initial,
    this.price = 0
    // List<Stocks>? items,
  }) ;//items = items ?? [];

  @override
  List<Object?> get props => [status];

  PLState copyWith({
    PLStatus? status,
    num? price
    // List<Stocks>? items,
  }) {
    return PLState(
        status: status ?? this.status,
        price: price ?? this.price
        // items: items ?? this.items,
    );
  }
}
