import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'image_preview.dart';  // 새로 만든 ImagePreview 파일
import 'session.dart';
import 'info.dart';
import 'response.dart';

class CameraScreen extends StatefulWidget {
  final List<CameraDescription> cameras;

  CameraScreen({required this.cameras});

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _cameraController;
  late Future<void> _initializeControllerFuture;
  static const String baseurl = "https://api.escuelajs.co/api/v1/files/upload";

  @override
  void initState() {
    super.initState();
    _cameraController = CameraController(
      widget.cameras[0], // 첫 번째 카메라 사용
      ResolutionPreset.medium,
    );
    _initializeControllerFuture = _cameraController.initialize();
  }

  Future<void> _pickImageFromGallery() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ImagePreview(imagePath: image.path),
        ),
      );
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
          FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Positioned(
                  top: 85,
                  left: 0,
                  right: 0,
                  height: MediaQuery.of(context).size.height * 0.615, // 화면 세로의 61.5% 사용
                  child: CameraPreview(_cameraController),
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
          // 크롭박스
          Align(
            alignment: Alignment.center, // Stack의 중앙에 배치
            child: Stack(
              alignment: Alignment.center, // Stack의 중앙에 배치
              children: [
                // 수평선
                Container(
                  width: 100, // 수평선의 길이
                  height: 2, // 수평선의 두께
                  color: Colors.red, // 수평선의 색상
                ),
                // 수직선
                Container(
                  width: 2, // 수직선의 두께
                  height: 100, // 수직선의 길이
                  color: Colors.red, // 수직선의 색상
                ),
              ],
            ),
          ),
          // 촬영 버튼
          Positioned(
            bottom: 20,
            left: MediaQuery.of(context).size.width * 0.5 - 120, // 버튼을 중앙에 위치 (왼쪽 버튼을 위해 조정)
            child: ElevatedButton(
              onPressed: () async {
                try {
                  await _initializeControllerFuture;
                  final image = await _cameraController.takePicture();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ImagePreview(imagePath: image.path),
                    ),
                  );
                } catch (e) {
                  print('Error taking picture: $e');
                }
              },
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(),
                padding: EdgeInsets.all(20),
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: Icon(
                Icons.camera_alt,
                size: 36,
              ),
            ),
          ),
          // 앨범 버튼
          Positioned(
            bottom: 20,
            right: MediaQuery.of(context).size.width * 0.5 - 120,
            child: ElevatedButton(
              onPressed: _pickImageFromGallery,
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(),
                padding: EdgeInsets.all(20),
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: Icon(
                Icons.photo_library,
                size: 36,
              ),
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
