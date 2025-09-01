// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:url_launcher/url_launcher.dart';

class EzecomFooterWidget extends StatefulWidget {
  const EzecomFooterWidget({
    Key? key,
    this.width,
    this.height,
    this.logoImage,
    this.playStoreImage,
    this.appStoreImage,
  }) : super(key: key);

  final double? width;
  final double? height;
  final String? logoImage;
  final String? playStoreImage;
  final String? appStoreImage;

  @override
  _EzecomFooterWidgetState createState() => _EzecomFooterWidgetState();
}

class _EzecomFooterWidgetState extends State<EzecomFooterWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width ?? double.infinity,
      decoration: BoxDecoration(
        color: Color(0xFF3BBCF7), // Footer background color
      ),
      child: Padding(
        padding: EdgeInsets.all(24.0),
        child: _buildResponsiveLayout(),
      ),
    );
  }

  Widget _buildResponsiveLayout() {
    final screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth > 1200) {
      return _buildDesktopLayout();
    } else if (screenWidth > 768) {
      return _buildTabletLayout();
    } else {
      return _buildMobileLayout();
    }
  }

  Widget _buildDesktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 3, child: _buildLogoSection()),
        SizedBox(width: 40),
        Expanded(flex: 2, child: _buildPagesSection()),
        SizedBox(width: 40),
        Expanded(flex: 2, child: _buildHelpSection()),
        SizedBox(width: 40),
        Expanded(flex: 3, child: _buildContactSection()),
        SizedBox(width: 20),
        Expanded(flex: 2, child: _buildSocialSection()),
      ],
    );
  }

  Widget _buildTabletLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLogoSection(),
        SizedBox(height: 32),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildPagesSection()),
            SizedBox(width: 24),
            Expanded(child: _buildHelpSection()),
            SizedBox(width: 24),
            Expanded(child: _buildContactSection()),
          ],
        ),
        SizedBox(height: 32),
        _buildSocialSection(),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLogoSection(),
        SizedBox(height: 32),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildPagesSection()),
            SizedBox(width: 24),
            Expanded(child: _buildHelpSection()),
          ],
        ),
        SizedBox(height: 32),
        _buildContactSection(),
        SizedBox(height: 32),
        _buildSocialSection(),
      ],
    );
  }

  Widget _buildLogoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        widget.logoImage != null
            ? widget.logoImage!.startsWith('http')
                ? Image.network(
                    widget.logoImage!,
                    height: 50,
                    width: 70,
                    fit: BoxFit.contain,
                  )
                : Image.asset(
                    widget.logoImage!,
                    height: 50,
                    width: 70,
                    fit: BoxFit.contain,
                  )
            : Text(
                'Z\nEZECOM',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  height: 1.2,
                ),
              ),
        SizedBox(height: 20),
        Text(
          'Download the app by clicking the link below :',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 8,
          children: [
            _buildPlayStoreButton(),
            _buildAppStoreButton(),
          ],
        ),
      ],
    );
  }

  Widget _buildPlayStoreButton() {
    return GestureDetector(
      onTap: () => _launchURL('https://play.google.com/store'),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            widget.playStoreImage != null
                ? widget.playStoreImage!.startsWith('http')
                    ? Image.network(
                        widget.playStoreImage!,
                        height: 20,
                        width: 20,
                        fit: BoxFit.contain,
                      )
                    : Image.asset(
                        widget.playStoreImage!,
                        height: 20,
                        width: 20,
                        fit: BoxFit.contain,
                      )
                : Icon(Icons.play_arrow, color: Colors.white, size: 20),
            SizedBox(width: 6),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('GET IT ON',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.w300)),
                Text('Google Play',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppStoreButton() {
    return GestureDetector(
      onTap: () => _launchURL('https://apps.apple.com'),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            widget.appStoreImage != null
                ? widget.appStoreImage!.startsWith('http')
                    ? Image.network(
                        widget.appStoreImage!,
                        height: 20,
                        width: 20,
                        fit: BoxFit.contain,
                      )
                    : Image.asset(
                        widget.appStoreImage!,
                        height: 20,
                        width: 20,
                        fit: BoxFit.contain,
                      )
                : Icon(Icons.apple, color: Colors.white, size: 20),
            SizedBox(width: 6),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Download on the',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.w300)),
                Text('App Store',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPagesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Pages',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black)),
        SizedBox(height: 24),
        _buildFooterLink('Profile', () {}),
        SizedBox(height: 12),
        _buildFooterLink('Home', () {}),
        SizedBox(height: 12),
        _buildFooterLink('Cart', () {}),
        SizedBox(height: 12),
        _buildFooterLink('Privacy Policy', () {}),
        SizedBox(height: 12),
        _buildFooterLink('Terms & Conditions', () {}),
        SizedBox(height: 12),
        _buildFooterLink('About Us', () {}),
      ],
    );
  }

  Widget _buildHelpSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Let Us Help You',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black)),
        SizedBox(height: 24),
        _buildFooterLink('Payment', () {}),
        SizedBox(height: 12),
        _buildFooterLink('Shipping', () {}),
        SizedBox(height: 12),
        _buildFooterLink('FAQ', () {}),
      ],
    );
  }

  Widget _buildContactSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Contact',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black)),
        SizedBox(height: 24),
        _buildContactItem(Icons.phone, '+919249786867',
            () => _launchURL('tel:+919249786867')),
        SizedBox(height: 16),
        _buildContactItem(Icons.email, 'contact@ezecom.shop',
            () => _launchURL('mailto:contact@ezecom.shop')),
        SizedBox(height: 16),
        _buildContactItem(
            Icons.location_on,
            'Sun Paul Dezira, 4-B, Info park,\nExpressway, kakkanad,\nErnakulam, Kerala, India',
            null),
      ],
    );
  }

  Widget _buildSocialSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Social media',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black)),
        SizedBox(height: 24),
        Row(
          children: [
            _buildSocialImageIcon(
                'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/ezecomfootterandwebp-rli502/assets/0la88aydk1lj/facebook.png',
                () => _launchURL('https://facebook.com')),
            SizedBox(width: 12),
            _buildSocialImageIcon(
                'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/ezecomfootterandwebp-rli502/assets/olfzk90lcjj9/twitter.png',
                () => _launchURL('https://twitter.com')),
            SizedBox(width: 12),
            _buildSocialImageIcon(
                'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/ezecomfootterandwebp-rli502/assets/x4xi3l33wpc8/instagram.png',
                () => _launchURL('https://instagram.com')),
            SizedBox(width: 12),
            _buildSocialImageIcon(
                'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/ezecomfootterandwebp-rli502/assets/893rinpb14vd/linkedin.png',
                () => _launchURL('https://linkedin.com')),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialImageIcon(String imageUrl, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Image.network(
        imageUrl,
        height: 24,
        width: 24,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildFooterLink(String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 4),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.black87,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            height: 1.3,
          ),
        ),
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String text, VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 24,
              height: 24,
              alignment: Alignment.center,
              child: Icon(icon, color: Colors.black87, size: 16),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                    color: Colors.black87,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    height: 1.4),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}
