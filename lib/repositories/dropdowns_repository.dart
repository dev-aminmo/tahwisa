import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import 'api/api_endpoints.dart';
import 'models/municipal.dart';
import 'models/state.dart';

class DropDownsRepository {
  Future<List<MyState>> fetchStates() async {
    try {
      var response = await Dio().get(
          Api.states); // options.headers["Authorization"] = "Bearer " + token;;
      var data = response.data;
      List<MyState> states = [];
      for (var jsonState in data['data']) {
        states.add(MyState.fromJson(jsonState));
      }
      return states;
    } catch (e) {
      throw (e);
    }
  }

  Future<List<Municipal>> fetchMunicipales({@required int stateId}) async {
    try {
      var response = await Dio().get(
        Api.municipales + "/$stateId",
      );
      var data = response.data;
      List<Municipal> municipales = [];
      for (var jsonState in data['data']) {
        municipales.add(Municipal.fromJson(jsonState));
      }
      return municipales;
    } catch (e) {
      throw (e);
    }
  }
}
