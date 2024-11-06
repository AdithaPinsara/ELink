part of 'user_data_bloc.dart';

enum UserLoginStatus { initial, loading, success, failure }

final class UserDataState extends Equatable {
  final UserLoginStatus status;
  final Password? password;
  final UserName? userName;

  const UserDataState({
    this.status = UserLoginStatus.initial,
    this.password,
    this.userName,
  });

  UserDataState copyWith({
    UserLoginStatus? status,
    Password? password,
    UserName? userName,
  }) {
    return UserDataState(
      status: status ?? this.status,
      password: password ?? this.password,
      userName: userName ?? this.userName,
    );
  }

  @override
  List<Object?> get props => [status, password, userName];
}
