import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:tahwisa/repositories/models/tag.dart';
import 'package:tahwisa/repositories/tag_repository.dart';

part 'top_tags_state.dart';

class TopTagsCubit extends Cubit<TopTagsState> {
  final TagRepository repository;

  TopTagsCubit({required this.repository}) : super(TopTagsInitial()) {
    getTopTags();
  }

  void getTopTags() async {
    try {
      emit(TagsLoadingState());
      final tags = await repository.getTopTags();
      emit(TagsLoadedState(tags));
    } catch (e) {
      emit(ErrorState());
    }
  }
}
