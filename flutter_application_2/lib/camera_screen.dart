import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'session.dart';
import 'response.dart';
import 'dart:convert';
import "package:http/http.dart" as http;

class CameraScreen extends StatefulWidget {
  final List<CameraDescription> cameras;

  CameraScreen({required this.cameras});

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _cameraController;
  late Future<void> _initializeControllerFuture;
  //static const String baseurl = "https://jsonplaceholder.typicode.com/posts";
  static const String baseurl = "https://api.escuelajs.co/api/v1/files/upload";
  String? _imagePath; // 촬영한 사진의 경로를 저장할 변수
  String changeText = "확인";
  bool _showPreview = false; // 사진 미리보기와 확인 버튼 표시 여부
  bool _isFromGallery = false; // 앨범에서 선택된 사진 여부

  @override
  void initState() {
    super.initState();
    _cameraController = CameraController(
      widget.cameras[0], // 첫 번째 카메라 사용
      ResolutionPreset.high,
    );
    _initializeControllerFuture = _cameraController.initialize();
  }

  Future<void> _pickImageFromGallery() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imagePath = image.path;
        _showPreview = true;
        _isFromGallery = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Search-Pill')),
      ),
      body: Stack(
        children: [
          // 카메라 미리보기
          if (!_showPreview)
            FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Positioned(
                    top: 30,
                    left: 0,
                    right: 0,
                    height: MediaQuery.of(context).size.height * 0.7, // 화면 세로의 70% 사용
                    child: CameraPreview(_cameraController),
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          // 크롭박스
          if (!_showPreview)
            Positioned(
              top: 250, // 크롭박스의 상단 위치
              left: 100, // 크롭박스의 좌측 위치
              width: 200, // 크롭박스의 너비
              height: 200, // 크롭박스의 높이
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.red, // 크롭박스의 테두리 색상
                    width: 2.0, // 테두리 두께
                  ),
                  borderRadius: BorderRadius.circular(10), // 테두리 모서리 둥글게
                ),
              ),
            ),
          // 촬영 버튼
          if (!_showPreview)
            Positioned(
              bottom: 20,
              left: MediaQuery.of(context).size.width * 0.5 - 120, // 버튼을 중앙에 위치 (왼쪽 버튼을 위해 조정)
              child: ElevatedButton(
                onPressed: () async {
                  try {
                    await _initializeControllerFuture;
                    final image = await _cameraController.takePicture();
                    setState(() {
                      _imagePath = image.path; // 촬영한 사진의 경로 저장
                      _showPreview = true; // 사진 미리보기와 확인 버튼 표시
                      _isFromGallery = false;
                    });
                  } catch (e) {
                    print('Error taking picture: $e');
                  }
                },
                style: ElevatedButton.styleFrom(
                  shape: CircleBorder(), // 버튼을 원형으로 만듭니다
                  padding: EdgeInsets.all(20), // 버튼의 크기 설정
                  backgroundColor: Colors.blue, // 버튼의 배경색
                  foregroundColor: Colors.white, // 버튼의 아이콘 색상
                ),
                child: Icon(
                  Icons.camera_alt,
                  size: 36, // 아이콘 크기
                ),
              ),
            ),
          // 앨범 버튼
          if (!_showPreview)
            Positioned(
              bottom: 20,
              right: MediaQuery.of(context).size.width * 0.5 - 120, // 버튼을 중앙에 위치 (오른쪽 버튼을 위해 조정)
              child: ElevatedButton(
                onPressed: _pickImageFromGallery,
                style: ElevatedButton.styleFrom(
                  shape: CircleBorder(), // 버튼을 원형으로 만듭니다
                  padding: EdgeInsets.all(20), // 버튼의 크기 설정
                  backgroundColor: Colors.green, // 버튼의 배경색
                  foregroundColor: Colors.white, // 버튼의 아이콘 색상
                ),
                child: Icon(
                  Icons.photo_library,
                  size: 36, // 아이콘 크기
                ),
              ),
            ),
          // 사진 미리보기 및 확인 버튼
          if (_showPreview)
            Positioned.fill(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.file(File(_imagePath!)), // 촬영한 사진 표시
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async { 
                      Uint8List bytes = File(_imagePath!).readAsBytesSync();
                      // final Map<String, dynamic> data = {
                      //   'file': bytes,
                      // };
                      final ResponseVO responseVO = ResponseVO.fromJSON(await new Session().post('$baseurl', _imagePath!));
                      print(responseVO.originalname);
                      print(responseVO.location);
                      print(responseVO.filename);
                      if (responseVO != null) {
                        setState(() {
                          changeText = responseVO.filename;
                        });
                      }
                    },
                    child: Text(changeText),  
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }
}
