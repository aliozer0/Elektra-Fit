import 'package:elektra_fit/global/global-models.dart';
import 'package:elektra_fit/global/index.dart';
import 'package:flutter/material.dart';

BehaviorSubject<bool> isDarkMode$ = BehaviorSubject.seeded(false);
BehaviorSubject<bool> isLoading$ = BehaviorSubject.seeded(false);
BehaviorSubject<List<MemberModel>?> member$ = BehaviorSubject.seeded(null);

final config = FitConfig.fromJson(fitConfig);
final apiUrl = Uri.parse('https://4001.hoteladvisor.net');

String? selectedlang;
int? hotelId;

EdgeInsets marginAll5 = const EdgeInsets.all(5);
EdgeInsets marginAll8 = const EdgeInsets.all(8);
EdgeInsets marginAll10 = const EdgeInsets.all(10);
EdgeInsets paddingAll5 = const EdgeInsets.all(5);
EdgeInsets paddingAll8 = const EdgeInsets.all(8);
EdgeInsets paddingAll10 = const EdgeInsets.all(10);
EdgeInsets paddingAll15 = const EdgeInsets.all(15);

Decoration borderAndBorderRadius = BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(10)), border: Border.all(color: isDarkMode$.value ? Colors.white : Colors.black87, width: 1));
BorderRadius borderRadius8 = BorderRadius.all(Radius.circular(8));
BorderRadius borderRadius10 = BorderRadius.all(Radius.circular(10));
BorderRadius borderRadius15 = BorderRadius.all(Radius.circular(15));
Border borderAll = Border.all(color: isDarkMode$.value ? Colors.white : Colors.black54);

TextStyle kAxiforma15 = const TextStyle(fontFamily: "Axiforma", fontSize: 15);
TextStyle kAxiforma16 = const TextStyle(fontFamily: "Axiforma", fontSize: 16);
TextStyle kAxiforma17 = const TextStyle(fontFamily: "Axiforma", fontSize: 17);
TextStyle kAxiforma18 = const TextStyle(fontFamily: "Axiforma", fontSize: 18);
TextStyle kAxiforma19 = const TextStyle(fontFamily: "Axiforma", fontSize: 19);
TextStyle kAxiforma20 = const TextStyle(fontFamily: "Axiforma", fontSize: 20);

TextStyle kMontserrat15 = TextStyle(fontFamily: "Montserrat", fontSize: 15);
TextStyle kMontserrat16 = TextStyle(fontFamily: "Montserrat", fontSize: 16);
TextStyle kMontserrat17 = TextStyle(fontFamily: "Montserrat", fontSize: 17);
TextStyle kMontserrat18 = TextStyle(fontFamily: "Montserrat", fontSize: 18);
TextStyle kMontserrat19 = TextStyle(fontFamily: "Montserrat", fontSize: 19);
TextStyle kMontserrat20 = TextStyle(fontFamily: "Montserrat", fontSize: 20);

TextStyle kProxima15 = TextStyle(fontFamily: "Proxima", fontSize: 15);
TextStyle kProxima16 = TextStyle(fontFamily: "Proxima", fontSize: 16);
TextStyle kProxima17 = TextStyle(fontFamily: "Proxima", fontSize: 17);
TextStyle kProxima18 = TextStyle(fontFamily: "Proxima", fontSize: 18);
TextStyle kProxima19 = TextStyle(fontFamily: "Proxima", fontSize: 19);
TextStyle kProxima20 = TextStyle(fontFamily: "Proxima", fontSize: 20);
