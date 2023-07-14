import 'package:flutter/material.dart';
import 'package:donut/screen/todo.dart';
import 'package:donut/screen/detail/do_list_detail.dart';
import 'package:donut/server/apis.dart';
import 'package:donut/server/response.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:intl/intl.dart';
import 'package:donut/screen/detail/WriteTodoPage.dart';
import 'package:page_transition/page_transition.dart';


class MyListState extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _MyListState();
}

class _MyListState extends State<MyListState> {

  String date = DateFormat("yyyy-MM-dd").format(DateTime.now());

  UserServerApi userServerApi = UserServerApi();
  DoneServerApi doneServerApi = DoneServerApi();

  List<Todo> todos = [];

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    //MediaQuery 클래스는 현재 장치의 높이/너비를 반환하며 이에 따라 직접 사용할 수 있습니다.
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
                      child: FutureBuilder<UserResponse>(
                        future: userServerApi.getMyInfo(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData == false) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else {
                            return Center(
                                child: Container(
                                  margin: EdgeInsets.only(top: height * 0.016, right: width * 0.001),
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
                                    date = DateFormat("yyyy-MM-dd").format(
                                        dateTime);
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
                          ],
                        ),
                    ),
                  ],
                )
            )
          ],
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
                   Navigator.push(context, PageTransition(child: WriteTodoPage(), type: PageTransitionType.fade));
                },
              ),
            )
          ],
        )
      ],
    );
  }
}

