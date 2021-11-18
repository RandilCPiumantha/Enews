import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ArticleView extends StatefulWidget {
  final String blogUrl;
  ArticleView({this.blogUrl});

  @override
  _ArticleViewState createState() => _ArticleViewState();
}

class _ArticleViewState extends State<ArticleView> {
  final Completer<WebViewController> _completer =
      Completer<WebViewController>();
  final key = UniqueKey();
  num position = 1; // index for the IndexedStack widget
  // show the Loading indicator
  startLoading() {
    setState(() {
      position = 1;
    });
  }

  // Time to show the WebView
  doneLoading() {
    setState(() {
      position = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: position,
      children: [
        SafeArea(
          child: Container(
            child: WebView(
              key: key,
              onPageStarted: (_) {
                setState(() {
                  position = 1;
                });
              },
              onPageFinished: (_) {
                setState(() {
                  position = 0;
                });
              },
              initialUrl: widget.blogUrl,
              onWebViewCreated: ((WebViewController webViewController) {
                _completer.complete(webViewController);
              }),
            ),
          ),
        ),
        Container(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ],
    );
  }
}
