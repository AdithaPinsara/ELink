import 'package:equatable/equatable.dart';

class Password extends Equatable {
  final String password;

  const Password({
    required this.password,
  });

  @override
  List<Object> get props => [password];
}
