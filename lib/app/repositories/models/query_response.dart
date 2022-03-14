import 'package:tahwisa/app/repositories/models/place.dart';

import 'SearchFilter.dart';

class QueryResponse {
  final List<Place> results;
  final int? numPages;
  final int? numResults;
  final SearchFilter? filter;

  const QueryResponse({
    required this.results,
    required this.numPages,
    required this.numResults,
    this.filter,
  });
}
