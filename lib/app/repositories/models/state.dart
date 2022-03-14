import 'package:equatable/equatable.dart';

class MyState extends Equatable {
  String? name;
  int? id;

  MyState({this.name, this.id});

  MyState.fromJson(Map<String, dynamic> json) {
    this.id = json['id'];
    this.name = json['name_fr'];
  }

  @override
  List<Object> get props => [name!, id!];
}
