import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:test_brik/core/utils/extension/extension.dart';
import 'package:test_brik/core/utils/extension/string_ext.dart';

import '../../data/models/product_model.codegen.dart';

part 'product.codegen.freezed.dart';

@freezed
class Product with _$Product {
  const factory Product({
    int? id,
    String? title,
    String? description,
    int? price,
    double? discountPercentage,
    double? rating,
    int? stock,
    String? brand,
    String? category,
    String? thumbnail,
    List<String>? images,
    int? total,
    int? skip,
    int? limit,
  }) = _Product;

 String? get priceInDollars => price?.formatPrice();
 String? get priceAfterDiscount => price?.afterDiscount(discountPercentage);

  const Product._();

  ProductModel toModel() => ProductModel(
        id: id,
        title: title,
        description: description,
        price: price,
        discountPercentage: discountPercentage,
        rating: rating,
        stock: stock,
        brand: brand,
        category: category,
        thumbnail: thumbnail,
        images: images,
      );
}
