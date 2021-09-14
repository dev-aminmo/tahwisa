import 'package:equatable/equatable.dart';

class SearchFilter extends Equatable {
  final String municipalId;
  final String stateId;
  final double ratingMin;
  final double ratingMax;

  SearchFilter(
      {this.municipalId = '',
      this.stateId = '',
      this.ratingMin = 0,
      this.ratingMax = 5}); //  SearchFilter({this.name, this.id});
  SearchFilter copyWith(
          {String municipalId,
          String stateId,
          double ratingMin,
          double ratingMax}) =>
      SearchFilter(
        municipalId: municipalId ?? this.municipalId,
        stateId: stateId ?? this.stateId,
        ratingMin: ratingMin ?? this.ratingMin,
        ratingMax: ratingMax ?? this.ratingMax,
      );
  @override
  List<Object> get props => [municipalId, stateId, ratingMin, ratingMax];
  @override
  String toString() => "municipal=${this.municipalId}"
      "&state=${this.stateId}"
      "&rating_min=${this.ratingMin}"
      "&rating_max=${this.ratingMax}";
}
