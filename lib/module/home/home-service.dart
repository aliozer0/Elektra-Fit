import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:elektra_fit/global/global-variables.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';

import '../../global/global-models.dart';

class HomeService {
  BehaviorSubject<List<SpaGroupActivityMemberListModel>?> spaGroupActivityMember$ = BehaviorSubject.seeded(null);

  BehaviorSubject<Map<DateTime, List<SpaGroupActivityModel>>> spaGroupActivity$ = BehaviorSubject.seeded({});
  late BehaviorSubject<DateTime> selectedDate$;

  Future<Object> spaGroupActivityTimetableList() async {
    spaGroupActivity$.add({});
    final url = Uri.parse('https://4001.hoteladvisor.net');
    try {
      final response = await http.post(url,
          body: json.encode({
            "Action": "ApiSequence",
            "Object": "spaGroupActivityTimetableList",
            "Parameters": {"HOTELID": hotelId}
          }));

      if (response.statusCode == 200) {
        final jsonData = json.decode(utf8.decode(response.bodyBytes));
        Map<DateTime, List<SpaGroupActivityModel>> groupedActivities = {};

        for (var item in jsonData) {
          SpaGroupActivityModel activity = SpaGroupActivityModel.fromJson(item);
          DateTime startTime = DateFormat("yyyy-MM-dd").format(activity.startTime) as DateTime;

          if (!groupedActivities.containsKey(startTime)) {
            groupedActivities[startTime] = [];
          }

          groupedActivities[startTime]?.add(activity);
        }
        spaGroupActivity$.add(groupedActivities);

        if (groupedActivities.containsKey(selectedDate$.value)) {
          spaGroupActivity$.add(groupedActivities);
        } else {
          spaGroupActivity$.add({});
          return RequestResponse(message: "Seçilen tarih için veri bulunamadı.", result: false);
        }
        return groupedActivities;
      }

      return RequestResponse(message: utf8.decode(response.bodyBytes).tr(), result: true);
    } catch (e) {
      print(e);
      return RequestResponse(message: e.toString(), result: false);
    }
  }

// ///
// // Future<RequestResponse> spaGroupActivityTimetableList() async {
// //   try {
// //     spaGroupActivity$.add(null);
// //
// //     final url = Uri.parse('https://4001.hoteladvisor.net');
// //     final response = await http.post(url,
// //         body: json.encode({
// //           "Action": "ApiSequence",
// //           "Object": "spaGroupActivityTimetableList",
// //           "Parameters": {"HOTELID": hotelId}
// //         }));
// //
// //     if (response.statusCode == 200) {
// //       final jsonData = json.decode(utf8.decode(response.bodyBytes));
// //       Map<DateTime, List<SpaGroupActivityModel>> groupedData = {};
// //
// //       for (var item in jsonData) {
// //         SpaGroupActivityModel activity = SpaGroupActivityModel.fromJson(item);
// //
// //         groupedData.putIfAbsent(activity.startTime, () => []).add(activity);
// //       }
// //
// //       spaGroupActivity$.add(groupedData);
// //       return RequestResponse(message: utf8.decode(response.bodyBytes).tr(), result: true);
// //     } else {
// //       return RequestResponse(message: 'HTTP Error: ${response.statusCode}', result: false);
// //     }
// //   } catch (e) {
// //     print(e);
// //     return RequestResponse(message: e.toString(), result: false);
// //   }
// // }
//
// Future<RequestResponse> spaGroupActivityTimetableList() async {
//   spaGroupActivity$.add(null);
//   final url = Uri.parse('https://4001.hoteladvisor.net');
//   try {
//     final response = await http.post(url,
//         body: json.encode({
//           "Action": "ApiSequence",
//           "Object": "spaGroupActivityTimetableList",
//           "Parameters": {"HOTELID": hotelId}
//         }));
//
//     if (response.statusCode == 200) {
//       final jsonData = json.decode(utf8.decode(response.bodyBytes));
//       List<SpaGroupActivityModel> spaMember = [];
//
//       for (var item in jsonData) {
//         spaMember.add(SpaGroupActivityModel.fromJson(item));
//       }
//       spaGroupActivity$.add(spaMember);
//       spaGroupActivity$.add(spaGroupActivity$.value);
//     }
//
//     return RequestResponse(message: utf8.decode(response.bodyBytes).tr(), result: true);
//   } catch (e) {
//     print(e);
//     return RequestResponse(message: e.toString(), result: false);
//   }
// }
//
// Future<RequestResponse> spaGroupActivityTimetableMembersList() async {
//   spaGroupActivityMember$.add(null);
//   final url = Uri.parse('https://4001.hoteladvisor.net');
//   try {
//     final response = await http.post(url,
//         body: json.encode({
//           "Action": "ApiSequence",
//           "Object": "spaGroupActivityTimetableMembersList",
//           "Parameters": {"HOTELID": hotelId}
//         }));
//
//     if (response.statusCode == 200) {
//       final jsonData = json.decode(utf8.decode(response.bodyBytes));
//       List<SpaGroupActivityMemberListModel> spaGroupMember = [];
//
//       for (var item in jsonData) {
//         spaGroupMember.add(SpaGroupActivityMemberListModel.fromJson(item));
//       }
//       spaGroupActivityMember$.add(spaGroupMember);
//       spaGroupActivityMember$.add(spaGroupActivityMember$.value);
//     }
//
//     return RequestResponse(message: utf8.decode(response.bodyBytes).tr(), result: true);
//   } catch (e) {
//     print(e);
//     return RequestResponse(message: e.toString(), result: false);
//   }
// }
}
