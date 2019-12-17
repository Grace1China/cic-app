import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: Text("PDFView test"),
      ),
      body: PDFViewerVerticalWidget(url: "http://www.pdf995.com/samples/pdf.pdf"),
    ),
  ));
}

class PDFViewerVerticalWidget extends StatefulWidget {
  final String url;
  PDFViewerVerticalWidget({this.url});

  @override
  _PDFViewerVerticalWidgetState createState() => _PDFViewerVerticalWidgetState();
}

class _PDFViewerVerticalWidgetState extends State<PDFViewerVerticalWidget> {
  String localPDFPath;

  int _totalPages = 1;
  int _currentPage = 1;
  bool _isPDFReady = false;
  PDFViewController _pdfViewController;

  @override
  void initState() {
    super.initState();

    getFileFromAsset("assets/mypdf.pdf").then((f) {
      setState(() {
        localPDFPath = f.path;
        print(localPDFPath);
      });
    });

//    getFileFromUrl(widget.url).then((f) {
//      setState(() {
//        localPDFPath = f.path;
//        print(localPDFPath);
//      });
//    });
  }

  Future<File> getFileFromAsset(String asset) async {
    try {
      var data = await rootBundle.load(asset);
      var bytes = data.buffer.asUint8List();
      var dir = await getApplicationDocumentsDirectory();
      File file = File("${dir.path}/mypdf.pdf");

      File assetFile = await file.writeAsBytes(bytes);
      return assetFile;
    } catch (e) {
      throw Exception("Error opening asset file");
    }
  }

  Future<File> getFileFromUrl(String url) async {
    try {
      var data = await http.get(url);
      var bytes = data.bodyBytes;
      var dir = await getApplicationDocumentsDirectory();
      File file = File("${dir.path}/mypdfonline.pdf");

      File urlFile = await file.writeAsBytes(bytes);
      return urlFile;
    } catch (e) {
      throw Exception("Error opening url file");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
//          child: (localPDFPath != null ? PDFViewContent(path: localPDFPath) : Offstage())
        child: (localPDFPath != null ? Container(
          child: Offstage(
            offstage: !_isPDFReady,
            child:
            PDFView(
              filePath: localPDFPath,
              enableSwipe: true,
              swipeHorizontal: false, //是否横向滑动。横向滑动iOS上有BUG。
              autoSpacing: true, //自动调整大小，顶满view
              pageFling: true, //整页滑动。
              nightMode: false,
              onError: (e) {
                print(e);
              },
              onRender: (_pages) {
                setState(() {
                  print("渲染成功：总页码：${_pages}");
                  _totalPages = _pages;
                  _currentPage = 1;
                  _isPDFReady = true;
                });
              },
              onViewCreated: (PDFViewController vc) {
                _pdfViewController = vc;
              },
              onPageChanged: (int page, int total) {
                setState(() {});
              },
              onPageError: (page, e) {},
            ),
          ),
        )  : Center(
          child: CircularProgressIndicator(),
        ))
    );
  }
}

//class PDFViewContent extends StatefulWidget {
//  final String path;
//
//  const PDFViewContent({Key key, this.path}) : super(key: key);
//  @override
//  _PDFViewContentState createState() => _PDFViewContentState();
//}
//
//class _PDFViewContentState extends State<PDFViewContent> {
//  int _totalPages = 1;
//  int _currentPage = 1;
//  bool _isPDFReady = false;
//  PDFViewController _pdfViewController;
//
//  @override
//  Widget build(BuildContext context) {
//    return Container(
//      child: Offstage(
//        offstage: !_isPDFReady,
//        child:
//        PDFView(
//          filePath: widget.path,
//          enableSwipe: true,
//          swipeHorizontal: false, //是否横向滑动。横向滑动iOS上有BUG。
//          autoSpacing: true, //自动调整大小，顶满view
//          pageFling: true, //整页滑动。
//          nightMode: false,
//          onError: (e) {
//            print(e);
//          },
//          onRender: (_pages) {
//            setState(() {
//              print("渲染成功：总页码：${_pages}");
//              _totalPages = _pages;
//              _currentPage = 1;
//              _isPDFReady = true;
//            });
//          },
//          onViewCreated: (PDFViewController vc) {
//            _pdfViewController = vc;
//          },
//          onPageChanged: (int page, int total) {
//            setState(() {});
//          },
//          onPageError: (page, e) {},
//        ),
//      ),
//    );
//
//  }
//}
