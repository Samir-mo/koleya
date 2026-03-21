import 'package:equatable/equatable.dart';
import '../../data/models/place_model.dart';

abstract class PlacesState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PlacesInitial extends PlacesState {}

class PlacesLoading extends PlacesState {}

class PlacesLoaded extends PlacesState {
  final List<PlaceModel> places;
  PlacesLoaded(this.places); // ← بدون const

  @override
  List<Object?> get props => [places];
}

class PlaceDetailsLoaded extends PlacesState {
  final PlaceModel place;
  PlaceDetailsLoaded(this.place); // ← بدون const

  @override
  List<Object?> get props => [place];
}

class PlacesError extends PlacesState {
  final String message;
  PlacesError(this.message); // ← بدون const

  @override
  List<Object?> get props => [message];
}