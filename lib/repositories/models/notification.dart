class Notification {
  var id;
  var notificationId;
  var title;
  var body;
  var data;
  var createdAt;
  var updatedAt;

  Notification({this.title, this.body, this.data});
  Notification.fromJson(Map<String, dynamic> json) {
    this.id = json['id'];
    this.notificationId = json['notification_id'];
    this.title = json['title'];
    this.body = json['body'];
    this.data = json['description'];
    this.createdAt = json['created_at'];
    this.updatedAt = json['updated_at'];
  }
  @override
  String toString() => " title: $title,body: $body , data: $data";
}
