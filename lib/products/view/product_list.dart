import 'package:elink/cart/view/cart_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elink/products/bloc/product_bloc.dart';
import 'package:elink/products/widgets/bottom_loader.dart';
import 'package:elink/products/widgets/product_list_item.dart';

class ProductsList extends StatefulWidget {
  const ProductsList({super.key});

  @override
  State<ProductsList> createState() => _ProductsListState();
}

class _ProductsListState extends State<ProductsList> {
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Product List"),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) =>
                        const CartScreen()), // Navigate to CartScreen
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search Products',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () => _onSearch(),
                ),
              ),
              onSubmitted: (_) => _onSearch(),
            ),
          ),
          Expanded(
            child: BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                switch (state.status) {
                  case ProductStatus.failure:
                    return const Center(
                        child: Text('Failed to fetch products'));
                  case ProductStatus.success:
                    if (state.product.isEmpty) {
                      return const Center(child: Text('No products found'));
                    }
                    return ListView.builder(
                      itemBuilder: (BuildContext context, int index) {
                        return index >= state.product.length
                            ? const BottomLoader()
                            : ProductListItem(product: state.product[index]);
                      },
                      itemCount: state.hasReachedMax
                          ? state.product.length
                          : state.product.length + 1,
                      controller: _scrollController,
                    );
                  case ProductStatus.initial:
                    return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) context.read<ProductBloc>().add(ProductFetched());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  void _onSearch() {
    final query = _searchController.text;
    if (query.isNotEmpty) {
      context.read<ProductBloc>().add(ProductSearchEvent(query));
    } else {
      context.read<ProductBloc>().add(ProductFetched());
    }
  }
}
