import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:test_brik/core/utils/extension/context_ext.dart';
import 'package:test_brik/features/product/presentation/bloc/add_product/add_product_bloc.dart';

import '../../../../injection.dart';

class AddProductScreen extends StatelessWidget {
  const AddProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AddProductBloc>(),
      child: const _AddProductView(),
    );
  }
}

class _AddProductView extends StatelessWidget {
  const _AddProductView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Add New Product'),
      ),
      body: BlocListener<AddProductBloc, AddProductState>(
        listener: (context, state) {
          if (state.status == FormzSubmissionStatus.success) {
            Navigator.pop(context);
            context.showInfoToast('${state.product.title} added');
          } else if (state.status == FormzSubmissionStatus.failure) {
            context.showErrorToast('${state.product.title} failed to add');
          }
        },
        child: const _FormAddProduct(),
      ),
      bottomNavigationBar: const SafeArea(
        child: _ButtonAddProduct(),
      ),
    );
  }
}

class _ButtonAddProduct extends StatelessWidget {
  const _ButtonAddProduct();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddProductBloc, AddProductState>(
      builder: (context, state) {
        final isLoading = state.status == FormzSubmissionStatus.inProgress;
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () {
                      context.read<AddProductBloc>().add(
                            const AddProductEvent.addProduct(),
                          );
                    },
              child: isLoading
                  ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : Text(
                      'Add Product',
                      style: context.textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }
}

class _FormAddProduct extends StatelessWidget {
  const _FormAddProduct();

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<AddProductBloc>();
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      children: [
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Name',
          ),
          style: context.textTheme.titleMedium?.copyWith(
            color: Colors.black,
          ),
          onChanged: (value) {
            bloc.add(
              AddProductEvent.onChanged(title: value),
            );
          },
        ),
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Price',
            prefixText: '\$ ',
            prefixStyle: context.textTheme.titleLarge?.copyWith(
              color: Colors.grey,
            ),
            helperText: 'Max: 999999.99',
          ),
          style: context.textTheme.titleMedium?.copyWith(
            color: Colors.black,
          ),
          onChanged: (value) {
            bloc.add(
              AddProductEvent.onChanged(price: int.parse(value)),
            );
          },
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d{0,6}(\.\d{0,2})?$'))
          ],
        ),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Description',
          ),
          style: context.textTheme.titleMedium?.copyWith(
            color: Colors.black,
          ),
          minLines: 2,
          maxLines: 5,
          onChanged: (value) {
            bloc.add(
              AddProductEvent.onChanged(description: value),
            );
          },
        ),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Discount Percentage',
            suffixText: '%',
            helperText: 'Max: 99.99',
          ),
          style: context.textTheme.titleMedium?.copyWith(
            color: Colors.black,
          ),
          onChanged: (value) {
            bloc.add(
              AddProductEvent.onChanged(
                discountPercentage: double.parse(value),
              ),
            );
          },
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d{0,2}(\.\d{0,2})?$')),
          ],
        ),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Stock',
          ),
          style: context.textTheme.titleMedium?.copyWith(
            color: Colors.black,
          ),
          onChanged: (value) {
            bloc.add(
              AddProductEvent.onChanged(stock: int.parse(value)),
            );
          },
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
        ),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Brand',
          ),
          style: context.textTheme.titleMedium?.copyWith(
            color: Colors.black,
          ),
          onChanged: (value) {
            bloc.add(
              AddProductEvent.onChanged(brand: value),
            );
          },
        ),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Category',
          ),
          style: context.textTheme.titleMedium?.copyWith(
            color: Colors.black,
          ),
          onChanged: (value) {
            bloc.add(
              AddProductEvent.onChanged(category: value),
            );
          },
        ),
      ],
    );
  }
}
