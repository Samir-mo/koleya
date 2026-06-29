import 'package:dartz/dartz.dart';
import 'package:gate_buddy/core/errors/failure.dart';
import 'package:gate_buddy/core/shared/models/service_model.dart';

abstract class ServicesCategoryRepo {
  Future<Either<Failure, List<ServiceModel>>> getByCategory(String category);
}
