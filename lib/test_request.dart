import 'package:flutter/material.dart';
import 'package:request/utils/RequestClient.dart';

class TestRequest extends StatefulWidget {
  const TestRequest({Key? key}) : super(key: key);

  @override
  _TestRequestState createState() => _TestRequestState();
}

class _TestRequestState extends State<TestRequest> {
  final RequestClient requestClient = RequestClient();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('测试网络请求'),
      ),
      body: Center(
        child: TextButton(
          child: Text('测试网络请求'),
          onPressed: () async{
            var response = await requestClient.post("/app/login/sendSms",data: {"phone": '18833668888'});

            print(response);

          },
        ),
      ),
    );
  }
}
