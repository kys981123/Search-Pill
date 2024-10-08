import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'image_preview.dart';  // 새로 만든 ImagePreview 파일
import 'session.dart';
import 'info.dart';
import 'response.dart';
import 'package:introduction_screen/introduction_screen.dart';

class CameraScreen extends StatefulWidget {
  final List<CameraDescription> cameras;

  CameraScreen({required this.cameras});

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _cameraController;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _cameraController = CameraController(
      widget.cameras[0], // 첫 번째 카메라 사용
      ResolutionPreset.medium,
    );
    _initializeControllerFuture = _cameraController.initialize();

    // 프레임이 빌드된 후 온보딩 화면을 보여줍니다.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showOnboarding();
    });
  }

  void _showOnboarding() {
    showDialog(
      context: context,
      builder: (context) => IntroductionScreen(
        pages: [
          PageViewModel(
            title: "Welcome to Search-Pill",
            body: "This app helps you identify pills.",
            image: Center(child: Icon(Icons.camera, size: 100)),
          ),
          PageViewModel(
            title: "Take a Picture",
            body: "Use the camera to take a picture of the pill.",
            image: Center(child: Icon(Icons.camera_alt, size: 100)),
          ),
          PageViewModel(
            title: "Get Results",
            body: "Get information about the pill.",
            image: Center(child: Icon(Icons.info, size: 100)),
          ),
        ],
        onDone: () {
          Navigator.of(context).pop();  // 온보딩 완료 시 다이얼로그 닫기
        },
        onSkip: () {
          Navigator.of(context).pop();  // 온보딩 스킵 시 다이얼로그 닫기
        },
        showSkipButton: true,
        skip: const Text("Skip"),
        next: const Icon(Icons.arrow_forward),
        done: const Text("Done"),
      ),
    );
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
                  height: MediaQuery.of(context).size.height * 0.615,
                  child: CameraPreview(_cameraController),
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
          // 크롭박스
          Align(
            alignment: Alignment.center,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // 수평선
                Container(
                  width: 100,
                  height: 2,
                  color: Colors.red,
                ),
                // 수직선
                Container(
                  width: 2,
                  height: 100,
                  color: Colors.red,
                ),
              ],
            ),
          ),
          // 촬영 버튼
          Positioned(
            bottom: 20,
            left: MediaQuery.of(context).size.width * 0.5 - 120,
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
