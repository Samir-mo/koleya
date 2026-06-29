import 'package:equatable/equatable.dart';
import 'package:gate_buddy/features/search/data/models/search_result_model.dart';

enum SearchStatus { initial, loading, success, failure }

class SearchState extends Equatable {
  final SearchStatus status;
  final List<SearchResultModel> results;
  final String query;
  final String? error;

  const SearchState({
    this.status = SearchStatus.initial,
    this.results = const [],
    this.query = '',
    this.error,
  });

  bool get isInitial => status == SearchStatus.initial;
  bool get isLoading => status == SearchStatus.loading;
  bool get isSuccess => status == SearchStatus.success;
  bool get isFailure => status == SearchStatus.failure;

  SearchState copyWith({
    SearchStatus? status,
    List<SearchResultModel>? results,
    String? query,
    String? error,
    bool clearError = false,
  }) =>
      SearchState(
        status: status ?? this.status,
        results: results ?? this.results,
        query: query ?? this.query,
        error: clearError ? null : (error ?? this.error),
      );

  @override
  List<Object?> get props => [status, results, query, error];
}
