import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/shared/models/service_model.dart';

abstract class ExplorePlacesRepo {
  Future<Either<Failure, List<ServiceModel>>> getPlaces({String? category});

  Future<Either<Failure, ServiceModel>> getPlaceById(String id);

  Future<Either<Failure, List<ServiceModel>>> searchPlaces({
    required String query,
    String? category,
  });

  Future<Either<Failure, List<ServiceModel>>> filterPlaces({
    String? category,
    double? minRating,
    List<int>? priceLevel,
    bool? hasWifi,
    bool? hasUsb,
  });

  Future<Either<Failure, void>> ratePlace({
    required String id,
    required int rating,
    String? review,
  });
}
