import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/product.codegen.dart';

part 'product_model.codegen.freezed.dart';

part 'product_model.codegen.g.dart';

@freezed
class ProductResponseModel with _$ProductResponseModel {
  const factory ProductResponseModel({
    int? total,
    int? skip,
    int? limit,
    List<ProductModel>? products,
  }) = _ProductResponseModel;

  const ProductResponseModel._();

  factory ProductResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ProductResponseModelFromJson(json);

  List<Product> toEntity() =>
      products
          ?.map((e) => e.toEntity().copyWith(
                total: total,
                skip: skip,
                limit: limit,
              ))
          .toList() ??
      [];
}

@freezed
class ProductModel with _$ProductModel {
  const factory ProductModel({
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
  }) = _ProductModel;

  const ProductModel._();

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);

  Product toEntity() => Product(
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
