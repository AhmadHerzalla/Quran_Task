import 'dart:convert';

import 'package:flutter/services.dart';

class DataBring {
  List<dynamic> item = [];
  Set<String> nam = {};
  List<String> listOfName = [];
  // Future<List<dynamic>> fetchData(int page) async {
  //   String result = await rootBundle.loadString("assets/hafs_smart_v8.json");
  //   if (result.isNotEmpty) {
  //     List<dynamic> allAyahs = jsonDecode(result);

  //     List<dynamic> pageAyahs =
  //         allAyahs.where((element) => element["page"] == page).toList();

  //     return pageAyahs;
  //   } else {
  //     return Future.error("error");
  //   }
  // }
  Future<void> getData() async {
    String result = await rootBundle.loadString("assets/hafs_smart_v8.json");
    if (result.isNotEmpty) {
      List<dynamic> allAyahs = jsonDecode(result);
      item = allAyahs;
      item.forEach(
        (element) {
          nam.add(element["sura_name_ar"]);
        },
      );
      nam.forEach(
        (element) {
          listOfName.add(element);
        },
      );
    }
  }
}
