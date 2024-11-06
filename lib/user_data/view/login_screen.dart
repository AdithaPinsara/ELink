import 'package:elink/products/view/product_list.dart';
import 'package:elink/user_data/bloc/user_data_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
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
                SnackBar(content: Text('Error!')),
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
                  decoration: const InputDecoration(labelText: 'Username'),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
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
