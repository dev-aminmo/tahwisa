import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queen_validators/queen_validators.dart';
import 'package:tahwisa/blocs/reset_password_bloc/bloc.dart';
import 'package:tahwisa/repositories/user_repository.dart';
import 'package:tahwisa/screens/auth/widgets/auth_button.dart';
import 'package:tahwisa/screens/auth/widgets/auth_input.dart';
import 'package:tahwisa/style/my_colors.dart';

class ResetPasswordPage extends StatefulWidget {
  @override
  State<ResetPasswordPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<ResetPasswordPage> {
  UserRepository userRepository;
  var _resetPasswordBloc;
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    userRepository = RepositoryProvider.of<UserRepository>(context);
    _resetPasswordBloc = ResetPasswordBloc(userRepository: userRepository);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocBuilder<ResetPasswordBloc, ResetPasswordState>(
      //  create: _loginBloc,
      bloc: _resetPasswordBloc,
      // listener: (ctx, state) {},
      builder: (
        BuildContext context,
        ResetPasswordState state,
      ) {
        if (state is ResetPasswordFailure) {
          _onWidgetDidBuild(() {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text('${state.error}'),
                backgroundColor: Colors.red,
              ),
            );
          });
        }
        if (state is ResetPasswordSuccess) {
          _onWidgetDidBuild(() {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text('We have emailed your password reset link!'),
                backgroundColor: Colors.green,
              ),
            );
          });
        }

        return Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Spacer(
                flex: 5,
              ),
              AuthInput(
                  controller: _emailController,
                  hint: "email",
                  validator: qValidator([
                    // IsRequired(msg: 'email is required'),
                    // IsEmail(),
                    //  MinLength(5),
                  ]),
                  suffix:
                      Icon(Icons.person_outline, color: MyColors.lightGreen)),
              Spacer(
                flex: 5,
              ),
              AuthButton(
                title: "Login",
                onTap: state is! ResetPasswordLoading
                    ? _onLoginButtonPressed
                    : null,
                withBackgroundColor: true,
                isLoading: state is ResetPasswordLoading ? true : false,
              ),
              Spacer(),
              Spacer(
                flex: 5,
              ),
            ],
          ),
        );
      },
    ));
  }

  void _onWidgetDidBuild(Function callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callback();
    });
  }

  _onLoginButtonPressed() {
    if (_formKey.currentState.validate())
      _resetPasswordBloc.add(ResetPasswordButtonPressed(
        email: _emailController.text,
      ));
    // Navigator.pop(context);
  }

  @override
  void dispose() {
    _resetPasswordBloc.close();
    super.dispose();
  }
}
