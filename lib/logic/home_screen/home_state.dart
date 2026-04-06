import 'package:equatable/equatable.dart';

import '../../model/groub_model.dart';

abstract class HomeState extends Equatable {
  const HomeState();
  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<GroupModel> groups;
  const HomeLoaded({required this.groups});
  @override
  List<Object?> get props => [groups];
}

class UpdateUserNameState extends HomeState {
  final String? name;
  const UpdateUserNameState({required this.name});
  @override
  List<Object?> get props => [name];
}

class HomeSuccess extends HomeState {
  final String message;
  final List<GroupModel> groups;
  const HomeSuccess({required this.message, required this.groups});
  @override
  List<Object?> get props => [message, groups]; // ضيفنا المجموعات هنا برضه عشان ميفقدش الحالة
}

class HomeError extends HomeState {
  final String message;
  final List<GroupModel> groups;
  const HomeError({required this.message, required this.groups});
  @override
  List<Object?> get props => [message, groups];
}
