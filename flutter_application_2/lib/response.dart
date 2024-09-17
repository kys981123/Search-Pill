class ResponseVO {
  final dynamic originalname;
  final dynamic filename;
  final dynamic location;

  ResponseVO({this.originalname, this.filename, this.location});

  factory ResponseVO.fromJSON(Map<String, dynamic> json) {
    print('responseVO.originalname : ${json['originalname']}');
    print('responseVO.filename : ${json['filename']}');
    print('responseVO.location : ${json['location']}');

    return ResponseVO(
      originalname: json['originalname'],
      filename: json['filename'],
      location: json['location'],
    );
  }
}