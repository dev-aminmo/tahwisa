import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class WishListEvent extends Equatable {
  const WishListEvent();
  @override
  List<Object> get props => [];
}

class PlaceFetched extends WishListEvent {
  final bool refresh;

  PlaceFetched({this.refresh = false});
}
