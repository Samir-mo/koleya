import 'package:dartz/dartz.dart';
import '../../../../core/errors/error_handler.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/shared/data/services_data_source.dart';
import '../../../../core/shared/models/service_model.dart';
import 'explore_places_repo.dart';

class ExplorePlacesRepoImpl implements ExplorePlacesRepo {
  final ServicesDataSource dataSource;
  ExplorePlacesRepoImpl({required this.dataSource});

  @override
  Future<Either<Failure, List<ServiceModel>>> getPlaces({
    String? category,
  }) async {
    try {
      final result = await dataSource.getServices(category: category);
      return Right(result);
    } catch (e) {
      return Left(ErrorHandler.handleFailure(e));
    }
  }

  @override
  Future<Either<Failure, ServiceModel>> getPlaceById(String id) async {
    try {
      final result = await dataSource.getServiceById(id);
      return Right(result);
    } catch (e) {
      return Left(ErrorHandler.handleFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<ServiceModel>>> searchPlaces({
    required String query,
    String? category,
  }) async {
    try {
      final result = await dataSource.searchServices(
        query: query,
        category: category,
      );
      return Right(result);
    } catch (e) {
      return Left(ErrorHandler.handleFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<ServiceModel>>> filterPlaces({
    String? category,
    double? minRating,
    List<int>? priceLevel,
    bool? hasWifi,
    bool? hasUsb,
  }) async {
    try {
      final result = await dataSource.filterServices(
        category: category,
        minRating: minRating,
        priceLevel: priceLevel,
        hasWifi: hasWifi,
        hasUsb: hasUsb,
      );
      return Right(result);
    } catch (e) {
      return Left(ErrorHandler.handleFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> ratePlace({
    required String id,
    required int rating,
    String? review,
  }) async {
    try {
      await dataSource.rateService(id: id, rating: rating, review: review);
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handleFailure(e));
    }
  }
}
