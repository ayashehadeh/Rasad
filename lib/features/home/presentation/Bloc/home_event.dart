import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Fired once when the screen mounts — loads both trending and nearby in parallel.
class HomeFetchRequested extends HomeEvent {}

/// Fired when the user pulls to refresh.
class HomeRefreshRequested extends HomeEvent {}
