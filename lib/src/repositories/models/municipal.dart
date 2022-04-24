import 'package:equatable/equatable.dart';

class Municipal extends Equatable {
  String? name;
  int? id;
  //int state_id;
  Municipal({this.name, this.id //, this.state_id
      });

  Municipal.fromJson(Map<String, dynamic> json) {
    this.id = json['id'];
    this.name = json['name_fr'];
    //  this.state_id = json['state_id'];
  }

  @override
  String toString() {
    return "Municipal : {name:$name,id:$id}";
  }

  @override
  List<Object> get props => [
        id! //, state_id
      ];
}
