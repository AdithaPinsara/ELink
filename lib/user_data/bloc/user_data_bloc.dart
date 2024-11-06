import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:elink/user_data/models/user_data_barrel.dart';
import 'package:http/http.dart' as http;

part 'user_data_event.dart';
part 'user_data_state.dart';

class UserDataBloc extends Bloc<UserDataEvent, UserDataState> {
  final http.Client httpClient;

  UserDataBloc({required this.httpClient}) : super(const UserDataState()) {
    on<LoginSubmitted>(_onUserDataFetched);
    on<ClearUserData>((event, emit) {
      emit(state.copyWith(
          status: UserLoginStatus.initial, password: null, userName: null));
    });
  }

  Future<void> _onUserDataFetched(
    LoginSubmitted event,
    Emitter<UserDataState> emit,
  ) async {
    emit(state.copyWith(status: UserLoginStatus.loading));

    try {
      final password = await _fetchUserByUserName(event.username);
      if (password.password == event.password) {
        emit(
          state.copyWith(
            status: UserLoginStatus.success,
            password: password,
            userName: UserName(username: event.username),
          ),
        );
      } else {
        emit(state.copyWith(status: UserLoginStatus.failure));
      }
    } catch (_) {
      emit(state.copyWith(status: UserLoginStatus.failure));
    }
  }

  Future<Password> _fetchUserByUserName(String userName) async {
    final response = await httpClient.get(
      Uri.https(
        '67287ea8270bd0b97555b847.mockapi.io',
        '/elink/api/users',
        {
          'username': userName,
        },
      ),
    );

    if (response.statusCode == 200) {
      final map = json.decode(response.body) as List;
      return Password(
        password: map[0]['password'] as String,
      );
    }
    throw Exception('Error fetching product');
  }
}
