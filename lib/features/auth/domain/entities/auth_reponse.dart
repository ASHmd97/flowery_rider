// features/auth/domain/entities/auth_reponse.dart
import 'package:equatable/equatable.dart';

class AuthResponseEntity extends Equatable {
  final String? message;
  final String? token;

  const AuthResponseEntity({this.message, this.token});

  @override
  List<Object?> get props => [message, token];
}
