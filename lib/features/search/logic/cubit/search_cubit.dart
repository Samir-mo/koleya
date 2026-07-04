import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/errors/exceptions.dart';
import '../../data/models/search_result_model.dart';
import '../../data/repo/search_repo.dart';
import 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final SearchRepo repo;
  Timer? _debounce;

  SearchCubit({required this.repo}) : super(const SearchState());

  void onQueryChanged(String query) {
    _debounce?.cancel();
    if (query.trim().isEmpty) {
      emit(const SearchState());
      return;
    }
    emit(
      state.copyWith(
        status: SearchStatus.loading,
        query: query,
        clearError: true,
      ),
    );
    _debounce = Timer(const Duration(milliseconds: 500), () => _search(query));
  }

  Future<void> _search(String query) async {
    try {
      final raw = await repo.search(query.trim());
      final results = SearchResultModel.fromResponse(raw);
      emit(
        state.copyWith(
          status: SearchStatus.success,
          results: results,
          query: query,
        ),
      );
    } on AppException catch (e) {
      emit(state.copyWith(status: SearchStatus.failure, error: e.message));
    } catch (e) {
      emit(state.copyWith(status: SearchStatus.failure, error: e.toString()));
    }
  }

  void clear() {
    _debounce?.cancel();
    emit(const SearchState());
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
