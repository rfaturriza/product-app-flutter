import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:test_brik/core/error/failures.dart';
import 'package:test_brik/features/product/data/models/product_model.codegen.dart';

import 'product_remote_data_source.dart';

@LazySingleton(as: ProductRemoteDataSource)
class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  static const _endpoint = 'products';
  final Dio _dio;
  const ProductRemoteDataSourceImpl(this._dio);

  @override
  Future<Either<Failure, ProductModel>> getProductByID(int id) async {
    try {
      final result = await _dio.get('$_endpoint/$id');
      return Right(ProductModel.fromJson(result.data));
    } on DioException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, ProductResponseModel>> getProducts(
      int? limit, int? skip) async {
    try {
      final queryParameters = {
        'limit': limit,
        'skip': skip,
      };
      final result =
          await _dio.get(_endpoint, queryParameters: queryParameters);
      return Right(ProductResponseModel.fromJson(result.data));
    } on DioException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, ProductResponseModel>> searchProduct(
      String query, int? limit, int? skip) async {
    try {
      final queryParameters = {
        'q': query,
        'limit': limit,
        'skip': skip,
      };
      final result =
          await _dio.get('$_endpoint/search', queryParameters: queryParameters);
      return Right(ProductResponseModel.fromJson(result.data));
    } on DioException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, ProductModel>> createProduct(
      ProductModel product) async {
    try {
      final result = await _dio.post('$_endpoint/add', data: product.toJson());
      return Right(ProductModel.fromJson(result.data));
    } on DioException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }
}
