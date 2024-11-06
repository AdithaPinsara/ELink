import 'package:elink/products/view/product_list.dart';
import 'package:elink/user_data/bloc/user_data_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatelessWidget {
  final TextEditingController _usernameController =
      TextEditingController(); //controller for the username
  final TextEditingController _passwordController =
      TextEditingController(); //controller for the password

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          title: const Center(
              child: Text(
            'Login',
            style: TextStyle(fontSize: 50),
          ))),
      body: BlocProvider(
        create: (_) => UserDataBloc(httpClient: http.Client()),
        child: BlocListener<UserDataBloc, UserDataState>(
          listener: (context, state) {
            if (state.status == UserLoginStatus.success) {
              _usernameController.clear();
              _passwordController.clear();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text('Welcome, ${state.userName?.username}!')),
              );
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) =>
                        const ProductsList()), // Navigate to productlist
              );
            } else if (state.status == UserLoginStatus.failure) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Error while trying to login!')),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      labelStyle: const TextStyle(color: Colors.white70),
                      filled: true,
                      fillColor: Colors.blueGrey[700],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(
                          color: Colors.blueGrey[400]!,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(
                          color: Colors.blueGrey[400]!,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(
                          color: Colors.white,
                          width: 2.0,
                        ),
                      ),
                    )),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: const TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: Colors.blueGrey[700],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: Colors.blueGrey[400]!,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: Colors.blueGrey[400]!,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(
                        color: Colors.white,
                        width: 2.0,
                      ),
                    ),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 16),
                BlocBuilder<UserDataBloc, UserDataState>(
                  builder: (context, state) {
                    if (state.status == UserLoginStatus.loading) {
                      return const CircularProgressIndicator();
                    }
                    return ElevatedButton(
                      onPressed: () {
                        final username = _usernameController.text;
                        final password = _passwordController.text;
                        context.read<UserDataBloc>().add(
                              LoginSubmitted(
                                  username: username, password: password),
                            );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey[700],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24.0, vertical: 12.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        elevation: 5,
                      ),
                      child: const Text('Login'),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
