import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/upload_data.dart';
import 'dart:ui';
import 'temp_banner_adding_page_widget.dart' show TempBannerAddingPageWidget;
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class TempBannerAddingPageModel
    extends FlutterFlowModel<TempBannerAddingPageWidget> {
  ///  State fields for stateful widgets in this page.

  bool isDataUploading_uploadData8ma = false;
  FFUploadedFile uploadedLocalFile_uploadData8ma =
      FFUploadedFile(bytes: Uint8List.fromList([]));
  String uploadedFileUrl_uploadData8ma = '';

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
