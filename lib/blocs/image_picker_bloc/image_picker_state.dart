import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';

@immutable
abstract class ImagePickerState extends Equatable {
  const ImagePickerState();
  @override
  List<Object> get props => [];
}

class ImagePickerInitial extends ImagePickerState {}

class ImagesPicked extends ImagePickerState {
  final List<File> images;
  final List<Asset> assets;
  ImagesPicked({required this.images, required this.assets});
  @override
  List<Object> get props => [images];
}

class AssetsPicked extends ImagePickerState {
  final List<File> images;
  AssetsPicked({required this.images});
  @override
  List<Object> get props => [images];
}

class ImagePickerFailure extends ImagePickerState {
  final String error;

  const ImagePickerFailure({
    required this.error,
  });

  @override
  List<Object> get props => [error];

  @override
  String toString() => ' { error: $error }';
}
