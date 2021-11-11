import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class RefusePlaceMessage extends Equatable {
  var id;
  var name;
  RefusePlaceMessage({@required this.id, @required this.name});
  RefusePlaceMessage.fromJson(Map<String, dynamic> json) {
    this.id = json['id'];
    this.name = json['name'];
  }

  @override
  List<Object> get props => [id];

  @override
  String toString() => "$id , $name";
}
