import 'package:chat_app/const.dart';
import 'package:chat_app/services/alert_service.dart';
import 'package:chat_app/services/auth_services.dart';
import 'package:chat_app/services/navigation_service.dart';
import 'package:chat_app/widgets/custom_form_field.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GetIt _getIt = GetIt.instance; // getIt

  final GlobalKey<FormState> _loginFormKey = GlobalKey();

  late AuthService _authService; // true or false if loggin in is successful

  late NavigationService _navigationService;

  late AlertService _alertService;

  String? email, password;

  @override
  void initState() {
    super.initState();
    _authService = _getIt.get<AuthService>(); //<instance> == type
    _navigationService = _getIt.get<NavigationService>();
    _alertService = _getIt.get<AlertService>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    // function/method in flutter/dart
    return SafeArea(
        child: Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 20,
      ),
      child: Column(
        children: [
          _headerText(),
          _loginForm(),
          _createAnAccountLink(),
        ],
      ),
    ));
  }

  Widget _headerText() {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome Back',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            'Hello, Welcome Back again',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _loginForm() {
    return Container(
      height: MediaQuery.sizeOf(context).height * .4,
      margin: EdgeInsets.symmetric(
        vertical: MediaQuery.sizeOf(context).height * .05,
      ),
      child: Form(
        key: _loginFormKey, // variable at State class
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomFormField(
              height: MediaQuery.sizeOf(context).height * 0.1,
              hintText: "Email",
              validationRegEx: EMAIL_VALIDATION_REGEX, // regex username
              onSaved: (value) {
                setState(() {
                  email = value;
                });
              },
            ), // asking for 2 argument
            CustomFormField(
              height: MediaQuery.sizeOf(context).height * 0.1,
              hintText: "Password",
              validationRegEx:
                  PASSWORD_VALIDATION_REGEX, // regex password: hint learn regex: 1 capital letter, small character, 8 characters long and special characters
              obscureText: true,
              onSaved: (value) {
                setState(() {
                  password = value;
                });
              },
            ), // asking for 2 argument
            _loginButton(),
          ],
        ),
      ),
    );
  }

  Widget _loginButton() {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: MaterialButton(
        onPressed: () async {
          if (_loginFormKey.currentState?.validate() ?? false) {
            // check if user inputs the valid info
            // print("Finally asdasdasdasd");
            // print(email);
            // print(password);

            _loginFormKey.currentState?.save();
            bool result = await _authService.login(
                email!, password!); // ! == not going to be empty
            print(result);
            if (result) {
              _navigationService.pushReplacementNamed(
                  "/home"); // why .pushReplacement name? remove the ability to return to log in page
            } else {
              _alertService.showToast(
                text: "Failed to login, Please try again",
                icon: Icons.error,
              );
            }
          }
        },
        color: Theme.of(context).colorScheme.primary,
        child: Text(
          "Login",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _createAnAccountLink() {
    return Expanded(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Text("Don\'t have an account"),
          GestureDetector(
            onTap: () {
              _navigationService
                  .pushNamed("/register"); // navigate to register page
            },
            child: const Text(
              " Sign Up",
              style: TextStyle(
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
