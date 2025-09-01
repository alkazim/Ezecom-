import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'editbanner2_model.dart';
export 'editbanner2_model.dart';

class Editbanner2Widget extends StatefulWidget {
  const Editbanner2Widget({super.key});

  static String routeName = 'editbanner2';
  static String routePath = '/editbanner2';

  @override
  State<Editbanner2Widget> createState() => _Editbanner2WidgetState();
}

class _Editbanner2WidgetState extends State<Editbanner2Widget> {
  late Editbanner2Model _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => Editbanner2Model());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.phonebanner = await actions.fetchPhoneBannerByEmail(
        currentUserEmail,
      );
      _model.desktopbanner = await actions.fetchDesktopBannerByEmail(
        currentUserEmail,
      );
      _model.productfoundname = await actions.fetchCurrentProductName(
        currentUserEmail,
      );
      if ((_model.phonebanner != 'false') &&
          (_model.desktopbanner != 'false')) {
        _model.phonelink = _model.phonebanner!;
        _model.desktoplink = _model.desktopbanner!;
        safeSetState(() {});
        _model.productlist = await ProductsTableTable().queryRows(
          queryFn: (q) => q.eqOrNull(
            'Seller_Email',
            currentUserEmail,
          ),
        );
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: SafeArea(
          top: true,
          child: Visibility(
            visible: (_model.phonelink != 'false') &&
                (_model.desktoplink != 'false'),
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      'Edit Banner',
                      textAlign: TextAlign.center,
                      style:
                          FlutterFlowTheme.of(context).headlineLarge.override(
                                font: GoogleFonts.interTight(
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .headlineLarge
                                      .fontStyle,
                                ),
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.bold,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .headlineLarge
                                    .fontStyle,
                              ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        ListView(
                          padding: EdgeInsets.zero,
                          primary: false,
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          children: [
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  16.0, 0.0, 16.0, 0.0),
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  borderRadius: BorderRadius.circular(12.0),
                                  border: Border.all(
                                    color:
                                        FlutterFlowTheme.of(context).alternate,
                                    width: 1.0,
                                  ),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    FutureBuilder<List<ProductsTableRow>>(
                                      future: ProductsTableTable().queryRows(
                                        queryFn: (q) => q.eqOrNull(
                                          'Seller_Email',
                                          currentUserEmail,
                                        ),
                                      ),
                                      builder: (context, snapshot) {
                                        // Customize what your widget looks like when it's loading.
                                        if (!snapshot.hasData) {
                                          return Center(
                                            child: SizedBox(
                                              width: 50.0,
                                              height: 50.0,
                                              child: CircularProgressIndicator(
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                        Color>(
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                                ),
                                              ),
                                            ),
                                          );
                                        }
                                        List<ProductsTableRow>
                                            dropDownProductsTableRowList =
                                            snapshot.data!;

                                        return FlutterFlowDropDown<String>(
                                          controller:
                                              _model.dropDownValueController ??=
                                                  FormFieldController<String>(
                                            _model.dropDownValue ??=
                                                _model.productfoundname,
                                          ),
                                          options: dropDownProductsTableRowList
                                              .map((e) => e.productName)
                                              .withoutNulls
                                              .toList(),
                                          onChanged: (val) => safeSetState(
                                              () => _model.dropDownValue = val),
                                          width: 200.0,
                                          height: 40.0,
                                          searchHintTextStyle: FlutterFlowTheme
                                                  .of(context)
                                              .labelMedium
                                              .override(
                                                font: GoogleFonts.inter(
                                                  fontWeight:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelMedium
                                                          .fontWeight,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelMedium
                                                          .fontStyle,
                                                ),
                                                letterSpacing: 0.0,
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .labelMedium
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .labelMedium
                                                        .fontStyle,
                                              ),
                                          searchTextStyle: FlutterFlowTheme.of(
                                                  context)
                                              .bodyMedium
                                              .override(
                                                font: GoogleFonts.inter(
                                                  fontWeight:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontWeight,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontStyle,
                                                ),
                                                letterSpacing: 0.0,
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                          textStyle: FlutterFlowTheme.of(
                                                  context)
                                              .bodyMedium
                                              .override(
                                                font: GoogleFonts.inter(
                                                  fontWeight:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontWeight,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontStyle,
                                                ),
                                                letterSpacing: 0.0,
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                          hintText: 'Select...',
                                          searchHintText: 'Search...',
                                          icon: Icon(
                                            Icons.keyboard_arrow_down_rounded,
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                            size: 24.0,
                                          ),
                                          fillColor:
                                              FlutterFlowTheme.of(context)
                                                  .secondaryBackground,
                                          elevation: 2.0,
                                          borderColor: Colors.transparent,
                                          borderWidth: 0.0,
                                          borderRadius: 8.0,
                                          margin:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  12.0, 0.0, 12.0, 0.0),
                                          hidesUnderline: true,
                                          isOverButton: false,
                                          isSearchable: true,
                                          isMultiSelect: false,
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ].divide(SizedBox(height: 16.0)),
                    ),
                    GridView(
                      padding: EdgeInsets.zero,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16.0,
                        mainAxisSpacing: 16.0,
                        childAspectRatio: 0.7,
                      ),
                      primary: false,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 200.0,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                            borderRadius: BorderRadius.circular(16.0),
                            border: Border.all(
                              color: FlutterFlowTheme.of(context).alternate,
                              width: 2.0,
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: double.infinity,
                                  height:
                                      MediaQuery.sizeOf(context).width >= 1024.0
                                          ? 500.0
                                          : 150.0,
                                  child: custom_widgets.BannerUploaderWidget(
                                    width: double.infinity,
                                    height: MediaQuery.sizeOf(context).width >=
                                            1024.0
                                        ? 500.0
                                        : 150.0,
                                    appStateVariableName: 'MobileBannerImage',
                                    dimensionsVariableName: 'MobileDimension',
                                    minWidth: 300,
                                    minHeight: 100,
                                    maxWidth: 1400,
                                    maxHeight: 600,
                                    expectedAspectRatio: 2.58,
                                    aspectRatioTolerance: 0.2,
                                    initialImageUrl: _model.phonelink,
                                  ),
                                ),
                                Text(
                                  'Mobile banner',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        font: GoogleFonts.inter(
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          height: 200.0,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                            borderRadius: BorderRadius.circular(16.0),
                            border: Border.all(
                              color: FlutterFlowTheme.of(context).alternate,
                              width: 2.0,
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: double.infinity,
                                  height:
                                      MediaQuery.sizeOf(context).width >= 1024.0
                                          ? 500.0
                                          : 150.0,
                                  child: custom_widgets.BannerUploaderWidget(
                                    width: double.infinity,
                                    height: MediaQuery.sizeOf(context).width >=
                                            1024.0
                                        ? 500.0
                                        : 150.0,
                                    appStateVariableName: 'DesktopBannerImage',
                                    dimensionsVariableName: 'DesktopDimension',
                                    minWidth: 750,
                                    minHeight: 400,
                                    maxWidth: 3400,
                                    maxHeight: 1800,
                                    expectedAspectRatio: 2.0,
                                    aspectRatioTolerance: 1.0,
                                    initialImageUrl: _model.desktoplink,
                                  ),
                                ),
                                Text(
                                  'Desktop banner',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        font: GoogleFonts.inter(
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    FFButtonWidget(
                      onPressed: () async {
                        if (_model.dropDownValue != null &&
                            _model.dropDownValue != '') {
                          if ((FFAppState().MobileBannerImage != null &&
                                  FFAppState().MobileBannerImage != '') ||
                              (FFAppState().DesktopBannerImage != null &&
                                  FFAppState().DesktopBannerImage != '')) {
                            if ((FFAppState().mobileChanged == true) &&
                                (FFAppState().desktopChanged == true)) {
                              _model.convertedtowebp =
                                  await actions.convertImagesToWebP(
                                FFAppState().MobileBannerImage,
                                FFAppState().DesktopBannerImage,
                              );
                              if (_model.convertedtowebp == true) {
                                _model.uploadedtosupabase =
                                    await actions.uploadBannerImages(
                                  FFAppState().MobileBannerImage,
                                  FFAppState().DesktopBannerImage,
                                );
                                if (_model.uploadedtosupabase == true) {
                                  _model.productid = await actions
                                      .getProductIdByProductNameAndSeller(
                                    _model.dropDownValue!,
                                    currentUserEmail,
                                  );
                                  if (_model.productid != null) {
                                    await BannerTableTable().update(
                                      data: {
                                        'Phone_Banner':
                                            FFAppState().MobileBannerImage,
                                        'Desktop_Banner':
                                            FFAppState().DesktopBannerImage,
                                        'Product_id': _model.productid,
                                        'Active': false,
                                        'Mobile_Dimensions':
                                            FFAppState().MobileDimension,
                                        'Desktop_Dimensions':
                                            FFAppState().DesktopDimension,
                                        'Approval': 'pending',
                                        'Organization': <String, bool>{
                                          'WebHome': false,
                                          'top deals': false,
                                          'mobileHome': false,
                                          'new arrivals': false,
                                          'future offers': false,
                                        },
                                      },
                                      matchingRows: (rows) => rows.eqOrNull(
                                        'Seller_Email',
                                        currentUserEmail,
                                      ),
                                    );
                                  }
                                }
                              }
                            } else {
                              if ((FFAppState().mobileChanged == true) &&
                                  (FFAppState().desktopChanged == false)) {
                                _model.convertedmobile =
                                    await actions.singleImageToWebP(
                                  FFAppState().MobileBannerImage,
                                  'mobile',
                                );
                                if (_model.convertedmobile == true) {
                                  _model.uploadmobile =
                                      await actions.uploadSingleBannerImage(
                                    FFAppState().MobileBannerImage,
                                    'mobile',
                                  );
                                  if (_model.uploadmobile == true) {
                                    _model.productid1 = await actions
                                        .getProductIdByProductNameAndSeller(
                                      _model.dropDownValue!,
                                      currentUserEmail,
                                    );
                                    if (_model.productid != 0) {
                                      await BannerTableTable().update(
                                        data: {
                                          'Phone_Banner':
                                              FFAppState().MobileBannerImage,
                                          'Product_id': _model.productid1,
                                          'Active': false,
                                          'Mobile_Dimensions':
                                              FFAppState().MobileDimension,
                                          'Approval': 'pending',
                                          'Organization': <String, bool>{
                                            'WebHome': false,
                                            'top deals': false,
                                            'mobileHome': false,
                                            'new arrivals': false,
                                            'future offers': false,
                                          },
                                        },
                                        matchingRows: (rows) => rows.eqOrNull(
                                          'Seller_Email',
                                          currentUserEmail,
                                        ),
                                      );
                                    }
                                  }
                                }
                              } else {
                                if ((FFAppState().mobileChanged == false) &&
                                    (FFAppState().desktopChanged == true)) {
                                  _model.converteddesktop =
                                      await actions.singleImageToWebP(
                                    FFAppState().DesktopBannerImage,
                                    'desktop',
                                  );
                                  if (_model.converteddesktop == true) {
                                    _model.uploaddesktop =
                                        await actions.uploadSingleBannerImage(
                                      FFAppState().DesktopBannerImage,
                                      'desktop',
                                    );
                                    if (_model.uploaddesktop == true) {
                                      _model.productid2 = await actions
                                          .getProductIdByProductNameAndSeller(
                                        _model.dropDownValue!,
                                        currentUserEmail,
                                      );
                                      if (_model.productid != 0) {
                                        await BannerTableTable().update(
                                          data: {
                                            'Desktop_Banner':
                                                FFAppState().DesktopBannerImage,
                                            'Product_id': _model.productid2,
                                            'Active': false,
                                            'Desktop_Dimensions':
                                                FFAppState().DesktopDimension,
                                            'Approval': 'pending',
                                            'Organization': <String, bool>{
                                              'WebHome': false,
                                              'top deals': false,
                                              'mobileHome': false,
                                              'new arrivals': false,
                                              'future offers': false,
                                            },
                                          },
                                          matchingRows: (rows) => rows.eqOrNull(
                                            'Seller_Email',
                                            currentUserEmail,
                                          ),
                                        );
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'updated the new edit',
                                              style: TextStyle(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                              ),
                                            ),
                                            duration:
                                                Duration(milliseconds: 4000),
                                            backgroundColor:
                                                FlutterFlowTheme.of(context)
                                                    .secondary,
                                          ),
                                        );
                                      }
                                    }
                                  }
                                }
                              }
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Image didnt change',
                                  style: TextStyle(
                                    color: FlutterFlowTheme.of(context)
                                        .primaryText,
                                  ),
                                ),
                                duration: Duration(milliseconds: 4000),
                                backgroundColor:
                                    FlutterFlowTheme.of(context).secondary,
                              ),
                            );
                          }
                        }

                        safeSetState(() {});
                      },
                      text: 'Submit',
                      icon: Icon(
                        Icons.edit_outlined,
                        size: 20.0,
                      ),
                      options: FFButtonOptions(
                        width: double.infinity,
                        height: 56.0,
                        padding: EdgeInsetsDirectional.fromSTEB(
                            32.0, 0.0, 32.0, 0.0),
                        iconPadding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                        iconColor: FlutterFlowTheme.of(context).info,
                        color: FlutterFlowTheme.of(context).primary,
                        textStyle:
                            FlutterFlowTheme.of(context).titleMedium.override(
                                  font: GoogleFonts.interTight(
                                    fontWeight: FontWeight.w600,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleMedium
                                        .fontStyle,
                                  ),
                                  color: FlutterFlowTheme.of(context).info,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w600,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .titleMedium
                                      .fontStyle,
                                ),
                        elevation: 2.0,
                        borderSide: BorderSide(
                          color: Colors.transparent,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  ].divide(SizedBox(height: 24.0)),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
