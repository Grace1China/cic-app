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
          body: PDFViewerWidget(url: "http://www.pdf995.com/samples/pdf.pdf"),
      ),
  ));
}

class PDFViewerWidget extends StatefulWidget {
  final String url;
  PDFViewerWidget({this.url});

  @override
  _PDFViewerWidgetState createState() => _PDFViewerWidgetState();
}

class _PDFViewerWidgetState extends State<PDFViewerWidget> {
  String assetPDFPath;
  String urlPDFPath;

  @override
  void initState() {
    super.initState();

    getFileFromAsset("assets/mypdf.pdf").then((f) {
      setState(() {
        assetPDFPath = f.path;
        print(assetPDFPath);
      });
    });

    getFileFromUrl(widget.url).then((f) {
      setState(() {
        urlPDFPath = f.path;
        print(urlPDFPath);
      });
    });
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
//          child: (urlPDFPath != null ? PDFViewContent(path: urlPDFPath) : Offstage())
        child: (urlPDFPath != null ? PDFViewContent(path: urlPDFPath)  : Center(
          child: CircularProgressIndicator(),
        ))
      );
  }
}

class PDFViewContent extends StatefulWidget {
  final String path;

  const PDFViewContent({Key key, this.path}) : super(key: key);
  @override
  _PDFViewContentState createState() => _PDFViewContentState();
}

class _PDFViewContentState extends State<PDFViewContent> {
  int _totalPages = 1;
  int _currentPage = 1;
  bool _isPDFReady = false;
  PDFViewController _pdfViewController;

  @override
  Widget build(BuildContext context) {
    return Container(
//      margin: EdgeInsets.all(5),
//      height: 500,
//      width: 300,
//      color: Colors.grey,
      child: Offstage(
        offstage: !_isPDFReady,
        child:
        Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: PDFView(
                filePath: widget.path,
                autoSpacing: true,
                enableSwipe: true,
                pageSnap: true,
                swipeHorizontal: false,
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
            Container(
//              margin: EdgeInsets.all(5),
//              padding: EdgeInsets.all(10),
//              height: 44,
//              color: Colors.amberAccent,
              child:
              Slider(
                value: _currentPage.toDouble(),
                min: 1,
                max: _totalPages.toDouble(),
                divisions: _totalPages,
                label: "${_currentPage}/${_totalPages}",
                onChanged: (v) {
//                  print("Slider打印：${v}");
                  final position = v.round();
                  if (_currentPage != position){
                    _currentPage = position;
                    setState(() {});
                  }
                },
                onChangeEnd: (v){
                  final position = v.round();
//                  if (_currentPage != position){
                    _currentPage = position;
                    _pdfViewController.setPage(_currentPage - 1);
                    setState(() {});
//                  }
                },
              ),
            ),
          ]
        ),
      ),
    );

  }
}
