import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:tahwisa/myapp.dart';
import 'package:tahwisa/src/utilities/simple_bloc_delegate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = SimpleBlocDelegate();
  await Firebase.initializeApp();
  await dotenv.load(fileName: ".env");
  runApp(MyApp());
}
