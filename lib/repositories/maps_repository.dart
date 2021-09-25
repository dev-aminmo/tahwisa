import 'package:flutter_native_config/flutter_native_config.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:uuid/uuid.dart';

class MapsRepository {
  GoogleMapsPlaces _places;
  var uuid = Uuid();
  var _sessionToken;
  _init() async {
    final key = await FlutterNativeConfig.getConfig<String>(
        android: 'com.google.android.geo.API_KEY', ios: '');
    this._sessionToken = uuid.v4();
    return _places = GoogleMapsPlaces(apiKey: key);
  }

  Future<dynamic> autocomplete(String pattern) async {
    try {
      if (_places == null) {
        this._places = await _init();
      }
      PlacesAutocompleteResponse response = await _places.autocomplete(pattern,
          sessionToken: _sessionToken,
          language: 'fr',
          region: 'DZ',
          components: [
            Component(Component.country, 'DZ'),
          ]);
      return response.predictions;
    } catch (e) {
      return null;
    }
  }

  Future<dynamic> getLocationByPlaceId(placeId) async {
    try {
      if (_places == null) {
        this._places = await _init();
      }
      var details = await _places.getDetailsByPlaceId(
        placeId,
        sessionToken: _sessionToken,
      );
      return details?.result?.geometry?.location;
    } catch (e) {
      return null;
    }
  }
}
