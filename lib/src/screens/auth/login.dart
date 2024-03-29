import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queen_validators/queen_validators.dart';
import 'package:tahwisa/src/blocs/authentication_bloc/bloc.dart';
import 'package:tahwisa/src/blocs/login_bloc/bloc.dart';
import 'package:tahwisa/src/repositories/user_repository.dart';
import 'package:tahwisa/src/screens/auth/widgets/auth_button.dart';
import 'package:tahwisa/src/screens/auth/widgets/auth_input.dart';
import 'package:tahwisa/src/screens/profile/widgets/hide_keyboard_ontap.dart';
import 'package:tahwisa/src/style/my_colors.dart';

import 'reset_password.dart';

class LoginForm extends StatefulWidget {
  final LoginBloc? loginBloc;
  final AuthenticationBloc? authenticationBloc;

  LoginForm({
    Key? key,
    required this.loginBloc,
    required this.authenticationBloc,
  }) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  LoginBloc? get _loginBloc => widget.loginBloc;
  bool obscured = true;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      bloc: _loginBloc,
      builder: (
        BuildContext context,
        LoginState state,
      ) {
        if (state is LoginFailure) {
          _onWidgetDidBuild(() {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${state.error}'),
                backgroundColor: Colors.red,
              ),
            );
          });
        }

        return SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                const SizedBox(
                  height: 92,
                ),
                AuthInput(
                    controller: _emailController,
                    hint: "email",
                    validator: qValidator([
                      IsRequired('email is required'),
                      IsEmail(),
                      //  MinLength(3),
                    ]),
                    suffix:
                        Icon(Icons.person_outline, color: MyColors.lightGreen)),
                const SizedBox(
                  height: 36,
                ),
                AuthInput(
                  hint: "password",
                  controller: _passwordController,
                  suffix: GestureDetector(
                      onTap: () {
                        setState(() {
                          obscured = !obscured;
                        });
                      },
                      child: obscured
                          ? Icon(Icons.remove_red_eye_outlined,
                              color: MyColors.lightGreen)
                          : Icon(Icons.visibility_off_outlined,
                              color: MyColors.lightGreen)),
                  onEditingComplete:
                      state is! LoginLoading ? _onLoginButtonPressed : null,
                  obscured: obscured,
                ),
                Row(children: [
                  Spacer(),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return RepositoryProvider.value(
                          value: RepositoryProvider.of<UserRepository>(context),
                          child: ResetPasswordPage(),
                        );
                      }));
                    },
                    child: Text('Forgot password?',
                        style: TextStyle(
                            color: MyColors.lightGreen,
                            decoration: TextDecoration.underline)),
                  ),
                  SizedBox(width: 20),
                ]),
                const SizedBox(
                  height: 92,
                ),
                AuthButton(
                  title: "Login",
                  onTap: state is! LoginLoading ? _onLoginButtonPressed : null,
                  withBackgroundColor: true,
                  isLoading: state is LoginLoading ? true : false,
                ),
                const SizedBox(
                  height: 36,
                ),
                Text("-or-",
                    style: TextStyle(
                        fontSize: 22,
                        color: MyColors.darkBlue,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold)),
                const SizedBox(
                  height: 36,
                ),
                AuthButton(
                  title: "Login with Google",
                  onTap: state is! LoginLoading ? _onGoogleButtonPressed : null,
                  isGoogle: true,
                ),
                const SizedBox(
                  height: 92,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _onWidgetDidBuild(Function callback) {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      callback();
    });
  }

  _onLoginButtonPressed() {
    if (_formKey.currentState!.validate()) {
      FocusScopeNode currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }
      _loginBloc!.add(LoginButtonPressed(
        email: _emailController.text,
        password: _passwordController.text,
      ));
    }

    // Navigator.pop(context);
  }

  _onGoogleButtonPressed() {
    _loginBloc!.add(GoogleButtonPressed());
  }
}

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  LoginBloc? _loginBloc;
  AuthenticationBloc? _authenticationBloc;
  late UserRepository userRepository;
  @override
  void initState() {
    super.initState();

    userRepository = RepositoryProvider.of<UserRepository>(context);

    _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    _loginBloc = LoginBloc(
      userRepository: userRepository,
      authenticationBloc: _authenticationBloc,
    );
  }

  @override
  Widget build(BuildContext context) {
    return HideKeyboardOnTap(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: LoginForm(
          authenticationBloc: _authenticationBloc,
          loginBloc: _loginBloc,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _loginBloc!.close();
    super.dispose();
  }
}

//------------------------------------------------------------
class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Splash Screen'),
      ),
    );
  }
}

//--------------------------------------
class LoadingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
}
