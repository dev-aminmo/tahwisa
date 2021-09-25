import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tahwisa/repositories/user_repository.dart';
import 'package:tahwisa/screens/profile/widgets/hide_keyboard_ontap.dart';
import 'package:tahwisa/style/my_colors.dart';

import './widgets/auth_button.dart';
import './widgets/auth_input.dart';
import '../../blocs/authentication_bloc/bloc.dart';
import '../../blocs/signup_bloc/bloc.dart';

class SignUPScreen extends StatefulWidget {
  @override
  _SignUPScreenState createState() => _SignUPScreenState();
}

class _SignUPScreenState extends State<SignUPScreen> {
  SignupBloc _signupBloc;
  AuthenticationBloc _authenticationBloc;
  UserRepository userRepository;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool obscured = true;
  @override
  void initState() {
    super.initState();
    userRepository = RepositoryProvider.of<UserRepository>(context);

    _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    _signupBloc = SignupBloc(
      userRepository: userRepository,
      authenticationBloc: _authenticationBloc,
    );
  }

  @override
  void dispose() {
    _signupBloc.close();
    super.dispose();
  }

  void _onWidgetDidBuild(Function callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callback();
    });
  }

  _onSignupButtonPressed() {
    if (_formKey.currentState.validate())
      _signupBloc.add(SignupButtonPressed(
        username: _usernameController.text,
        email: _emailController.text,
        password: _passwordController.text,
      ));
  }

  _onGoogleButtonPressed() {
    _signupBloc.add(GoogleButtonPressed());
  }

  @override
  Widget build(BuildContext context) {
    return HideKeyboardOnTap(
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: MyColors.white,
            body: BlocBuilder<SignupBloc, SignupState>(
              cubit: _signupBloc,
              builder: (
                BuildContext context,
                SignupState state,
              ) {
                if (state is SignupFailure) {
                  _onWidgetDidBuild(() {
                    Scaffold.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${state.error}'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  });
                }
                return Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Spacer(flex: 3),
                        AuthInput(
                            controller: _usernameController,
                            hint: "username",
                            suffix: Icon(Icons.person_outline,
                                color: MyColors.lightGreen)),
                        Spacer(),
                        AuthInput(
                            controller: _emailController,
                            hint: "email",
                            suffix: Icon(Icons.mail_outlined,
                                color: MyColors.lightGreen)),
                        Spacer(),
                        AuthInput(
                          controller: _passwordController,
                          hint: "password",
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
                          obscured: obscured,
                        ),
                        Spacer(
                          flex: 5,
                        ),
                        AuthButton(
                          title: "Sign up",
                          withBackgroundColor: true,
                          onTap: state is! SignupLoading
                              ? _onSignupButtonPressed
                              : null,
                          isLoading: state is SignupLoading ? true : false,
                        ),
                        Spacer(),
                        Text("-or-",
                            style: TextStyle(
                                fontSize: 22,
                                color: MyColors.darkBlue,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.bold)),
                        Spacer(),
                        AuthButton(
                          title: "Sign up with Google",
                          onTap: state is! SignupLoading
                              ? _onGoogleButtonPressed
                              : null,
                          isGoogle: true,
                        ),
                        Spacer(
                          flex: 5,
                        )
                      ],
                    ));
              },
            )));
  }
}
