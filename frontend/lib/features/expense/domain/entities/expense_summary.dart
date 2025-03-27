class ExpenseSummary {
  Id? iId;
  int? totalAmount;
  int? count;

  ExpenseSummary({this.iId, this.totalAmount, this.count});

  ExpenseSummary.fromJson(Map<String, dynamic> json) {
    iId = json['_id'] != null ? Id.fromJson(json['_id']) : null;
    totalAmount = json['totalAmount'];
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (iId != null) {
      data['_id'] = iId!.toJson();
    }
    data['totalAmount'] = totalAmount;
    data['count'] = count;
    return data;
  }
}

class Id {
  int? year;
  int? month;
  int? day;
  String? category;

  Id({this.year, this.month, this.day, this.category});

  Id.fromJson(Map<String, dynamic> json) {
    year = json['year'];
    month = json['month'];
    day = json['day'];
    category = json['category'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['year'] = year;
    data['month'] = month;
    data['day'] = day;
    data['category'] = category;
    return data;
  }
}
