import 'dart:convert';
import 'dart:math';
import 'package:countrycraze/Utilities/utils.dart';
import 'package:countrycraze/screens/Records.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
// Import the Records class

class GameScreen extends StatefulWidget {
  final int level;
  GameScreen(this.level);

  @override
  State<StatefulWidget> createState() {
    return GameState(this.level);
  }
}

class GameState extends State<GameScreen> {
  Utility utility = Utility();
  int level;
  GameState(this.level);
  var _minPadding = 1.0;
  int que = 0;
  var options = [];
  List<String> totalListFlags = [];
  List<String> selectionCountry = [];
  List<String> countryNames = [];
  late String correctFlag;
  late String correctCountry;
  bool temp = false;
  bool visible = false;
  int guesses = 0;
  late String accurate;
  int correct = 0;
  int incorrect = 0;
  bool check = false;
  List<String> continents = [
    'assets/images/Africa/',
    'assets/images/Asia/',
    'assets/images/Europe/',
    'assets/images/North_America/',
    'assets/images/Oceania/',
    'assets/images/South_America/'
  ];

  TextStyle optionStyle = const TextStyle(color: Colors.white, fontSize: 15);
  TextStyle titleStyle = const TextStyle(fontSize: 30);

  String playerName = ""; // Add playerName variable

  @override
  void initState() {
    super.initState();
    loadImages();
  }

  Future<void> loadImages() async {
    var manifestContent =
        await DefaultAssetBundle.of(context).loadString('AssetManifest.json');
    Map manifestMap = json.decode(manifestContent);
    totalListFlags = [];
    for (var name in continents) {
      var _images = manifestMap.keys.where((key) => key.contains(name));
      totalListFlags.addAll(_images.cast<String>());
    }
    generateRandom();
  }

  Future<void> generateRandom() async {
    selectionCountry = [];
    var rng = Random();
    int min = 0;
    int max = totalListFlags.length - 1;
    for (int i = 1; i <= (level * 3); i++) {
      var a = min + rng.nextInt(max - min);
      if (!selectionCountry.contains(totalListFlags[a])) {
        selectionCountry.add(totalListFlags[a]);
      } else {
        i--;
      }
    }
    correctFlag = selectionCountry[0 + rng.nextInt((selectionCountry.length - 0))];
    correctCountry = (correctFlag
            .substring(correctFlag.indexOf('-') + 1, correctFlag.lastIndexOf('.')))
        .replaceAll('_', ' ');
    generateNames();
  }

  Future<void> generateNames() async {
    countryNames = [];
    for (int i = 0; i < selectionCountry.length; i++) {
      countryNames.add(
          (selectionCountry[i].substring(selectionCountry[i].indexOf('-') + 1,
                  selectionCountry[i].lastIndexOf('.')))
              .replaceAll('_', ' '));
    }
    temp = true;

    que++;
    if (que > 10) {
      guesses = correct + incorrect;
      accurate = ((correct / (guesses)) * 100).toStringAsFixed(2);
      utility.showAlertDialog(
          context,
          "FUN OVER",
          "You made $guesses guesses. \nAccuracy - $accurate %\n\nThank you for Playing :)");
      _gameCompleted(); // Call _gameCompleted when the game ends
      return;
    }
    setState(() {
      check = false;
      visible = false;
    });
  }

  // Add this method to save user records when the game ends
  void _gameCompleted() {
    // Calculate accuracy and guesses
    double accuracy = (correct / (correct + incorrect)) * 100;
    int guesses = correct + incorrect;

    // Save user records
    _saveUserRecords(playerName, accuracy, guesses);

    // Show a dialog or navigate to a results screen
    // For example, navigate to the Records screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => Records(),
      ),
    );
  }

  // Add this method to save user records
  void _saveUserRecords(String playerName, double accuracy, int guesses) {
    SharedPreferences.getInstance().then((prefs) {
      final List<String> records = prefs.getStringList('user_records') ?? [];
      final String record =
          '$playerName - Accuracy: ${accuracy.toStringAsFixed(2)}%, Guesses: $guesses';
      records.add(record);
      prefs.setStringList('user_records', records);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (temp) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Flags Up",
            style: TextStyle(
                color: Colors.white, fontSize: 25),
          ),
          backgroundColor: const Color(0xFFFFA500),
        ),
        body: Stack(
          children: <Widget>[
            Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/background.jpg"))),
            ),
            Center(
              child: Column(
                children: <Widget>[
                  Text(
                    "QUESTION  $que  OF  10",
                    style: titleStyle,
                  ),
                  SizedBox(
                    height: 150.0,
                    child: Image(
                      image: AssetImage(correctFlag),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(_minPadding),
                    child: Text(
                      "GUESS  THE  COUNTRY",
                      style: titleStyle,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: getOptions(0)),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: level > 1 ? getOptions(3) : const SizedBox(),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: level > 2 ? getOptions(6) : const SizedBox(),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 5.0,
              right: 5.0,
              bottom: 5.0,
              child: visible
                  ? Center(
                      child: check
                          ? const Text(
                              "CORRECT",
                              style: TextStyle(
                                  fontSize: 30,
                                  color: Colors.green),
                            )
                          : const Text(
                              "INCORRECT",
                              style: TextStyle(
                                  fontSize: 30,
                                  color: Colors.red),
                            ),
                    )
                  : Container(),
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  Row getOptions(int r) {
    return Row(
      children: <Widget>[
        Expanded(
          child: ElevatedButton(
            child: Text(
              countryNames[r],
              style: optionStyle,
            ),
            onPressed: () {
              handleOptionSelection(countryNames[r]);
            },
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: ElevatedButton(
              child: Text(
                countryNames[r + 1],
                style: optionStyle,
              ),
              onPressed: () {
                handleOptionSelection(countryNames[r + 1]);
              },
            ),
          ),
        ),
        Expanded(
          child: ElevatedButton(
            child: Text(
              countryNames[r + 2],
              style: optionStyle,
            ),
            onPressed: () {
              handleOptionSelection(countryNames[r + 2]);
            },
          ),
        ),
      ],
    );
  }

  void handleOptionSelection(String selectedCountry) {
    if (selectedCountry == correctCountry) {
      setState(() {
        visible = true;
        check = true;
        correct++;
      });
      const oneSec = Duration(milliseconds: 500);
      Timer.periodic(oneSec, (Timer t) {
        generateRandom();
        t.cancel();
      });
    } else {
      setState(() {
        visible = true;
        check = false;
        incorrect++;
      });
    }
  }
}
