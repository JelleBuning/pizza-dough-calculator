class PageState {
  int? state;
  DateTime? ends;

  PageState({this.state, this.ends});

  PageState.fromJson(Map<String, dynamic> json) {
    state = json['state'];
    state = json['ends'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['state'] = state;
    data['ends'] = ends;
    return data;
  }
}
