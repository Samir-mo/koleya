import 'package:flutter_bloc/flutter_bloc.dart';
import 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(const SearchInitial());

  Future<void> search(String query) async {}
  void clearSearch() => emit(const SearchInitial());
}
