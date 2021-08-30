part of 'top_tags_cubit.dart';

abstract class TopTagsState extends Equatable {
  const TopTagsState();
}

class TopTagsInitial extends TopTagsState {
  @override
  List<Object> get props => [];
}

class LoadingState extends TopTagsState {
  @override
  List<Object> get props => [];
}

class LoadedState extends TopTagsState {
  LoadedState(this.tags);

  final List<Tag> tags;

  @override
  List<Object> get props => [tags];
}

class ErrorState extends TopTagsState {
  @override
  List<Object> get props => [];
}
