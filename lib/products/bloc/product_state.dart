part of 'product_bloc.dart';

enum ProductStatus { initial, success, failure }

enum ProductDetailStatus { initial, loading, success, failure }

final class ProductState extends Equatable {
  final ProductStatus status;
  final List<Product> product;
  final bool hasReachedMax;
  final int currentPage;
  final Product? selectedProduct;
  final ProductDetailStatus productDetailStatus;

  const ProductState({
    this.status = ProductStatus.initial,
    this.product = const <Product>[],
    this.hasReachedMax = false,
    this.currentPage = 0,
    this.selectedProduct,
    this.productDetailStatus = ProductDetailStatus.initial,
  });

  ProductState copyWith({
    ProductStatus? status,
    List<Product>? product,
    bool? hasReachedMax,
    int? currentPage,
    Product? selectedProduct,
    ProductDetailStatus? productDetailStatus,
  }) {
    return ProductState(
      status: status ?? this.status,
      product: product ?? this.product,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
      selectedProduct: selectedProduct ?? this.selectedProduct,
      productDetailStatus: productDetailStatus ?? this.productDetailStatus,
    );
  }

  @override
  List<Object?> get props => [
        status,
        product,
        hasReachedMax,
        currentPage,
        selectedProduct,
        productDetailStatus
      ];
}
