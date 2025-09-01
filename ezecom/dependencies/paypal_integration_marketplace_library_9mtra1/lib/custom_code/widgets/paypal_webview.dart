// Automatic FlutterFlow imports
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:async';
import 'dart:convert';

import '/custom_code/actions/paypal_pay.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import 'package:http/http.dart' as http;

class PaypalWebview extends StatefulWidget {
  const PaypalWebview({
    super.key,
    this.width,
    this.height,
    required this.checkOutUrl,
    required this.executeUrl,
    required this.accessToken,
    this.onSuccess,
    this.onCancel,
    this.onError,
  });

  final double? width;
  final double? height;
  final String checkOutUrl;
  final String executeUrl;
  final String accessToken;
  final Future Function(dynamic data)? onSuccess;
  final Future Function(dynamic params)? onCancel;
  final Future Function(String message)? onError;

  @override
  State<PaypalWebview> createState() => _PaypalWebviewState();
}

class _PaypalWebviewState extends State<PaypalWebview> {
  late final WebViewController controller;
  bool loading = true;
  int pressed = 0;

  @override
  void initState() {
    super.initState();
    if (mounted) setState(() => loading = true);

    controller = WebViewController.fromPlatformCreationParams(
      WebViewPlatform.instance is WebKitWebViewPlatform
          ? WebKitWebViewControllerCreationParams(
              allowsInlineMediaPlayback: true,
              mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{})
          : const PlatformWebViewControllerCreationParams(),
    );

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFFFFFFFF))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) =>
              debugPrint('WebView is loading (progress : $progress%)'),
          onPageStarted: (String url) {
            if (mounted) setState(() => loading = true);
            debugPrint('Page started loading: $url');
          },
          onPageFinished: (String url) {
            if (mounted) setState(() => loading = false);
          },
          onWebResourceError: (error) => debugPrint('''
              Page resource error:
              code: ${error.errorCode}
              description: ${error.description}
              errorType: ${error.errorType}
              isForMainFrame: ${error.isForMainFrame}
          '''),
          onNavigationRequest: (NavigationRequest request) async {
            if (request.url.startsWith('https://www.youtube.com/')) {
              debugPrint('blocking navigation to ${request.url}');
              return NavigationDecision.prevent;
            } else if (request.url.startsWith(returnURL)) {
              final uri = Uri.parse(request.url);
              final payerID = uri.queryParameters['PayerID'];
              if (payerID != null) {
                final res = await executePayment(payerID, {
                  'payerID': payerID,
                  'paymentId': uri.queryParameters['paymentId'],
                  'token': uri.queryParameters['token'],
                });
                if (res is bool) {
                  if (mounted) Navigator.of(context).pop(res);
                }
              } else {
                if (mounted) Navigator.of(context).pop(false);
              }
            } else if (request.url.startsWith(cancelURL)) {
              await widget.onCancel
                  ?.call(Uri.parse(request.url).queryParameters);
              if (mounted) Navigator.of(context).pop(false);
            }
            debugPrint('allowing navigation to ${request.url}');
            return NavigationDecision.navigate;
          },
          onUrlChange: (UrlChange change) =>
              debugPrint('url change to ${change.url}'),
        ),
      )
      ..addJavaScriptChannel(
        'Toaster',
        onMessageReceived: (message) {
          if (context.mounted) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(message.message)));
          }
        },
      );

    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }

    controller.loadRequest(Uri.parse(widget.checkOutUrl));
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: pressed > 1,
      onPopInvoked: (didPop) {
        if (!didPop) {
          if (pressed < 2) {
            if (mounted) setState(() => pressed++);
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(
                      'Press back ${3 - pressed} more times to cancel transaction')),
            );
          }
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BackButton(color: Colors.black),
              Expanded(
                child: loading
                    ? const Center(child: CircularProgressIndicator())
                    : WebViewWidget(controller: controller),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool?> executePayment(
      String payerId, Map<String, dynamic> data) async {
    if (mounted) setState(() => loading = true);
    try {
      var res = await http.post(
        Uri.parse(widget.executeUrl),
        body: jsonEncode({'payer_id': payerId}),
        headers: {
          'content-type': 'application/json',
          'Authorization': 'Bearer ${widget.accessToken}'
        },
      );

      final body = jsonDecode(res.body);
      if (res.statusCode == 200) {
        await widget.onSuccess?.call({'data': body, ...data});
        return true;
      } else {
        (widget.onError ?? debugPrint).call('Payment Failed. data : $body');
        return false;
      }
    } catch (e) {
      (widget.onError ?? debugPrint).call('error verifying payment $e');
    } finally {
      if (mounted) setState(() => loading = false);
    }
    return null;
  }
}
