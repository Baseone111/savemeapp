import 'package:fpdart/fpdart.dart';
import 'package:trafficking_detector/core/errors/failures.dart';
import 'package:trafficking_detector/core/commons/entities/user.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, User>> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  });
  Future<Either<Failure, User>> loginWithEmailPassword({
    required String email,
    required String password,
  });
  Future<Either<Failure, User>> currentUser();
}
