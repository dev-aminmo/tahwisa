part of 'top_tags_cubit.dart';

abstract class TopTagsState extends Equatable {
  const TopTagsState();
  @override
  List<Object> get props => [];
}

class TopTagsInitial extends TopTagsState {}

class TagsLoadingState extends TopTagsState {}

class TagsLoadedState extends TopTagsState {
  TagsLoadedState(this.tags);

  final List<Tag> tags;

  @override
  List<Object> get props => [tags];
}

class ErrorState extends TopTagsState {}
