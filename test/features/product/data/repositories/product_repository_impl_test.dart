import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test_brik/core/error/failures.dart';
import 'package:test_brik/features/product/data/datasources/remote/product_remote_data_source.dart';
import 'package:test_brik/features/product/data/models/product_model.codegen.dart';
import 'package:test_brik/features/product/data/repositories/product_repository_impl.dart';
import 'package:dartz/dartz.dart';
import 'package:test_brik/features/product/domain/entities/product.codegen.dart';

class MockProductRemoteDataSource extends Mock
    implements ProductRemoteDataSource {}

void main() {
  late ProductRepositoryImpl repository;
  late MockProductRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockProductRemoteDataSource();
    repository = ProductRepositoryImpl(remoteDataSource: mockRemoteDataSource);
  });

  const tProductModel = ProductModel(id: 1, title: 'Test Product');
  const tProduct = Product(id: 1, title: 'Test Product');

  group('createProduct', () {
    test('should return Product when the creation is successful', () async {
      when(() => mockRemoteDataSource.createProduct(tProductModel))
          .thenAnswer((_) async => const Right(tProductModel));

      final result = await repository.createProduct(tProduct);

      expect(result, equals(const Right(tProduct)));
    });
    test('should return Failure when the creation is unsuccessful', () async {
      when(() => mockRemoteDataSource.createProduct(tProductModel))
          .thenAnswer((_) async => const Left(ServerFailure()));

      final result = await repository.createProduct(tProduct);

      verify(() => mockRemoteDataSource.createProduct(tProductModel)).called(1);
      expect(result, equals(const Left(ServerFailure())));
    });
  });

  group('getProductByID', () {
    test('should return Product when the retrieval is successful', () async {
      when(() => mockRemoteDataSource.getProductByID(1))
          .thenAnswer((_) async => const Right(tProductModel));

      final result = await repository.getProductByID(1);

      verify(() => mockRemoteDataSource.getProductByID(1));
      expect(result, equals(const Right(tProduct)));
    });

    test('should return Failure when the retrieval is unsuccessful', () async {
      when(() => mockRemoteDataSource.getProductByID(1))
          .thenAnswer((_) async => const Left(ServerFailure()));

      final result = await repository.getProductByID(1);

      verify(() => mockRemoteDataSource.getProductByID(1));
      expect(result, equals(const Left(ServerFailure())));
    });
  });
}
