import 'package:donut/screen/main_screen.dart';

class TokenResponse {
  String accessToken;
  String refreshToken;

  TokenResponse({required this.accessToken, required this.refreshToken});

  factory TokenResponse.fromJson(Map<String, dynamic> json) {
    return TokenResponse(
        accessToken: json["accessToken"],
        refreshToken: json["refreshToken"]
    );
  }
}

class UserResponse {
  int userId;
  String name;
  String profileUrl;
  bool isComment, isFriend;

  UserResponse({required this.userId, required this.name, required this.profileUrl, required this.isFriend, required this.isComment});

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
        userId: json["userId"],
        name: json["name"],
        profileUrl: json["profileUrl"],
        isComment: json['isNotificationComment'],
        isFriend: json['isNotificationFriend']
    );
  }
}

class DoneResponse {
  int doneId, kakaoId;
  String name, title, content, writeAt;
  bool isPublic;

  DoneResponse({required this.doneId, required this.kakaoId, required this.writeAt, required this.name, required this.title, required this.content, required this.isPublic});

  factory DoneResponse.fromJson(Map<String, dynamic> json) {
    return DoneResponse(
      doneId: json['doneId'],
      name: json['userName'],
      kakaoId: json['kakaoId'],
      title: json['title'],
      writeAt: json['writeAt'],
      content: json['content'],
      isPublic: json['isPublic']
    );
  }
}

class RecommentResponse {
  int recommentId, commentId, userId;
  String nickName, comment, writeAt, profileUrl;
  bool isPublic;

  RecommentResponse({required this.recommentId, required this.commentId, required this.userId, required this.nickName, required this.comment, required this.writeAt, required this.isPublic, required this.profileUrl});

  factory RecommentResponse.fromJson(Map<String, dynamic> json) {
    return RecommentResponse(
      recommentId: json["reCommentId"],
      commentId: json["commentId"],
      userId: json["userId"],
      nickName: json["nickName"],
      comment: json["comment"],
      writeAt: json["writeAt"],
      isPublic: json["isPublic"],
      profileUrl: json["profileUrl"]
    );
  }
}

class CommentResponse {
  int commentId, doneId, userId;
  String nickName, comment, writeAt, profileUrl;
  bool isPublic;
  List<RecommentResponse> recommentResponses;

  CommentResponse({required this.commentId, required this.doneId, required this.userId, required this.nickName, required this.comment, required this.writeAt, required this.isPublic, required this.recommentResponses, required this.profileUrl});

  factory CommentResponse.fromJson(Map<String, dynamic> json) {
    List<RecommentResponse> recomments = (json["reComment"] as List).map((e) => RecommentResponse.fromJson(e)).toList();

    print(recomments);

    return CommentResponse(
        commentId: json["commentId"],
        doneId: json["doneId"],
        userId: json["userId"],
        nickName: json["nickName"],
        comment: json["comment"],
        writeAt: json["writeAt"],
        profileUrl: json["profileUrl"],
        isPublic: json["isPublic"],
        recommentResponses: recomments
    );
  }
}