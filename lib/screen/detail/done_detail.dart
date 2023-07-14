import 'package:comment_tree/comment_tree.dart';
import 'package:donut/server/apis.dart';
import 'package:donut/server/response.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WriteDonePage extends StatefulWidget {
  @override
  _WriteDoneState createState() => _WriteDoneState();
}

class _WriteDoneState extends State<WriteDonePage> {
  final _editTitleController = TextEditingController();
  final _editContentController = TextEditingController();
  bool isPublic = false, err = false;

  DoneServerApi doneServerApi = DoneServerApi();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xffffffff),
        toolbarHeight: 60,
        centerTitle: false,
        title: const Text(
          "Write Done",
          style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 26,
              color: Color(0xff2C2C2C)
          ),
        ),
        actions: [
          Container(
              child: IconButton(
                  onPressed: () {
                    String title = _editTitleController.text;
                    String content = _editContentController.text;

                    if(title == "" || content == "") {
                      Fluttertoast.showToast(msg: "제목 혹은 내용을 입력해주세요!");
                      return;
                    }

                    doneServerApi.writeDone(title, content, isPublic, context);
                  },
                  icon: Icon(Icons.add_rounded),
                  iconSize: 40,
                  color: const Color(0xff2c2c2c)
              )
          ),
        ],
        titleSpacing: 15,
        leading: Container(
            child: Builder(
                builder: (context) => Container(
                  margin: const EdgeInsets.only(left: 10),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_rounded),
                    onPressed: () => Navigator.of(context).pop(),
                    color: const Color(0xff2C2C2C),
                    iconSize: 35,
                  ),
                )
            )
        ),
      ),
      body: SingleChildScrollView(
        child: Column (
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                width: width * 0.871,
                height: 45,
                margin: EdgeInsets.only(top: height * 0.05),
                child: CupertinoTextField(
                  textAlignVertical: TextAlignVertical.top,
                  textInputAction: TextInputAction.next,
                  maxLines: 1,
                  textAlign: TextAlign.start,
                  controller: _editTitleController,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    color: Color(0xffF4F4F4),
                  ),
                  onChanged: (val) {
                    setState(() {
                      err = false;
                    });
                  },
                  placeholder: '제목을 입력하세요',
                  placeholderStyle: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: Color(0xffD1D1D1)
                  ),
                  padding: const EdgeInsets.only(left: 20, top: 13),
                )
            ),
            Container(
                width: width * 0.871,
                height: height * 0.19,
                margin: EdgeInsets.only(top: 20),
                child: CupertinoTextField(
                  textAlignVertical: TextAlignVertical.top,
                  textInputAction: TextInputAction.newline,
                  maxLines: 20,
                  textAlign: TextAlign.start,
                  controller: _editContentController,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    color: Color(0xffF4F4F4),
                  ),
                  onChanged: (val) {
                    setState(() {
                      err = false;
                    });
                  },
                  placeholder: '내용을 입력하세요',
                  placeholderStyle: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: Color(0xffD1D1D1)
                  ),
                  padding: const EdgeInsets.only(left: 20, top: 20),
                )
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 10),
                    child: const Text(
                      '공개여부',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: Color(0xff2c2c2c)
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 10),
                    child: Checkbox(
                      focusColor: const Color(0xffD4B886),
                      activeColor: const Color(0xffD4B886),
                      value: isPublic,
                      onChanged: (bool? value) {
                        setState(() {
                          isPublic = value ?? false;
                        });
                      },
                    )
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UpdateDonePage extends StatefulWidget {
  int doneId;
  String title, content;

  UpdateDonePage(this.doneId, this.title, this.content);

  @override
  _UpdateDoneState createState() => _UpdateDoneState(doneId, title, content);
}

class _UpdateDoneState extends State<UpdateDonePage> {
  final _editTitleController = TextEditingController();
  final _editContentController = TextEditingController();
  bool isPublic = false, err = false;

  int doneId;
  String title, content;

  _UpdateDoneState(this.doneId, this.title, this.content);

  DoneServerApi doneServerApi = DoneServerApi();

  @override
  void initState() {
    _editTitleController.text = title;
    _editContentController.text = content;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xffffffff),
        toolbarHeight: 60,
        centerTitle: false,
        title: const Text(
          "Update Done",
          style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 26,
              color: Color(0xff2C2C2C)
          ),
        ),
        actions: [
          Container(
              child: IconButton(
                  onPressed: () {
                    String title = _editTitleController.text;
                    String content = _editContentController.text;

                    doneServerApi.updateDone(doneId, title, content,context);
                  },
                  icon: Icon(Icons.check),
                  iconSize: 40,
                  color: const Color(0xff2c2c2c)
              )
          ),
        ],
        titleSpacing: 15,
        leading: Container(
            child: Builder(
                builder: (context) => Container(
                  margin: const EdgeInsets.only(left: 10),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_rounded),
                    onPressed: () => Navigator.of(context).pop(),
                    color: const Color(0xff2C2C2C),
                    iconSize: 35,
                  ),
                )
            )
        ),
      ),
      body: SingleChildScrollView(
        child: Column (
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    width: width * 0.871,
                    height: 45,
                    margin: EdgeInsets.only(top: height * 0.05),
                    child: CupertinoTextField(
                      textAlignVertical: TextAlignVertical.top,
                      textInputAction: TextInputAction.next,
                      maxLines: 1,
                      textAlign: TextAlign.start,
                      controller: _editTitleController,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        color: Color(0xffF4F4F4),
                      ),
                      onChanged: (val) {
                        setState(() {
                          err = false;
                        });
                      },
                      placeholder: '기존제목 : $title',
                      placeholderStyle: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: Color(0xffD1D1D1)
                      ),
                      padding: const EdgeInsets.only(left: 20, top: 13),
                    )
                ),
              ],
            ),
            Container(
                width: width * 0.871,
                height: height * 0.19,
                margin: EdgeInsets.only(top: 20),
                child: CupertinoTextField(
                  textAlignVertical: TextAlignVertical.top,
                  textInputAction: TextInputAction.newline,
                  maxLines: 20,
                  textAlign: TextAlign.start,
                  controller: _editContentController,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    color: Color(0xffF4F4F4),
                  ),
                  onChanged: (val) {
                    setState(() {
                      err = false;
                    });
                  },
                  placeholder: '기존 내용 : $content',
                  placeholderStyle: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: Color(0xffD1D1D1)
                  ),
                  padding: const EdgeInsets.only(left: 20, top: 20),
                )
            ),
          ],
        ),
      ),
    );
  }
}

class ReadDoneDetail extends StatefulWidget {
  String title, content;
  bool isPublic;
  int doneId;

  ReadDoneDetail(this.title, this.isPublic, this.content, this.doneId);

  @override
  _ReadDoneState createState() => _ReadDoneState(title, isPublic, content, doneId);
}

class _ReadDoneState extends State<ReadDoneDetail> {
  String title, content;
  int doneId;
  bool isPublic;

  String hint = "input your comment", recomment = "";
  int commentId = -1, recommentId = -1, mine = -1;
  bool isComment = true;
  bool isUpdated = false;
  bool isUpdateComment = true;

  late UserResponse userResponse;

  var commentApi = CommentServerApi();
  var userApi = UserServerApi();
  var _editCommentController = TextEditingController();

  List<CommentResponse> commentResponse = [];

  _ReadDoneState(this.title, this.isPublic, this.content, this.doneId);
  RefreshController _refreshController = RefreshController(initialRefresh: false);

  @override
  void initState() {
    userApi.getMyInfo().then((value) => userResponse = value);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.white,
        toolbarHeight: 60,
        centerTitle: true,
        title: Text(
          title,
          style: const TextStyle(
              fontFamily: 'NotoSansKR',
              fontWeight: FontWeight.w700,
              fontSize: 20,
              color: Color(0xff2c2c2c)
          ),
        ),
        leading: Container(
            child: Builder(
                builder: (context) => Container(
                  margin: const EdgeInsets.only(left: 10),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_rounded),
                    onPressed: () => Navigator.of(context).pop(),
                    color: const Color(0xff2C2C2C),
                    iconSize: 35,
                  ),
                )
            )
        ),
      ),
    body: SingleChildScrollView(
    child: Column (
        children: [
          Row(
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 30, left: 20),
                      child: const Text(
                        '공개여부',
                        style: TextStyle(
                            fontFamily: 'NotoSansKR',
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                            color: Color(0xff2C2C2C)
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 30, right: 20),
                    child: Text(
                      isPublic ? '공개' : '비공개',
                      style: const TextStyle(
                          fontFamily: 'NotoSansKR',
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                          color: Color(0xff2c2c2c)
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 30, left: 20),
                      child: const Text(
                        '내용',
                        style: TextStyle(
                            fontFamily: 'NotoSansKR',
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                            color: Color(0xff2C2C2C)
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 10),
              width: width * 0.871,
              padding: const EdgeInsets.all(10),
              child: Text(
                content,
                style: const TextStyle(
                    fontFamily: 'NotoSansKR',
                    fontWeight: FontWeight.normal,
                    fontSize: 18,
                    color: Color(0xff2C2C2C)
                ),
              ),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                color: Color(0xffF4F4F4),
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 20, top: 20),
                      child: const Text(
                        '댓글 작성',
                        style: TextStyle(
                            fontFamily: 'NotoSansKR',
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                            color: Color(0xff2C2C2C)
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 10),
                    width: width * 0.65,
                    child: TextField(
                      controller: _editCommentController,
                      decoration: InputDecoration(
                          hintText: hint,
                          contentPadding: const EdgeInsets.only(left: 10, right: 10),
                          hintStyle: const TextStyle(
                              fontFamily: 'NotoSansKR',
                              fontWeight: FontWeight.normal,
                              fontSize: 18,
                              color: Colors.grey
                          ),
                          border: InputBorder.none
                      ),
                      textInputAction: TextInputAction.newline,
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        setState(() {
                          var comment = _editCommentController.text;
                          if(comment.isEmpty) {
                            Fluttertoast.showToast(msg: "댓글을 작성해주세요");
                            return;
                          }

                          if(isUpdated) {
                            if(isUpdateComment) {
                              if(commentId == -1) {
                                Fluttertoast.showToast(msg: "수정할 댓글을 선택해주세요");
                                return;
                              }

                              commentApi.updateComment(commentId, comment);
                            }else {
                              if(recommentId == -1) {
                                Fluttertoast.showToast(msg: "수정할 대댓글을 선택해주세요");
                                return;
                              }

                              commentApi.updateRecomment(recommentId, comment);
                            }
                          }else {
                            if(isComment) {
                              commentApi.writeComment(comment, doneId, true);
                            }else if(isComment == false){
                              if(commentId == -1) {
                                Fluttertoast.showToast(msg: "답글을 달 댓글을 선택해주세요");
                                return;
                              }

                              commentApi.writeRecomment(comment, commentId, true);
                            }
                          }

                          print(comment);

                          setState(() {
                            _editCommentController.text = "";
                            isUpdateComment = true;
                            isComment = true;
                            isUpdated = false;
                            recomment = "";
                            commentId = -1;
                            hint = "input your comment";
                          });
                        });
                      },
                      icon: const Icon(Icons.send, size: 30)
                  ),
                  Visibility(
                    visible: !isComment || isUpdated,
                    child: Container(
                      width: 60,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: RaisedButton(
                        elevation: 0,
                        color: Colors.white70,
                        child: const Text(
                          "취소",
                          style: TextStyle(
                              fontFamily: 'NotoSansKR',
                              fontWeight: FontWeight.normal,
                              fontSize: 13,
                              color: Colors.black
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            isComment = true;
                            isUpdated = false;
                            isUpdateComment = true;
                            commentId = -1;
                            recomment = "";
                            hint = "input your comment";
                          });
                        },
                      ),
                    ),
                  )
                ],
              )
          ),
          Row(
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 20),
                      child: const Text(
                        '댓글',
                        style: TextStyle(
                            fontFamily: 'NotoSansKR',
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                            color: Color(0xff2C2C2C)
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          Container(
            height: height * 0.5,
            width: width * 0.9,
            margin: const EdgeInsets.only(top: 10),
            child: FutureBuilder<List<CommentResponse>>(
              future: commentApi.getAllComment(doneId),
              builder: (BuildContext context, AsyncSnapshot<List<CommentResponse>> snapshot) {
                if(snapshot.hasData == false) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }else {
                  commentResponse = snapshot.data ?? [];
                  return SmartRefresher(
                    controller: _refreshController,
                    onRefresh: () {
                        setState(() { });
                        _refreshController.refreshCompleted();
                    },
                    enablePullDown: true,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: commentResponse.length,
                      itemBuilder: (BuildContext context, int index) {
                        print(commentResponse[index].nickName);
                        return Container(
                          margin: EdgeInsets.only(top: 10),
                          child: CommentTreeWidget<CommentResponse, RecommentResponse> (
                            commentResponse[index],
                            commentResponse[index].recommentResponses,
                            treeThemeData: const TreeThemeData(
                                lineColor: Color(0xffD4B886),
                                lineWidth: 1
                            ),
                            contentRoot: (context, data) {
                              return Container(
                                width: width * 0.65,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: const Color(0xffD4B886)
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                            child: Container(
                                              margin: EdgeInsets.only(left: 20),
                                              child: Text(
                                                commentResponse[index].nickName,
                                                style: const TextStyle(
                                                    fontFamily: 'NotoSansKR',
                                                    fontWeight: FontWeight.normal,
                                                    fontSize: 18,
                                                    color: Colors.white
                                                ),
                                              ),
                                              alignment: Alignment.topLeft,
                                            )
                                        ),
                                        Expanded(
                                            child: Container(
                                              margin: const EdgeInsets.only(right: 10),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  IconButton(
                                                    onPressed: () {
                                                      if(!isComment) {
                                                        Fluttertoast.showToast(msg: "답변을 작성해주세요");
                                                        return;
                                                      }

                                                      if(data.userId != userResponse.userId) {
                                                        Fluttertoast.showToast(msg: "자신의 댓글이 아닙니다");
                                                        return;
                                                      }

                                                      setState(() {
                                                        isUpdated = true;
                                                        isUpdateComment = true;
                                                        hint = "updated comment";
                                                        _editCommentController.text = data.comment;
                                                        commentId = data.commentId;
                                                      });
                                                    },
                                                    icon: const Icon(Icons.edit, color: Colors.white, size: 20,),
                                                  ),
                                                  IconButton(
                                                    onPressed: () {
                                                      if(data.userId != userResponse.userId) {
                                                        Fluttertoast.showToast(msg: "자신의 댓글이 아닙니다.");
                                                        return;
                                                      }

                                                      showAnimatedDialog(
                                                          context: context,
                                                          barrierDismissible: false,
                                                          builder: (context) {
                                                            return ClassicGeneralDialogWidget(
                                                              titleText: '댓글 삭제',
                                                              contentText: '댓글을 삭제 하시겠습니까?',
                                                              onPositiveClick: () async {
                                                                Fluttertoast.showToast(msg: "댓글이 삭제되었습니다.");
                                                                commentApi.deleteComment(commentResponse[index].commentId);
                                                                Navigator.of(context).pop();
                                                              },
                                                              onNegativeClick: () {
                                                                Fluttertoast.showToast(msg: "취소");
                                                                Navigator.of(context).pop();
                                                              },
                                                              positiveText: '네',
                                                              negativeText: '아니요',
                                                              negativeTextStyle: const TextStyle(
                                                                  color: Colors.red,
                                                                  fontFamily: 'NotoSansKR',
                                                                  fontWeight: FontWeight.w500,
                                                                  fontSize: 16
                                                              ),
                                                              positiveTextStyle: const TextStyle(
                                                                  color: Color(0xff2F5DFB),
                                                                  fontFamily: 'NotoSansKR',
                                                                  fontWeight: FontWeight.w500,
                                                                  fontSize: 16
                                                              ),
                                                            );
                                                          });
                                                    },
                                                    icon: const Icon(Icons.delete, color: Colors.white, size: 20,),
                                                  ),
                                                  IconButton(
                                                    onPressed: () {
                                                      if(isUpdated) {
                                                        Fluttertoast.showToast(msg: "수정을 해주세요");
                                                        return;
                                                      }

                                                      setState(() {
                                                        recomment = data.nickName;
                                                        isComment = false;
                                                        commentId = data.commentId;
                                                        hint = "${data.nickName}님께 답장";
                                                      });
                                                    },
                                                    icon: const Icon(Icons.add_comment_outlined, color: Colors.white, size: 20,),
                                                  ),
                                                ],
                                              ),
                                              alignment: Alignment.topRight,
                                            )
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                            child: Container(
                                              margin: EdgeInsets.only(left: 23),
                                              child: Text(
                                                commentResponse[index].comment,
                                                style: const TextStyle(
                                                    fontFamily: 'NotoSansKR',
                                                    fontWeight: FontWeight.normal,
                                                    fontSize: 15,
                                                    color: Colors.white
                                                ),
                                              ),
                                              alignment: Alignment.topLeft,
                                            )
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                            child: Container(
                                              margin: EdgeInsets.only(left: 23, bottom: 10, right: 20),
                                              child: Text(
                                                "${commentResponse[index].writeAt.substring(0, 10)} | ${commentResponse[index].writeAt.substring(12, 19)}",
                                                style: const TextStyle(
                                                    fontFamily: 'NotoSansKR',
                                                    fontWeight: FontWeight.normal,
                                                    fontSize: 15,
                                                    color: Colors.white
                                                ),
                                              ),
                                              alignment: Alignment.topRight,
                                            )
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                            contentChild: (context, data) {
                              return Container(
                                width: width * 0.55,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: const Color(0xffD4B886)
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                            child: Container(
                                              margin: EdgeInsets.only(left: 20),
                                              child: Text(
                                                data.nickName,
                                                style: const TextStyle(
                                                    fontFamily: 'NotoSansKR',
                                                    fontWeight: FontWeight.normal,
                                                    fontSize: 18,
                                                    color: Colors.white
                                                ),
                                              ),
                                              alignment: Alignment.topLeft,
                                            )
                                        ),
                                        Expanded(
                                            child: Container(
                                              margin: const EdgeInsets.only(left: 20),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  IconButton(
                                                    onPressed: () {
                                                      if(!isComment) {
                                                        Fluttertoast.showToast(msg: "답변을 작성해주세요");
                                                        return;
                                                      }

                                                      if(data.userId != userResponse.userId) {
                                                        Fluttertoast.showToast(msg: "자신의 댓글이 아닙니다.");
                                                        return;
                                                      }

                                                      setState(() {
                                                        isUpdated = true;
                                                        isUpdateComment = false;
                                                        hint = "updated comment";
                                                        _editCommentController.text = data.comment;
                                                        recommentId = data.recommentId;
                                                      });
                                                    },
                                                    icon: const Icon(Icons.edit, color: Colors.white, size: 20,),
                                                  ),
                                                  IconButton(
                                                    onPressed: () {
                                                      if(data.userId != userResponse.userId) {
                                                        Fluttertoast.showToast(msg: "자신의 댓글이 아닙니다.");
                                                        return;
                                                      }

                                                      showAnimatedDialog(
                                                          context: context,
                                                          barrierDismissible: false,
                                                          builder: (context) {
                                                            return ClassicGeneralDialogWidget(
                                                              titleText: '댓글 삭제',
                                                              contentText: '댓글을 삭제 하시겠습니까?',
                                                              onPositiveClick: () async {
                                                                Fluttertoast.showToast(msg: "댓글이 삭제되었습니다.");
                                                                commentApi.deleteRecomment(data.recommentId);
                                                                Navigator.of(context).pop();
                                                              },
                                                              onNegativeClick: () {
                                                                Fluttertoast.showToast(msg: "취소");
                                                                Navigator.of(context).pop();
                                                              },
                                                              positiveText: '네',
                                                              negativeText: '아니요',
                                                              negativeTextStyle: const TextStyle(
                                                                  color: Colors.red,
                                                                  fontFamily: 'NotoSansKR',
                                                                  fontWeight: FontWeight.w500,
                                                                  fontSize: 16
                                                              ),
                                                              positiveTextStyle: const TextStyle(
                                                                  color: Color(0xff2F5DFB),
                                                                  fontFamily: 'NotoSansKR',
                                                                  fontWeight: FontWeight.w500,
                                                                  fontSize: 16
                                                              ),
                                                            );
                                                          }
                                                      );
                                                    },
                                                    icon: const Icon(Icons.delete, color: Colors.white, size: 20,),
                                                  ),
                                                ],
                                              ),
                                              alignment: Alignment.topRight,
                                            )
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                            child: Container(
                                              margin: EdgeInsets.only(left: 23),
                                              child: Text(
                                                data.comment,
                                                style: const TextStyle(
                                                    fontFamily: 'NotoSansKR',
                                                    fontWeight: FontWeight.normal,
                                                    fontSize: 15,
                                                    color: Colors.white
                                                ),
                                              ),
                                              alignment: Alignment.topLeft,
                                            )
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                            child: Container(
                                              margin: EdgeInsets.only(right: 20, bottom: 10),
                                              child: Text(
                                                "${data.writeAt.substring(0, 10)} | ${data.writeAt.substring(12, 19)}",
                                                style: const TextStyle(
                                                    fontFamily: 'NotoSansKR',
                                                    fontWeight: FontWeight.normal,
                                                    fontSize: 15,
                                                    color: Colors.white
                                                ),
                                              ),
                                              alignment: Alignment.topRight,
                                            )
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                            avatarRoot: (context, data) {
                              return PreferredSize(
                                  child: CircleAvatar(
                                    radius: 18,
                                    backgroundColor: Colors.grey,
                                    backgroundImage: NetworkImage(data.profileUrl,),
                                  ),
                                  preferredSize: Size.fromRadius(12)
                              );
                            },
                            avatarChild: (context, data) {
                              return PreferredSize(
                                  child: CircleAvatar(
                                    radius: 18,
                                    backgroundColor: Colors.white54,
                                    backgroundImage: NetworkImage(data.profileUrl,),
                                  ),
                                  preferredSize: Size.fromRadius(12)
                              );
                            },
                          ),
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    ));
  }

}