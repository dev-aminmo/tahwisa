import 'package:flutter/foundation.dart';

class RefusePlaceMessage {
  var id;
  var name;
  RefusePlaceMessage({@required this.id, @required this.name});
  RefusePlaceMessage.fromJson(Map<String, dynamic> json) {
    this.id = json['id'];
    this.name = json['name'];
  }
}
