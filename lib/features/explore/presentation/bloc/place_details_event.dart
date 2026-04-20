import 'package:equatable/equatable.dart';

abstract class PlaceDetailsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class PlaceDetailsFetchRequested extends PlaceDetailsEvent {
  final String placeId;

  PlaceDetailsFetchRequested(this.placeId);

  @override
  List<Object?> get props => [placeId];
}
