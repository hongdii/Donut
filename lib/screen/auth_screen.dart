import 'package:donut/server/apis.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kakao_flutter_sdk/all.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isInstalled = false;

  final _firebaseMessaging = FirebaseMessaging.instance;

  late SharedPreferences sharedPreferences;
  late AuthServerApi authApi;
  UserServerApi userServerApi = UserServerApi();


  _initKakaoTalkInstalled() async {
    final installed = await isKakaoTalkInstalled();
    print('kakao Install : ' + installed.toString());

    setState(() {
      isInstalled = installed;
    });
  }

  Future<void> authByKakaoTalk() async {
    print("sdfsd");
    try {
      var token = await UserApi.instance.loginWithKakaoTalk(prompts: [Prompt.LOGIN]);
      print("token : ${token.accessToken}");
      String deviceToken = await _firebaseMessaging.getToken() ?? "";
      print(deviceToken);

      User userInfo = await UserApi.instance.me();
      print(userInfo.kakaoAccount);
      if(userInfo.kakaoAccount != null) {
        Account account = userInfo.kakaoAccount!;
        print("userInfo : ${userInfo.id}");
        print(account.profile!.nickname);
        print(account.profile!.isDefaultImage ?? false ? "" : account.profile!.profileImageUrl!);
        authApi.auth(
            userInfo.id,
            account.profile!.nickname,
            account.profile!.isDefaultImage ?? false ? "" : account.profile!.profileImageUrl!,
            deviceToken,
            context
        );
        var s = await SharedPreferences.getInstance();
        s.setInt("kakaoId", userInfo.id);
      }
    }catch(e) {
      print("login failed : $e");
    }
  }

  void initShared() async {
    sharedPreferences = await SharedPreferences.getInstance();
    authApi = AuthServerApi(sharedPreferences);
  }

  @override
  void initState() {
    _initKakaoTalkInstalled();
    initShared();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 0,
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Center(
              child: Container(
                margin: EdgeInsets.only(top: height * 0.25),
                height: 150,
                width: 150,
                child: Image.asset('assets/image/donut_logo.png'),
              ),
            ),
            Center(
                child: Container(
                  margin: EdgeInsets.only(top: height * 0.7),
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.07,
                  child: RaisedButton(
                    elevation: 0,
                    color: Colors.yellow,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                    ),
                    onPressed: () async {
                      if(isInstalled) {
                        await authByKakaoTalk();
                      }else {
                        Fluttertoast.showToast(msg: "카카오톡을 설치해주세요!");
                      }
                      /*authApi.auth(
                          1972385846,
                          "거니거니!",
                          "https://k.kakaocdn.net/dn/rHjPj/btrj1LxNCwn/SFIQzGKnZA2lq01LfRQ9rK/img_640x640.jpg",
                          await _firebaseMessaging.getToken() ?? "",
                          context
                      );*/
                    },
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.chat_bubble, color: Colors.black54),
                          SizedBox(width: 10,),
                          Text(
                            '카카오계정 로그인',
                            style: TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.w900,
                                fontSize: 20
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              )
            )
          ],
        ),
      )
    );
  }
}