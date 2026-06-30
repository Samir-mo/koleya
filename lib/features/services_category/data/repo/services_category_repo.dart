import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/shared/models/service_model.dart';

abstract class ServicesCategoryRepo {
  Future<Either<Failure, List<ServiceModel>>> getByCategory(String category);
}
