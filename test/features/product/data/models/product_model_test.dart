import 'package:flutter_test/flutter_test.dart';
import 'package:test_brik/features/product/data/models/product_model.codegen.dart';
import 'package:test_brik/features/product/domain/entities/product.codegen.dart';

void main() {
  const tProductModel = ProductModel(id: 1, title: 'Test Product');
  const tProduct = Product(id: 1, title: 'Test Product');

  group('ProductResponseModel', () {
    test('should be created from JSON', () {
      final Map<String, dynamic> json = {
        'total': 1,
        'skip': 0,
        'limit': 1,
        'products': [tProductModel.toJson()],
      };

      final result = ProductResponseModel.fromJson(json);

      expect(result.total, 1);
      expect(result.skip, 0);
      expect(result.limit, 1);
      expect(result.products!.first, tProductModel);
    });

    test('should convert to entity', () {
      const productResponseModel = ProductResponseModel(
        total: 1,
        skip: 0,
        limit: 1,
        products: [tProductModel],
      );

      final result = productResponseModel.toEntity();

      expect(result.first, tProduct.copyWith(total: 1, skip: 0, limit: 1));
    });
  });
}
