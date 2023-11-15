import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:test_brik/core/components/error_screen.dart';
import 'package:test_brik/core/components/loading_screen.dart';
import 'package:test_brik/core/utils/extension/context_ext.dart';
import 'package:test_brik/features/product/presentation/bloc/detail_product/detail_product_bloc.dart';

import '../../../../injection.dart';

class DetailProductScreen extends StatelessWidget {
  final int id;

  const DetailProductScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<DetailProductBloc>()
        ..add(
          DetailProductEvent.getProduct(id: id),
        ),
      child: _DetailProductView(
        id: id,
      ),
    );
  }
}

class _DetailProductView extends StatelessWidget {
  final int id;

  const _DetailProductView({required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Product'),
      ),
      body: BlocBuilder<DetailProductBloc, DetailProductState>(
        builder: (context, state) {
          if (state.status == FormzSubmissionStatus.inProgress) {
            return const LoadingScreen();
          } else if (state.status == FormzSubmissionStatus.failure) {
            return ErrorScreen(
              message: 'Error',
              onRefresh: () {
                context.read<DetailProductBloc>().add(
                      DetailProductEvent.getProduct(id: id),
                    );
              },
            );
          } else if (state.status == FormzSubmissionStatus.success) {
            return const _DetailProduct();
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}

class _DetailProduct extends StatelessWidget {
  const _DetailProduct();

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        _ImageCarousel(),
        SizedBox(height: 16),
        _DetailProductInfo(),
      ],
    );
  }
}

class _ImageCarousel extends StatelessWidget {
  const _ImageCarousel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DetailProductBloc, DetailProductState>(
      builder: (context, state) {
        final images = state.product?.images ?? [];
        return CarouselSlider(
          options: CarouselOptions(
            height: 200.0,
            enlargeCenterPage: true,
            autoPlay: true,
            aspectRatio: 16 / 9,
            autoPlayCurve: Curves.fastOutSlowIn,
            enableInfiniteScroll: true,
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            viewportFraction: 0.8,
          ),
          items: images.map((imageUrl) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.cover,
                  ),
                );
              },
            );
          }).toList(),
        );
      },
    );
  }
}

class _DetailProductInfo extends StatelessWidget {
  const _DetailProductInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DetailProductBloc, DetailProductState>(
      builder: (context, state) {
        final product = state.product;
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${(product?.title ?? '')} - (${product?.priceInDollars})',
                style: context.textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                '${product?.brand ?? ''} - ${product?.category ?? ''}',
                style: context.textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Ready: ${product?.stock ?? ''}',
                style: context.textTheme.bodyMedium,
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: context.theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Special Price ${product?.discountPercentage ?? ''}% Off - ${product?.priceAfterDiscount ?? ''}',
                  style: context.textTheme.titleLarge?.copyWith(
                    color: context.theme.colorScheme.onPrimary,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                product?.description ?? '',
                style: context.textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }
}
