part of 'product_bloc.dart';

sealed class ProductEvent extends Equatable {
  @override
  List<Object> get props => [];
}

// event for fetching products
final class ProductFetched extends ProductEvent {}

//event for getting product details
final class ProductDetailFetched extends ProductEvent {
  final int productId;

  ProductDetailFetched(this.productId);

  @override
  List<Object> get props => [productId];
}

// event for searching products
final class ProductSearchEvent extends ProductEvent {
  final String query;

  ProductSearchEvent(this.query);

  @override
  List<Object> get props => [query];
}
