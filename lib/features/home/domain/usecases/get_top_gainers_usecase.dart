import 'package:dartz/dartz.dart';
import 'package:team_18_final_project/core/error/failure.dart';
import 'package:team_18_final_project/features/home/domain/entities/top_gainer.dart';
import 'package:team_18_final_project/features/home/domain/repositories/home_repository.dart';

class GetTopGainersUseCase {
  final HomeRepository repository;

  GetTopGainersUseCase(this.repository);

  Future<Either<Failure, List<TopGainerEntity>>> call() async {
    return await repository.getTopGainers();
  }
}
