import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_brik/core/utils/debouncer.dart';
import 'package:test_brik/core/utils/extension/context_ext.dart';
import 'package:test_brik/core/utils/extension/string_ext.dart';
import 'package:test_brik/features/product/presentation/bloc/search_product/search_product_bloc.dart';
import 'package:test_brik/features/product/presentation/screens/detail_product_screen.dart';

import '../../../../core/components/search_box.dart';
import '../../../../injection.dart';
import '../../domain/entities/product.codegen.dart';

class SearchProductsScreen extends StatelessWidget {
  const SearchProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<SearchProductBloc>(),
      child: const ProductsView(),
    );
  }
}

class ProductsView extends StatefulWidget {
  const ProductsView({super.key});

  @override
  State<ProductsView> createState() => _ProductsViewState();
}

class _ProductsViewState extends State<ProductsView> {
  late final ScrollController _scrollController;
  final searchNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    searchNode.requestFocus();
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (currentScroll == maxScroll) {
      Debouncer(milliseconds: 500).run(() {
        final bloc = context.read<SearchProductBloc>();
        bloc.add(SearchProductEvent.searchProduct(
          query: bloc.state.search,
          skip: 0,
        ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.theme.colorScheme.background,
        title: SearchBox(
          focusNode: searchNode,
          initialValue: emptyString,
          hintText: 'Search product',
          onChanged: (val) {
            final bloc = BlocProvider.of<SearchProductBloc>(context);
            bloc.add(SearchProductEvent.searchProduct(
              query: val,
              skip: 0,
            ));
          },
        ),
      ),
      body: BlocBuilder<SearchProductBloc, SearchProductState>(
        builder: (context, state) {
          final products = state.products;
          final count = () {
            if (state.isLoading) {
              return (products?.length ?? 0) + 1;
            } else {
              return products?.length ?? 0;
            }
          }();

          return RefreshIndicator(
            onRefresh: () {
              final bloc = BlocProvider.of<SearchProductBloc>(context)
                ..add(SearchProductEvent.searchProduct(
                  query: state.search,
                  skip: 0,
                ));
              return bloc.stream.firstWhere((state) => !state.isLoading);
            },
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              controller: _scrollController,
              itemCount: count,
              itemBuilder: (context, index) {
                if (index >= (products?.length ?? 0)) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Center(
                      child: LinearProgressIndicator(
                        color: Colors.white,
                      ),
                    ),
                  );
                }
                return _ProductCard(
                  product: products?[index],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailProductScreen(
                          id: products?[index].id ?? 0,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Product? product;
  final VoidCallback onTap;

  const _ProductCard({
    required this.product,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: context.theme.colorScheme.background,
      child: ListTile(
        contentPadding: const EdgeInsets.all(10),
        leading: CachedNetworkImage(
          imageUrl: product?.thumbnail ?? emptyString,
          width: 100,
          height: 100,
        ),
        title: Text(
          product?.title ?? emptyString,
          style: context.textTheme.titleLarge,
        ),
        subtitle: Text(product?.description ?? emptyString),
        trailing: Text(product?.priceInDollars ?? emptyString),
        onTap: onTap,
      ),
    );
  }
}
