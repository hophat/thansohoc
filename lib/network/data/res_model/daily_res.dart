class DailyRes {
  int? id;
  String? card;
  String? category;
  String? career;
  String? love;
  String? finance;
  String? image;
  String? image2;
  DateTime? createdAt;
  int? userId;

  DailyRes(
      {this.id,
        this.card,
        this.category,
        this.career,
        this.love,
        this.finance,
        this.image,
        this.image2,
        this.createdAt,
        this.userId});

  DailyRes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    card = json['card'];
    category = json['category'];
    career = json['career'];
    love = json['love'];
    finance = json['finance'];
    image = json['image'];
    image2 = json['image2'];
    createdAt = json['createdAt'] != null ? DateTime.tryParse(json['createdAt'].toString())?.toLocal() : null;
    userId = json['userId'];
  }
}