import 'dart:convert';
import 'dart:developer';
import 'dart:html';
import 'dart:typed_data';

import 'package:budget_front/request/ArticlesRequests.dart';
import 'package:budget_front/widget/DonutPieChart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';

import '../entity/ArticleItem.dart';

import 'dart:ui' as ui;

import 'dart:html' as html; //ignore: avoid_web_libraries_in_flutter
import 'dart:js' as js; // ignore: avoid_web_libraries_in_flutter


class FileSaver {
  void saveAs(List<int> bytes, String fileName)
  => js.context.callMethod("saveAs", [html.Blob([bytes]), fileName]);
}

class ArticlesPieCharts extends StatelessWidget {
  GlobalKey _globalKey = new GlobalKey();

  ScreenshotController screenshotController = new ScreenshotController();

  @override
  Widget build(BuildContext context) {

    return Screenshot(
      controller: screenshotController,
      child: Column(
        children: [
          Container(
            height: 500,
            child: Screenshot(
              key: _globalKey,
              child: FutureBuilder<List<ArticleItem>>(
                  future: fetchArticleFlow(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
                    return DonutPieChart(DonutPieChart.createSampleData(snapshot.data));
                  }
              ),
            )
          ),
          ElevatedButton(
            child: Text('save chart'),
            onPressed: _capturePng,
            style: ElevatedButton.styleFrom(
              primary: Colors.white, // background
              onPrimary: Colors.black, // foreground
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: Colors.white)
              ),
            ),
          ),
        ]
      )
    );
  }

  // screenshotController = ScreenshotController();


  Future<Uint8List> _capturePng() async {
    try {
      print('inside');
      RenderRepaintBoundary boundary = _globalKey.currentContext.findRenderObject();
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      var pngBytes = byteData.buffer.asUint8List();
      var bs64 = base64Encode(pngBytes);
      print(pngBytes);
      print(bs64);
      //setState(() {});

      //final file = new File().writeAsBytes(pngBytes);
      final directory = '/home/aleksandra/'; //from path_provide package
      String fileName = '${DateTime.now().microsecondsSinceEpoch}';
      var path = '$directory';

      /*screenshotController.captureAndSave(
          path, //set path where screenshot will be saved
          fileName:fileName
      );*/

      FileSaver().saveAs(pngBytes, "abc.png");

      /*final result = await ImageGallerySaver.saveImage(pngBytes); // Save image to gallery,  Needs plugin  https://pub.dev/packages/image_gallery_saver
      print("File Saved to Gallery");*/

        //writeImage(pngBytes);
      return pngBytes;
    } catch (e) {
      print(e);
    }
  }



  void saveTextFile(String text, String filename) {
    AnchorElement()
      ..href = '${Uri.dataFromString(text, mimeType: 'text/plain', encoding: utf8)}'
      ..download = filename
      ..style.display = 'none'
      ..click();
  }





}
