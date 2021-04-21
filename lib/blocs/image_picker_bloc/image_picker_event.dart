import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ImagePickerEvent extends Equatable {
  const ImagePickerEvent();
  @override
  List<Object> get props => [];
}

class PickImages extends ImagePickerEvent {}
