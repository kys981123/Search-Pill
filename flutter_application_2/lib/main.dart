import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'camera_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 사용 가능한 카메라 가져오기
  final cameras = await availableCameras();
  
  runApp(MyApp(cameras: cameras));
}

class MyApp extends StatelessWidget {
  final List<CameraDescription> cameras;

  MyApp({required this.cameras});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Search-Pill',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(cameras: cameras),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final List<CameraDescription> cameras;

  MyHomePage({required this.cameras});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Search-Pill')),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CameraScreen(cameras: cameras),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.all(0), // 내부 여백 제거
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10), // 버튼의 모서리 둥글게
            ),
            backgroundColor: Colors.grey[200], // 버튼 배경색
            side: BorderSide(
              color: Colors.blue, // 버튼 테두리 색상
              width: 2, // 버튼 테두리 두께
            ),
            fixedSize: Size(300, 200), // 버튼 크기 설정
          ),
          child: const Column(
            mainAxisSize: MainAxisSize.min, // 버튼의 크기 조정
            mainAxisAlignment: MainAxisAlignment.center, // 수직 중앙 정렬
            crossAxisAlignment: CrossAxisAlignment.center, // 수평 중앙 정렬
            children: <Widget>[
              SizedBox(height: 10), // 텍스트와 아이콘 사이의 간격
              Icon(
                Icons.camera_alt,
                size: 135, // 아이콘 크기
                color: Colors.blue, // 아이콘 색상
              ),
              Text(
                '알약 검색',
                style: TextStyle(
                  fontSize: 24, // 텍스트 크기
                  fontWeight: FontWeight.bold, // 텍스트 두께
                  color: Colors.blue, // 텍스트 색상
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
