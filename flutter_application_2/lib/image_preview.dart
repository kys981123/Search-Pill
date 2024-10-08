import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'session.dart';
import 'info.dart';
import 'response.dart';
import 'package:path/path.dart' as p;


class ImagePreview extends StatelessWidget {
  final String imagePath;

  ImagePreview({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: Text('Search-Pill'))),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Image.file(
                File(imagePath),
                fit: BoxFit.contain, // 이미지가 컨테이너에 맞게 조정
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // 스플래시 화면으로 이동
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SplashScreen(imagePath: imagePath),
                  ),
                );
              },
              child: Text('확인'),
            ),
          ],
        ),
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  final String imagePath;

  SplashScreen({required this.imagePath});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    final unmapper = {
      0 : 197500016,
      1 : 198300064,
      2 : 199603003,
      3 : 199801016,
      4 : 200001279,
      5 : 200905196,
      6 : 201206383,
      7 : 201307583,
      8 : 201308385,
      9 : 201309481,
      10 : 201500041,
    };

    // 10초 후에 API 호출 및 InfoPage로 이동
    Future.delayed(Duration(seconds: 3),
    () async {
      try {
        final queryParams_rand = {
          'min' : '0',
          'max' : '10'
        };

        String rand_str = await Session()
          .get('www.randomnumberapi.com', '/api/v1.0/random', queryParams_rand, false);
        
        final rand_len = rand_str.length;
        final int rand = int.parse(rand_str.substring(1,rand_len-2)); 

        String pill_seq = unmapper[rand].toString();
        String pill_seq_name_1 = 'item_seq';
        String pill_seq_name_2 = 'itemSeq';
        String key = 'dhFZcjvoTtZ/sa73nr4tAR3mE5zdTJ0W+YAqGC6mpsV010eFEFgz0IeulFvol7n6/WnvJKURrfn4EZJEtPGnCA==';

        Uint8List bytes = File(widget.imagePath).readAsBytesSync();
        Map<String, dynamic> response_json = {};

        final queryParams1 = {
          'serviceKey': key,
          'type' : 'json',
          pill_seq_name_1 : pill_seq,
        };

        final queryParams2 = {
          'serviceKey': key,
          'type' : 'json',
          pill_seq_name_2 : pill_seq,
        };
        Map<String, dynamic> json1 ={};
        Map<String, dynamic> json2 ={};
        json1 = await Session()
          .get('apis.data.go.kr', '/1471000/MdcinGrnIdntfcInfoService01/getMdcinGrnIdntfcInfoList01', queryParams1, true);
        json2 = await Session()
          .get('apis.data.go.kr', '/1471000/DrbEasyDrugInfoService/getDrbEasyDrugList', queryParams2, true);
        
        if (json1['body']['items'][0].isNotEmpty && json2['body']['items'][0].isNotEmpty) {
          
          response_json['item_image'] = json1['body']['items'][0]['ITEM_IMAGE'];
          response_json['class_name'] = json1['body']['items'][0]['CLASS_NAME'];

          response_json['entpName'] = json2['body']['items'][0]['entpName'];
          response_json['itemName'] = json2['body']['items'][0]['itemName'];
          response_json['itemSeq'] = json2['body']['items'][0]['itemSeq'];
          response_json['efcyQesitm'] = json2['body']['items'][0]['efcyQesitm'];
          response_json['useMethodQesitm'] = json2['body']['items'][0]['useMethodQesitm'];
          response_json['atpnWarnQesitm'] = json2['body']['items'][0]['atpnWarnQesitm'];
          response_json['atpnQesitm'] = json2['body']['items'][0]['atpnQesitm'];
          response_json['intrcQesitm'] = json2['body']['items'][0]['intrcQesitm'];
          response_json['seQesitm'] = json2['body']['items'][0]['seQesitm'];
          response_json['depositMethodQesitm'] = json2['body']['items'][0]['depositMethodQesitm'];
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => InfoPage(response_json)),
          );
        }

      } catch (e) {
        print('Error uploading image: $e');
        // 에러 처리 (필요에 따라 에러 화면으로 이동)
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Text(
          'Processing...',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
    );
  }
}
