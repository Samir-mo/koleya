import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import '../data/repositories/search_repository.dart';
import 'search_state.dart';

/// SearchCubit — مسئول عن البحث داخل (Flights / Services / Places ...)
class SearchCubit extends Cubit<SearchState> {
  final SearchRepository _searchRepository;

  SearchCubit(this._searchRepository) : super(SearchInitial());

  /// تنفيذ عملية البحث
  Future<void> performSearch(String query) async {
    if (query.isEmpty) return;
    emit(SearchLoading());
    try {
      final Response response = await _searchRepository.search(
        query: query,
        types: ["flights"], // حالياً بنبحث عن رحلات فقط
      );
      final results = response.data["results"] ?? [];
      emit(SearchLoaded(results));
    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }
}