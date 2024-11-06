import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:elink/products/models/product.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:stream_transform/stream_transform.dart';

part 'product_event.dart';
part 'product_state.dart';

const _postLimit = 20;
const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final http.Client httpClient;

  ProductBloc({required this.httpClient}) : super(const ProductState()) {
    on<ProductFetched>(
      _onFetched,
      transformer: throttleDroppable(throttleDuration),
    );
    on<ProductDetailFetched>(
      _onDetailFetched,
      transformer: throttleDroppable(throttleDuration),
    );
    on<ProductSearchEvent>(_onSearch,
        transformer: throttleDroppable(throttleDuration));
  }

  //get products
  Future<void> _onFetched(
    ProductFetched event,
    Emitter<ProductState> emit,
  ) async {
    if (state.hasReachedMax) return;

    try {
      final products =
          await _fetchProducts(page: state.currentPage + 1, query: null);

      if (products.isEmpty) {
        return emit(state.copyWith(hasReachedMax: true));
      }

      emit(
        state.copyWith(
          status: ProductStatus.success,
          product: [...state.product, ...products],
          currentPage: state.currentPage + 1,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: ProductStatus.failure));
    }
  }

  //get product details by id
  Future<void> _onDetailFetched(
    ProductDetailFetched event,
    Emitter<ProductState> emit,
  ) async {
    emit(state.copyWith(productDetailStatus: ProductDetailStatus.loading));

    try {
      final product = await _fetchProductById(event.productId);
      emit(
        state.copyWith(
          productDetailStatus: ProductDetailStatus.success,
          selectedProduct: product,
        ),
      );
    } catch (_) {
      emit(state.copyWith(productDetailStatus: ProductDetailStatus.failure));
    }
  }

  //search products
  Future<void> _onSearch(
    ProductSearchEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(state.copyWith(status: ProductStatus.initial, product: []));
    try {
      final products = await _fetchProducts(page: 1, query: event.query);
      emit(
        state.copyWith(
          status: ProductStatus.success,
          product: products,
          hasReachedMax: true,
          currentPage: 1,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: ProductStatus.failure));
    }
  }

  Future<List<Product>> _fetchProducts(
      {required int page, String? query}) async {
    final response = await httpClient.get(
      Uri.https(
        '67287ea8270bd0b97555b847.mockapi.io',
        '/elink/api/product',
        {
          'page': '$page',
          'limit': '$_postLimit',
          if (query != null) 'name': query,
        },
      ),
    );
    if (response.statusCode == 200) {
      final body = json.decode(response.body) as List;
      return body.map((dynamic json) {
        final map = json as Map<String, dynamic>;
        return Product(
          id: int.tryParse(map['id'].toString()) ?? 0,
          name: map['name'] as String,
          description: map['description'] as String,
          price: double.tryParse(map['price'].toString()) ?? 0.0,
          imageUrl: map['imageUrl'] as String,
        );
      }).toList();
    }
    throw Exception('Error fetching products');
  }

  Future<Product> _fetchProductById(int id) async {
    final response = await httpClient.get(
      Uri.https(
          '67287ea8270bd0b97555b847.mockapi.io', '/elink/api/product/$id'),
    );

    if (response.statusCode == 200) {
      final map = json.decode(response.body) as Map<String, dynamic>;
      return Product(
        id: int.tryParse(map['id'].toString()) ?? 0,
        name: map['name'] as String,
        description: map['description'] as String,
        price: double.tryParse(map['price'].toString()) ?? 0.0,
        imageUrl: map['imageUrl'] as String,
      );
    }
    throw Exception('Error fetching product');
  }
}
