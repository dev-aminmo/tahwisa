import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';

import 'bloc.dart';

class ImagePickerBloc extends Bloc<ImagePickerEvent, ImagePickerState> {
  ImagePickerBloc() : super(ImagePickerInitial());

  Future<List<File>> _castAssetsToFiles(resultList) async {
    List<File> _fileImageArray = [];
    for (var assetImage in resultList) {
      var fileImage = await _castAssetToFile(assetImage);
      _fileImageArray.add(fileImage);
    }
    return _fileImageArray;
  }

  Future<File> _castAssetToFile(Asset imageAsset) async {
/*    final filePath =
        await FlutterAbsolutePath(imageAsset.identifier!);
    var file = File(filePath);
    return file;*/
    return File('-1');
  }

  @override
  Stream<ImagePickerState> mapEventToState(
    ImagePickerEvent event,
  ) async* {
    if (event is PickImages) {
      List<Asset> resultList = <Asset>[];
      try {
        resultList = await MultiImagePicker.pickImages(
          maxImages: 8,
          enableCamera: true,
          cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
          materialOptions: MaterialOptions(
            statusBarColor: "#04415d",
            actionBarColor: "#04415d",
            actionBarTitle: "Pick Images",
            allViewTitle: "All Photos",
            useDetailsView: false,
            selectCircleStrokeColor: "#000000",
            autoCloseOnSelectionLimit: true,
            //TODO translate
            //selectionLimitReachedText:
          ),
        );
        var _fileImageArray = await _castAssetsToFiles(resultList);
        yield (ImagesPicked(images: _fileImageArray, assets: resultList));
      } on Exception catch (e) {
        yield (ImagePickerFailure(error: e.toString()));
      }
    }
  }
}
