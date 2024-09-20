import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'session.dart';
import 'info.dart';
import 'response.dart';

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
              onPressed: () async {
                try {
                  Uint8List bytes = File(imagePath).readAsBytesSync();
                  final ResponseVO responseVO = ResponseVO.fromJSON(
                    await Session().post('https://api.escuelajs.co/api/v1/files/upload', imagePath),
                  );
                  print(responseVO.originalname);
                  print(responseVO.location);
                  print(responseVO.filename);

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => InfoPage()),
                  );
                } catch (e) {
                  print('Error uploading image: $e');
                }
              },
              child: Text('확인'),
            ),
          ],
        ),
      ),
    );
  }
}
