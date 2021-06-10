import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

import 'bloc.dart';

class ImagePickerBloc extends Bloc<ImagePickerEvent, ImagePickerState> {
  ImagePickerBloc() : super(ImagePickerInitial());
  List<Asset> _images = [];

  Future<List<File>> _castAssetsToFiles(resultList) async {
    List<File> _fileImageArray = [];
    for (var imageAsset in resultList) {
      var x = await _castAssetToFile(imageAsset);
      _fileImageArray.add(x);
    }
    return _fileImageArray;
  }

  Future<File> _castAssetToFile(imageAsset) async {
    final filePath =
        await FlutterAbsolutePath.getAbsolutePath(imageAsset.identifier);
    var file = File(filePath);
    return file;
  }

  Future<List<File>> _compressFiles(fileImageArray) async {
    List<File> _compressedFileArray = [];
    for (var imageFile in fileImageArray) {
      var file;
      if (imageFile.lengthSync() < 1000000) {
        file = imageFile;
      } else if (imageFile.lengthSync() < 10000000) {
        File compressed = await FlutterNativeImage.compressImage(
          imageFile.path,
          quality: 60,
        );
        file = compressed;
      } else {
        File compressed = await FlutterNativeImage.compressImage(
          imageFile.path,
          quality: 5,
        );
        file = compressed;
      }
      _compressedFileArray.add(file);
    }
    return _compressedFileArray;
  }

  @override
  Stream<ImagePickerState> mapEventToState(
    ImagePickerEvent event,
  ) async* {
    if (event is PickImages) {
      List<Asset> resultList = <Asset>[];
      try {
        resultList = await MultiImagePicker.pickImages(
          maxImages: 10,
          enableCamera: true,
          selectedAssets: _images,
          cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
          materialOptions: MaterialOptions(
            statusBarColor: "#04415d",
            actionBarColor: "#04415d",
            actionBarTitle: "Pick Images",
            allViewTitle: "All Photos",
            useDetailsView: false,
            selectCircleStrokeColor: "#000000",
          ),
        );
        var _fileImageArray = await _castAssetsToFiles(resultList);
        var _compressedImageArray = await _compressFiles(_fileImageArray);

        yield (ImagesPicked(images: _compressedImageArray));
      } on Exception catch (e) {
        yield (ImagePickerFailure(error: e.toString()));
      }
    }
  }
}
