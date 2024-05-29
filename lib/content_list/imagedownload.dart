import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:developer';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';


class ImageDetailPage extends StatefulWidget {
  final String picUrl;
  ImageDetailPage({Key? key,required this.picUrl}): super(key: key);

  @override
  _ImageDetailPageState createState() => _ImageDetailPageState();
}

class _ImageDetailPageState extends State<ImageDetailPage>{
  late final WebViewController _controller=WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(const Color(0x00000000))
    ..setNavigationDelegate(
      NavigationDelegate(
        onProgress: (int progress) {
          // Update loading bar.
        },
        onPageStarted: (String url) {
          log(widget.picUrl);
        },
        onPageFinished: (String url) {},
        onWebResourceError: (WebResourceError error) {},
        onNavigationRequest: (NavigationRequest request) {
          if (request.url.startsWith('https://www.youtube.com/')) {
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
      ),
    )
    ..loadRequest(Uri.parse(widget.picUrl));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image'),
      ),
      body: GestureDetector(
        onLongPress: () {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[

                  ListTile(
                    leading: Icon(Icons.file_download),
                    title: Text('下载图片'),
                    onTap: () {
                      // Download image
                      // You can use flutter_downloader or dio to download the image
                      // Example: Use dio to download the image
                      downloadImage(widget.picUrl);
                    },
                  ),
                ],
              );
            },
          );
        },
        child: WebViewWidget(controller:_controller),
      ),

    );
  }
}

//下载图片
Future<void> downloadImage(String imageUrl) async {
  Dio dio = Dio();
  try {
    Response response = await dio.get(imageUrl,
        options: Options(responseType: ResponseType.bytes));
    final List<int> bytes = response.data;


    final directory = await getExternalStorageDirectory();
    final uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString() + '.jpg';
    final filePath = '${directory?.path}/$uniqueFileName';
    print("---------filepath-----------"+filePath);

    File file = File(filePath);
    await file.writeAsBytes(bytes);
  } catch (e) {
    print("Error downloading image: $e");
  }
}
