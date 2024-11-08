import 'package:elink/cart/view/cart_screen.dart';
import 'package:elink/user_data/bloc/user_data_bloc.dart';
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
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: const Center(
            child: Text("Product List", style: TextStyle(fontSize: 30))),
        leading: IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () {
            context.read<UserDataBloc>().add(ClearUserData());
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) =>
                        const CartScreen()), //navigate to CartScreen
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          //seach bar
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search Products',
                labelStyle: const TextStyle(color: Colors.white70),
                filled: true,
                fillColor: Colors.blueGrey[700],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(
                    color: Colors.blueGrey[400]!,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(
                    color: Colors.blueGrey[400]!,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(
                    color: Colors.white,
                    width: 2.0,
                  ),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                  onPressed: () => _onSearch(),
                ),
              ),
              onSubmitted: (_) => _onSearch(),
            ),
          ),
          //product list
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
