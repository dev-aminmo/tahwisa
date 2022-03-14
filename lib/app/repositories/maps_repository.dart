import 'package:google_maps_webservice/places.dart';
import 'package:google_maps_webservice/staticmap.dart';
import 'package:uuid/uuid.dart';


class MapsRepository {
  GoogleMapsPlaces? _places;
  var uuid = Uuid();
  var key;
  var _sessionToken;
  _init() async {
    //TODO get key from config file
 /*  this.key = await FlutterNativeConfig.getConfig<String>(
        android: 'com.google.android.geo.API_KEY', ios: '');*/
    this.key = "-1";
    this._sessionToken = uuid.v4();
    return _places = GoogleMapsPlaces(apiKey: key);
  }

  Future<dynamic> autocomplete(String pattern) async {
    try {
      if (_places == null) {
        this._places = await _init();
      }
      PlacesAutocompleteResponse response = await _places!.autocomplete(pattern,
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
      var details = await _places!.getDetailsByPlaceId(
        placeId,
        sessionToken: _sessionToken,
      );
      return details.result.geometry?.location;
    } catch (e) {
      return null;
    }
  }

  Future<String> getStaticMapUrl(lat, lng) async {
    if (key == null) {
      await _init();
    }
    StaticMap mapStatic = StaticMap(key,
        markers: List.from([
          Location(lat: lat, lng: lng),
        ]),
        path: Path(
          enc: 'svh~F`j}uOusC`bD',
          color: 'black',
        ),
        zoom: "17",
        center: "$lat,$lng",
        size: "580x380",
        scale: false);
    return mapStatic.getUrl();
  }
}
