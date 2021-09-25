import 'package:flutter_native_config/flutter_native_config.dart';
import 'package:google_maps_webservice/places.dart';

class MapsRepository {
  GoogleMapsPlaces _places;
  _init() async {
    final key = await FlutterNativeConfig.getConfig<String>(
        android: 'com.google.android.geo.API_KEY', ios: '');
    return _places = GoogleMapsPlaces(apiKey: key);
  }

  Future<dynamic> autocomplete(String pattern) async {
    try {
      if (_places == null) {
        print("places is null mother fucker");
        this._places = await _init();
      }
      print("places not null mother Fucker ${_places != null} ");
      var sessionToken = 'sessionToken';
      PlacesAutocompleteResponse response = await _places.autocomplete(pattern,
          sessionToken: sessionToken,
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
      var sessionToken = 'sessionToken';
      var details = await _places.getDetailsByPlaceId(
        placeId,
        sessionToken: sessionToken,
      );
      return details?.result?.geometry?.location;
    } catch (e) {
      return null;
    }
  }
}
