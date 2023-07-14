import 'dart:math';

import 'package:donut/screen/detail/done_detail.dart';
import 'package:donut/server/apis.dart';
import 'package:donut/server/response.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DoneListPage extends StatefulWidget {
  @override
  _DoneListState createState() => _DoneListState();
}

class _DoneListState extends State<DoneListPage> {

  String date = DateFormat("yyyy-MM-dd").format(DateTime.now());

  UserServerApi userServerApi = UserServerApi();
  DoneServerApi doneServerApi = DoneServerApi();

  List<int> select = [];

  RefreshController _refreshController = RefreshController(initialRefresh: false);

  List<DoneResponse> list = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: height * 0.01),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: FutureBuilder<UserResponse> (
                      future: userServerApi.getMyInfo(),
                      builder: (context, snapshot) {
                        if(snapshot.hasData == false) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return Center(
                              child: Container(
                                margin: EdgeInsets.only(top: height * 0.016),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      snapshot.data!.profileUrl),
                                    fit: BoxFit.fill
                                  )
                                ),
                                width: width * 0.3,
                                height: width * 0.3,
                              )
                          );
                        }
                      },
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: TextButton(
                            onPressed: () async {
                              DateTime dateTime = await showRoundedDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(DateTime.now().year - 1),
                                  lastDate: DateTime(DateTime.now().year + 1),
                                  theme: ThemeData(
                                      primaryColor: const Color(0xffD4B886),
                                      indicatorColor: Colors.red
                                  ),
                                  height: height * 0.4,
                                  borderRadius: 15
                              ) ?? DateTime.now();

                              setState(() {
                                date = DateFormat("yyyy-MM-dd").format(dateTime);
                              });
                            },
                            child: Text(
                              date,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 20,
                                  color: Color(0xff2C2C2C)
                              ),
                            ),
                          ),
                          width: width * 0.4,
                          height: width * 0.2,
                        ),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                child: RaisedButton(
                                  onPressed: () {
                                    if(select.isEmpty) {
                                      Fluttertoast.showToast(msg: "삭제할 Done리스트를 선택해주세요!");
                                      return;
                                    }

                                    String content = '';
                                    select.forEach((element) {content += '${element+1}번 ';});
                                    content += '\nDoneList를 삭제하시겠습니까?';

                                    showAnimatedDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (context) {
                                          return ClassicGeneralDialogWidget(
                                            titleText: '전체 삭제',
                                            contentText: content,
                                            onPositiveClick: () {
                                              select.forEach((element) {
                                              var done = list.elementAt(element);
                                              print(done.doneId);
                                              doneServerApi.deleteDone(done.doneId);
                                            });

                                              select.removeRange(0, select.length);

                                              Navigator.of(context).pop();
                                            },
                                            onNegativeClick: () {
                                              Navigator.of(context).pop();
                                            },
                                            positiveText: '네',
                                            negativeText: '아니요',
                                            negativeTextStyle: const TextStyle(color: Colors.red, fontWeight: FontWeight.w500, fontSize: 16),
                                            positiveTextStyle: const TextStyle(color: Color(0xff2F5DFB), fontWeight: FontWeight.w500, fontSize: 16),
                                          );
                                        });

                                    setState(() {

                                    });
                                  },
                                  child: const Icon(Icons.delete, size: 25, color: Colors.white,),
                                  color: const Color(0xffD4B886),
                                ),
                              ),
                              Container(
                                child: RaisedButton(
                                  onPressed: () {
                                    if(select.isEmpty) {
                                      Fluttertoast.showToast(msg: "공개할 Done리스트를 선택해주세요!");
                                      return;
                                    }

                                    String content = '';
                                    select.forEach((element) {content += '${element+1}번 ';});
                                    content += '\nDoneList를 공개여부를 변경하시겠습니까?';

                                    showAnimatedDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (context) {
                                          return ClassicGeneralDialogWidget(
                                            titleText: '전체 공개',
                                            contentText: content,
                                            onPositiveClick: () {
                                              select.forEach((element) {
                                                var done = list.elementAt(element);
                                                print(done.doneId);
                                                doneServerApi.updatePublic(done.doneId, !done.isPublic);
                                              });

                                              select.removeRange(0, select.length);

                                              Navigator.of(context).pop();
                                            },
                                            onNegativeClick: () {
                                              Navigator.of(context).pop();
                                            },
                                            positiveText: '네',
                                            negativeText: '아니요',
                                            negativeTextStyle: const TextStyle(color: Colors.red, fontWeight: FontWeight.w500, fontSize: 16),
                                            positiveTextStyle: const TextStyle(color: Color(0xff2F5DFB), fontWeight: FontWeight.w500, fontSize: 16),
                                          );
                                        });
                                  },
                                  child: const Icon(Icons.public, size: 20, color: Colors.white),
                                  color: const Color(0xffD4B886),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    )
                  )
                ],
              ),
            ),
          ],
        ),
        Container(
          child: FutureBuilder<List<DoneResponse>> (
            future: doneServerApi.getMyDonesByWriteAt(date),
            builder: (context, snapshot) {
              print(snapshot.data);
              if(snapshot.hasData == false) {
                return const Center(
                    child: CircularProgressIndicator()
                );
              }else {
                list = snapshot.data!;

                if(list.isEmpty) {
                  return Center(
                    child: Container(
                      child: const Text(
                        'List가 없습니다.',
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: Color(0xff2C2C2C)
                        ),
                      ),
                    ),
                  );
                }else {
                  return Center(
                    child: Container(
                      margin: EdgeInsets.only(top: height * 0.2),
                        height: height * 0.5,
                        child: SmartRefresher(
                          controller: _refreshController,
                          onRefresh: () {
                            setState(() { });
                            _refreshController.refreshCompleted();
                          },
                          enablePullDown: true,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: list.length,
                            itemBuilder: (context, index) {
                              String content = list[index].content.length > 10 ? list[index].content.substring(0, 10) + '...' : list[index].content;

                              return Center(
                                child: Container(
                                  margin: EdgeInsets.only(top: 10),
                                  height: 85,
                                  width: width * 0.87,
                                  child: SwipeActionCell(
                                    key: ObjectKey(list[index]),
                                    performsFirstActionWithFullSwipe: true,
                                    trailingActions: [
                                      SwipeAction(
                                        title: '삭제',
                                        style: TextStyle(fontWeight: FontWeight.normal, fontSize: 18, color: Colors.red),
                                        onTap: (handler) async {
                                          await handler(false);
                                          showAnimatedDialog(
                                              context: context,
                                              barrierDismissible: false,
                                              builder: (context) {
                                                return ClassicGeneralDialogWidget(
                                                  titleText: '삭제',
                                                  contentText: '${index + 1}번을 삭제하시겠습니까?',
                                                  onPositiveClick: () {
                                                    doneServerApi.deleteDone(list[index].doneId);
                                                    Navigator.of(context).pop();
                                                  },
                                                  onNegativeClick: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  positiveText: '네',
                                                  negativeText: '아니요',
                                                  negativeTextStyle: const TextStyle(color: Colors.red, fontWeight: FontWeight.w500, fontSize: 16),
                                                  positiveTextStyle: const TextStyle(color: Color(0xff2F5DFB), fontWeight: FontWeight.w500, fontSize: 16),
                                                );
                                              });
                                          setState(() {
                                            list.removeAt(index);
                                          });
                                        },
                                        color: Color(0xffF4F4F4),
                                        backgroundRadius: 10,
                                      ),
                                      SwipeAction(
                                        title: '수정',
                                        style: TextStyle(fontWeight: FontWeight.normal, fontSize: 18, color: Colors.green),
                                        onTap: (handler) async {
                                          await handler(false);
                                          Navigator.of(context).push(PageTransition(child: UpdateDonePage(list[index].doneId, list[index].title, list[index].content), type: PageTransitionType.fade));
                                          setState(() {});
                                        },
                                        color: Color(0xffF4F4F4),
                                        backgroundRadius: 10,
                                      ),
                                      SwipeAction(
                                        title: list[index].isPublic ?  '비공개' : '공개',
                                        style: TextStyle(fontWeight: FontWeight.normal, fontSize: 18, color: Color(0xff9B9B9B)),
                                        onTap: (handler) async {
                                          await handler(false);
                                          showAnimatedDialog(
                                              context: context,
                                              barrierDismissible: false,
                                              builder: (context) {
                                                return ClassicGeneralDialogWidget(
                                                  titleText: '공개여부',
                                                  contentText: '${index + 1}번을 ${list[index].isPublic ? '비공개 하시겠습니까?' : "공개하시겠습니까?"}',
                                                  onPositiveClick: () {
                                                    doneServerApi.updatePublic(list[index].doneId, !list[index].isPublic);
                                                    Navigator.of(context).pop();
                                                  },
                                                  onNegativeClick: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  positiveText: '네',
                                                  negativeText: '아니요',
                                                  negativeTextStyle: const TextStyle(color: Colors.red, fontWeight: FontWeight.w500, fontSize: 16),
                                                  positiveTextStyle: const TextStyle(color: Color(0xff2F5DFB), fontWeight: FontWeight.w500, fontSize: 16),
                                                );
                                              });
                                          setState(() {
                                            list[index].isPublic = !list[index].isPublic;
                                          });
                                        },
                                        color: Color(0xffF4F4F4),
                                        backgroundRadius: 10,
                                      ),
                                    ],
                                    child: RaisedButton(
                                      onLongPress: () {
                                        if(select.contains(index)) {
                                          Fluttertoast.showToast(msg: "${index + 1}번 선택 해제");
                                          select.remove(index);
                                        }else {
                                          Fluttertoast.showToast(msg: "${index + 1}번 선택됨");
                                          select.add(index);
                                        }
                                      },
                                      onPressed: () {
                                        var done = list[index];
                                        Navigator.of(context).push(
                                          PageTransition(
                                              child: ReadDoneDetail(done.title, done.isPublic, done.content, done.doneId),
                                              type: PageTransitionType.fade
                                          )
                                        );
                                      },
                                      child: Container(
                                        height: 85,
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(left: 5),
                                              child: Container(
                                                child: Text(
                                                  "${index + 1}",
                                                  style: const TextStyle(
                                                      fontWeight: FontWeight.w700,
                                                      fontSize: 20,
                                                      color: Color(0xffffffff)
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                                margin: EdgeInsets.only(left: 20),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      child: Text(
                                                        "제목 : ${list[index].title}",
                                                        style: const TextStyle(
                                                            fontWeight: FontWeight.w700,
                                                            fontSize: 18,
                                                            color: Color(0xffffffff)
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      margin: EdgeInsets.only(top: 10),
                                                      child: Text(
                                                        '내용 : $content',
                                                        style: const TextStyle(
                                                            fontWeight: FontWeight.w700,
                                                            fontSize: 18,
                                                            color: Color(0xffffffff)
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                )
                                            )
                                          ],
                                        ),
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      elevation: 0,
                                      color: const Color(0xffD4B886),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                    ),
                  );

                }
              }
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              margin: EdgeInsets.only(top: height * 0.8, right: 20),
              child: FloatingActionButton(
                child: Icon(Icons.edit),
                backgroundColor: const Color(0xffD4B886),
                onPressed: () {
                  Navigator.push(context, PageTransition(child: WriteDonePage(), type: PageTransitionType.fade));
                },
              ),
            )
          ],
        )
      ],
    );
  }

}