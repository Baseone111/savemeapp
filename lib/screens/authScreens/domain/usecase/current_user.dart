import 'package:fpdart/fpdart.dart';
import 'package:trafficking_detector/core/errors/failures.dart';
import 'package:trafficking_detector/core/usecase/usecase.dart';
import 'package:trafficking_detector/screens/authScreens/domain/repository/auth_repository.dart';
import 'package:trafficking_detector/core/commons/entities/user.dart';

class CurrentUser implements UseCase<User, NoParams> {
  final AuthRepository authRepository;
  CurrentUser(this.authRepository);

  @override
  Future<Either<Failure, User>> call(NoParams params) async {
    return await authRepository.currentUser();
  }
}
