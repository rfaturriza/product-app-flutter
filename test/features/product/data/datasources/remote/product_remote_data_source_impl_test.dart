import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:test_brik/core/error/failures.dart';
import 'package:test_brik/features/product/data/datasources/remote/product_remote_data_source_impl.dart';
import 'package:test_brik/features/product/data/models/product_model.codegen.dart';

void main() {
  late ProductRemoteDataSourceImpl dataSource;
  final Dio dio = Dio(BaseOptions());
  final DioAdapter dioAdapter = DioAdapter(dio: dio);

  setUp(() {
    dio.httpClientAdapter = dioAdapter;
    dataSource = ProductRemoteDataSourceImpl(dio);
  });

  group('getProductByID', () {
    const tId = 1;
    const tProductModel = ProductModel(id: tId, title: 'Test Product');
    const endpoint = 'products';

    test('should return ProductModel when the response code is 200', () async {
      dioAdapter.onGet(
        '$endpoint/$tId',
        (server) => server.reply(
          200,
          tProductModel.toJson(),
        ),
      );
      // act
      final result = await dataSource.getProductByID(tId);
      // assert
      expect(result, const Right(tProductModel));
    });

    test('should return ServerFailure when the response code is 404 or other',
        () async {
      final dioError = DioException(
        requestOptions: RequestOptions(
          path: '$endpoint/$tId',
        ),
      );
      dioAdapter.onGet(
        '$endpoint/$tId',
        (server) => server.throws(
          404,
          dioError,
        ),
      );
      // act
      final result = await dataSource.getProductByID(tId);
      // assert
      expect(result, Left(ServerFailure(message: dioError.message)));
    });
  });
}
