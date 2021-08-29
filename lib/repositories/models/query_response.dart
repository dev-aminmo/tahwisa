import 'package:meta/meta.dart';
import 'package:tahwisa/repositories/models/place.dart';

class QueryResponse {
  final List<Place> results;
  final int numPages;
  final int numResults;

  const QueryResponse({
    @required this.results,
    @required this.numPages,
    @required this.numResults,
  });
}
