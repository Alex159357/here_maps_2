

class LocationSearchState{

  String query;

  bool get isQuery => query.isNotEmpty;

  LocationSearchState({this.query = ""});

  LocationSearchState copyWith({required String? query }) => LocationSearchState(query: query ?? this.query);

}