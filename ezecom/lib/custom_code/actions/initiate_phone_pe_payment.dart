// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// Additional imports
import 'package:flutter/foundation.dart'; // For kIsWeb
import 'dart:io'; // For Platform
import 'package:http/http.dart' as http; // HTTP requests
import 'dart:convert'; // jsonEncode/jsonDecode
import 'package:url_launcher/url_launcher.dart'; // Launch URL
import 'package:encrypt/encrypt.dart' as encrypt; // AES encryption
import 'dart:typed_data'; // For Uint8List
import 'package:crypto/crypto.dart'; // For SHA256

// Constants
const String DENO_CREATE_PHONEPE_PAYMENT_SESSION_URL =
    'https://gticwwxjzuftuvilszmq.supabase.co/functions/v1/create-phonepe-payment-session';
const String REACT_PAYMENT_PAGE_BASE_URL = 'https://ezecom.shop/payment/';

Future<bool> initiatePhonePePayment(
  String enquiryId,
  String userJwt,
) async {
  try {
    // 1️⃣ Read AES key & IV from env variables
    final aesKeyStr = FFDevEnvironmentValues().AESKEY;
    final aesIvStr = FFDevEnvironmentValues().AESIV;

    if (aesKeyStr.isEmpty || aesIvStr.isEmpty) {
      print('AES key or IV is empty.');
      return false;
    }

    // Ensure key is exactly 32 bytes
    final finalAesKey = aesKeyStr.length >= 32
        ? aesKeyStr.substring(0, 32)
        : aesKeyStr.padRight(32, '0');

    // Ensure IV is exactly 16 bytes
    final finalAesIv = aesIvStr.length >= 16
        ? aesIvStr.substring(0, 16)
        : aesIvStr.padRight(16, '0');

    final key = encrypt.Key.fromUtf8(finalAesKey);
    final iv = encrypt.IV.fromUtf8(finalAesIv);
    final encrypter =
        encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));

    // 2️⃣ Detect platform
    String platform;
    if (kIsWeb) {
      platform = 'web';
    } else if (Platform.isAndroid) {
      platform = 'android';
    } else if (Platform.isIOS) {
      platform = 'ios';
    } else {
      print('Unsupported platform detected.');
      return false;
    }

    // 3️⃣ Create payment session
    final createSessionResponse = await http.post(
      Uri.parse(DENO_CREATE_PHONEPE_PAYMENT_SESSION_URL),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $userJwt',
      },
      body: jsonEncode({
        'enquiryId': enquiryId,
        'originalPlatform': platform,
      }),
    );

    if (createSessionResponse.statusCode == 200) {
      final responseBody = jsonDecode(createSessionResponse.body);

      if (responseBody['success'] == true &&
          responseBody['paymentSessionToken'] != null) {
        final String paymentSessionToken = responseBody['paymentSessionToken'];

        // ✅ 4️⃣ Encrypt userJwt to send as uvid
        String encryptedUuid;
        try {
          final encrypted = encrypter.encrypt(userJwt, iv: iv);
          encryptedUuid = encrypted.base64;
        } catch (e) {
          print('Encryption failed: $e');
          return false;
        }

        // 5️⃣ Build payment page URL
        final reactPaymentUrl =
            '$REACT_PAYMENT_PAGE_BASE_URL?sessionToken=$paymentSessionToken'
            '&platform=$platform&uvid=${Uri.encodeComponent(encryptedUuid)}';

        // 6️⃣ Launch URL
        if (await canLaunchUrl(Uri.parse(reactPaymentUrl))) {
          await launchUrl(
            Uri.parse(reactPaymentUrl),
            mode: kIsWeb
                ? LaunchMode.platformDefault
                : LaunchMode.externalApplication,
          );
          return true;
        } else {
          print('Could not launch payment URL.');
          return false;
        }
      } else {
        print(
            'Session creation failed: ${responseBody['error'] ?? 'Unknown error'}');
        return false;
      }
    } else if (createSessionResponse.statusCode == 409) {
      final responseBody = jsonDecode(createSessionResponse.body);
      print(
          'Payment conflict: ${responseBody['error'] ?? 'Payment already in progress.'}');
      return false;
    } else {
      print(
          'API error: ${createSessionResponse.statusCode} - ${createSessionResponse.body}');
      return false;
    }
  } catch (e) {
    print('Unexpected error: $e');
    return false;
  }
}
