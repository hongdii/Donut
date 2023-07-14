import 'package:donut/screen/main_screen.dart';
import 'package:donut/server/apis.dart';
import 'package:donut/server/response.dart';
import 'package:donut/side_menu/side_menu_widget.dart';
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

import 'detail/done_detail.dart';

class FriendDetailPage extends StatefulWidget {
  String name, profileUrl;
  int kakaoId;

  FriendDetailPage(this.name, this.profileUrl, this.kakaoId);

  @override
  _FriendDetailState createState() => _FriendDetailState(name, profileUrl, kakaoId);
}

class _FriendDetailState extends State<FriendDetailPage> {
  late SharedPreferences sharedPreferences;
  UserServerApi userServerApi = UserServerApi();
  DoneServerApi doneServerApi = DoneServerApi();
  FriendServerApi friendServerApi = FriendServerApi();

  List<DoneResponse> list = [];

  String name, profileUrl;
  int kakaoId;

  String date = DateFormat("yyyy-MM-dd").format(DateTime.now());
  RefreshController _refreshController = RefreshController(initialRefresh: false);

  _FriendDetailState(this.name, this.profileUrl, this.kakaoId);

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
        title: Text(
          name,
          style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 26,
              color: Color(0xff2C2C2C)
          ),
        ),
        titleSpacing: 15,
        leading: Container(
            child: Builder(
                builder: (context) => Container(
                  margin: const EdgeInsets.only(left: 10),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_rounded),
                    onPressed: () async {
                      Navigator.pop(context);
                    },
                    color: const Color(0xff2C2C2C),
                    iconSize: 35,
                  ),
                )
            )
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: height * 0.08),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: NetworkImage(profileUrl),
                            fit: BoxFit.fill
                        )
                    ),
                    width: width * 0.4,
                    height: width * 0.4,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 20),
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
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 120,
                              child: RaisedButton(
                                onPressed: () {
                                  setState(() {
                                    friendServerApi.deleteFriend(kakaoId);
                                    Fluttertoast.showToast(msg: "친구를 끊었습니다");
                                  });
                                },
                                child: const Text(
                                  "친구 끊기",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 20,
                                      color: Colors.white
                                  ),
                                ),
                                color: const Color(0xffD4B886),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            ],
          ),
          Container(
            child: FutureBuilder<List<DoneResponse>> (
              future: doneServerApi.getFriendDone(kakaoId, date),
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
                                    child: RaisedButton(
                                      onLongPress: () {
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
                                      onPressed: () {
                                        var done = list[index];
                                        Navigator.of(context).push(
                                            PageTransition(
                                                child: ReadDoneDetail(done.title, done.isPublic, done.content, done.doneId),
                                                type: PageTransitionType.fade
                                            )
                                        );
                                      },
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
        ],
      )
    );
  }

}