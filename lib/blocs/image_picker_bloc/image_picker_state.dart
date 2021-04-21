import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ImagePickerState extends Equatable {
  const ImagePickerState();
  @override
  List<Object> get props => [];
}

class ImagePickerInitial extends ImagePickerState {}

class ImagesPicked extends ImagePickerState {
  final List<File> images;
  ImagesPicked({@required this.images}) {
    print("${images.length}***************************");
  }
  @override
  List<Object> get props => [images];
}

class ImagePickerFailure extends ImagePickerState {
  final String error;

  const ImagePickerFailure({
    @required this.error,
  });

  @override
  List<Object> get props => [error];

  @override
  String toString() => ' { error: $error }';
}
