import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:quran_app/constant.dart';
import 'package:quran_app/modul/data_bring.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DataBring dataBring = DataBring();
  int pageNumber = 1;
  List<dynamic> ayahs = [];
  List<String> name = [];

  PageController pageController = PageController();

  void getData() async {
    await dataBring.getData();
    setState(() {});
    ayahs = dataBring.item;
    name = dataBring.listOfName;
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            Container(
              child: Image.asset(
                "images/download.jpg",
                fit: BoxFit.fill,
              ),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: name.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () {
                        int number = 0;
                        number = ayahs.firstWhere((element) =>
                            element['sura_name_ar'] == name[index])['page'];
                        print(number);
                        pageController.animateToPage(
                          (number - 1),
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                        );

                        Navigator.pop(context);
                      },
                      title: Text(
                        name[index],
                        textAlign: TextAlign.center,
                        style: kTextStyle,
                      ),
                    );
                  }),
            )
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text(
          "القران الكريم",
        ),
        centerTitle: true,
        backgroundColor: Colors.amber[200],
        leading: IconButton(onPressed: () {}, icon: const Icon(Icons.list)),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
        ],
      ),
      body: PageView.builder(
          itemCount: 604,
          controller: pageController,
          itemBuilder: (context, index) {
            if (ayahs.isNotEmpty) {
              List<TextSpan> ayahsByPage = [];
              String surahName = '';
              int jozzNum = 0;
              bool isBasmalahShown = false;

              for (Map ayahData in ayahs) {
                if (ayahData['page'] == index + 1) {
                  if (ayahData['aya_no'] == 1 &&
                      ayahData['sura_name_ar'] != 'الفَاتِحة' &&
                      ayahData['sura_name_ar'] != 'التوبَة') {
                    isBasmalahShown = true;
                  }
                  ayahsByPage.addAll([
                    if (isBasmalahShown) ...[
                      TextSpan(
                        text: "‏ ‏‏ ‏‏‏‏ ‏‏‏‏‏‏\n\n",
                        style: kBasmalahStyle,
                      )
                    ],
                    TextSpan(
                      text: '${ayahData['aya_text'].toString()} ',
                      style: const TextStyle(
                          fontFamily: 'HafsSmart', fontSize: 19),
                    )
                  ]);
                  isBasmalahShown = false;

                  surahName = ayahData['sura_name_ar'];
                  jozzNum = ayahData['jozz'];
                }
              }
              return Container(
                decoration: index % 2 == 0
                    ? const BoxDecoration(
                        gradient: LinearGradient(
                        colors: [
                          Color.fromRGBO(230, 210, 151, 1),
                          Color.fromRGBO(226, 211, 167, 1),
                          Color.fromRGBO(230, 218, 184, 1),
                          Color.fromRGBO(233, 225, 203, 1),
                        ],
                      ))
                    : const BoxDecoration(
                        gradient: LinearGradient(
                        colors: [
                          Color.fromRGBO(233, 225, 203, 1),
                          Color.fromRGBO(230, 218, 184, 1),
                          Color.fromRGBO(226, 211, 167, 1),
                          Color.fromRGBO(230, 210, 151, 1),
                        ],
                      )),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'الجزء $jozzNum',
                              style: kTextStyle,
                              textAlign: TextAlign.center,
                              textDirection: TextDirection.rtl,
                            ),
                            Text(
                              surahName,
                              style: kTextStyle,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        constraints: const BoxConstraints(maxHeight: 500),
                        child: AutoSizeText.rich(
                          minFontSize: 8,
                          textAlign: TextAlign.center,
                          textDirection: TextDirection.rtl,
                          TextSpan(
                              style: DefaultTextStyle.of(context).style,
                              children: ayahsByPage),
                        ),
                      ),
                      Text(
                        '${index + 1}',
                        textAlign: TextAlign.center,
                        style:
                            const TextStyle(fontFamily: 'Kitab', fontSize: 18),
                      )
                    ],
                  ),
                ),
              );
            } else {
              return const Center(
                  child: CircularProgressIndicator(
                color: Color(0xff915a13),
              ));
            }
          }),
    );
  }
}
