import 'package:equatable/equatable.dart';

class UserName extends Equatable {
  final String username;

  const UserName({
    required this.username,
  });

  @override
  List<Object> get props => [username];
}
