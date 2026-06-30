import 'package:dartz/dartz.dart';
import '../../../../core/errors/error_handler.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/shared/data/services_data_source.dart';
import '../../../../core/shared/models/service_model.dart';
import 'services_category_repo.dart';

class ServicesCategoryRepoImpl implements ServicesCategoryRepo {
  final ServicesDataSource dataSource;
  ServicesCategoryRepoImpl({required this.dataSource});

  @override
  Future<Either<Failure, List<ServiceModel>>> getByCategory(
    String category,
  ) async {
    try {
      final result = await dataSource.getServices(category: category);
      return Right(result);
    } catch (e) {
      return Left(ErrorHandler.handleFailure(e));
    }
  }
}
