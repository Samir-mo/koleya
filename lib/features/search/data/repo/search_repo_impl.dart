import '../remote/search_remote_ds.dart';
import 'search_repo.dart';

class SearchRepoImpl implements SearchRepo {
  final SearchRemoteDs remoteDs;
  SearchRepoImpl({required this.remoteDs});

  @override
  Future<dynamic> search(String query) => remoteDs.search(query);
}
