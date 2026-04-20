import 'package:equatable/equatable.dart';

abstract class ExploreEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ExploreFetchRequested extends ExploreEvent {}

class ExploreRefreshRequested extends ExploreEvent {}
