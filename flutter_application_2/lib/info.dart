import 'package:flutter/material.dart';

class InfoPage extends StatelessWidget {
  InfoPage(this.response_json);

  final Map<String, dynamic> response_json;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Search-Pill')),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //Image.network('https://placehold.co/300/jpg'),
            Image.network(response_json['item_image']), // 원하는 이미지 URL


            // response_json['itemSeq']
            // response_json['efcyQesitm']
            // response_json['useMethodQesitm']
            // response_json['atpnWarnQesitm']
            // response_json['atpnQesitm']
            // response_json['intrcQesitm']
            // response_json['seQesitm']
            // response_json['depositMethodQesitm']

            SizedBox(height: 30),
            Text(
              '알약 이름',
              style: TextStyle(fontSize: 15),
            ), 
            Text(
              response_json['itemName'],
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            Text(
              '분류명',
              style: TextStyle(fontSize: 15),
            ), 
            Text(
              response_json['class_name'],
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            Text(
              '업체명',
              style: TextStyle(fontSize: 15),
            ), 
            Text(
              response_json['entpName'],
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                Navigator.popUntil(context, ModalRoute.withName('/'));
              },
              child: Text('홈으로 가기'),
            ),
          ],
        ),
      ),
    );
  }
}