// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:url_launcher/url_launcher.dart';

Future<void> launchEmailToEzebit() async {
  final Uri mailtoLink = Uri(
    scheme: 'mailto',
    path: 'ezebitindia@gmail.com',
    queryParameters: {
      'subject': 'Support Request',
      'body': 'Hi, I would like to get in touch with you.',
    },
  );

  if (await canLaunchUrl(mailtoLink)) {
    await launchUrl(mailtoLink);
  } else {
    throw 'Could not launch $mailtoLink';
  }
}

// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
