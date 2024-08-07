import 'dart:ui';

Map<String, dynamic> fitConfig = {
  "appName": "My App",
  "hotel-id": 23155,
  "hotel-name": "Elektra Fit",
  "languange": "EN",
  "primaryColor": "#CE0000",
  "IconPrimaryColor": "#40598e",
  "buttonSecondColor": "#D1E0E5",
  'ColorBallBlue': "#BC9B6A",
};

class FitConfig {
  final String appName;
  final int hotelId;
  final String hotelName;
  final String hotelStartImage;
  final String apiUrl;
  final String languange;
  final Color primaryColor;
  final Color IconPrimaryColor;
  final Color buttonSecondColor;
  final Color colorBallBlue;

  FitConfig(
      {required this.hotelId,
      required this.appName,
      required this.hotelName,
      required this.apiUrl,
      required this.languange,
      required this.primaryColor,
      required this.IconPrimaryColor,
      required this.buttonSecondColor,
      required this.colorBallBlue,
      required this.hotelStartImage});

  factory FitConfig.fromJson(Map<String, dynamic> json) {
    return FitConfig(
      hotelId: json["hotel-id"] ?? 0,
      appName: json['appName'] ?? '',
      hotelName: json['hotel-name'] ?? '',
      apiUrl: json['apiUrl'] ?? '',
      languange: json['languange'] ?? '',
      hotelStartImage: json['hotelStartImageUrl'] ?? "",
      primaryColor: Color(int.parse('0xFF${json['primaryColor'].substring(1)}')),
      IconPrimaryColor: Color(int.parse('0xFF${json['IconPrimaryColor'].substring(1)}')),
      buttonSecondColor: Color(int.parse('0xFF${json['buttonSecondColor'].substring(1)}')),
      colorBallBlue: Color(int.parse('0xFF${json['ColorBallBlue'].substring(1)}')),
    );
  }
}
