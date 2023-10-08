import 'package:countrycraze/screens/game_screen.dart';
import 'package:countrycraze/screens/records.dart'; // Import the Records class
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class home_screen extends StatefulWidget {
  const home_screen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return home_state();
  }
}

class home_state extends State<home_screen> {
  int _level = 1; // Default level
  TextStyle buttonStyle = const TextStyle(color: Colors.white, fontSize: 35);
  TextStyle titleStyle = const TextStyle(fontSize: 30);
  TextStyle subTileStyle = const TextStyle(fontSize: 25);
  var _minPadding = 8.0;

  @override
  void initState() {
    super.initState();
    _loadLevel();
  }

  void _loadLevel() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _level = prefs.getInt('selected_level') ?? 1;
    });
  }

  Future<void> _saveLevel(int level) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('selected_level', level);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Country Craze",
          style: TextStyle(color: Colors.white, fontSize: 25),
        ),
        backgroundColor: const Color(0xFFFFA500),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/background.jpg"))),
          ),

          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    height: 60.0,
                  ),

                  Padding(
                    padding: EdgeInsets.all(_minPadding),
                    child: ElevatedButton(
                      child: Text(
                        "START FUN:)",
                        style: buttonStyle,
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => GameScreen(_level)));
                      },
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.all(_minPadding),
                    child: ElevatedButton(
                      child: Text(
                        "LEVELS",
                        style: buttonStyle,
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: Text("Levels", style: titleStyle),
                            content: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  ListTile(
                                    title: Text(
                                      "Easy",
                                      style: subTileStyle,
                                    ),
                                    onTap: () {
                                      _saveLevel(1); // Save the selected level
                                      Navigator.pop(context);
                                    },
                                  ),
                                  ListTile(
                                    title: Text(
                                      "Medium",
                                      style: subTileStyle,
                                    ),
                                    onTap: () {
                                      _saveLevel(2); // Save the selected level
                                      Navigator.pop(context);
                                    },
                                  ),
                                  ListTile(
                                    title: Text(
                                      "Difficult",
                                      style: subTileStyle,
                                    ),
                                    onTap: () {
                                      _saveLevel(3); // Save the selected level
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.all(_minPadding),
                    child: ElevatedButton(
                      child: Text(
                        "About Project!",
                        style: buttonStyle,
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: Text("Details", style: titleStyle),
                            content: Text(
                              "Country craze is basically Quiz app. "
                              "developed by Group Members: [<Ali Mehran>20sw008, <Ali Haider>20sw040] "
                              "This app is designed to test your knowledge of countries around the world. "
                              "Have fun exploring different levels and improving your knowledge!",
                              style: subTileStyle,
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text("Close"),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  // Add the Records button here
                  Padding(
                    padding: EdgeInsets.all(_minPadding),
                    child: ElevatedButton(
                      child: Text(
                        "Records",
                        style: buttonStyle,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Records(),
                          ),
                        );
                      },
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.all(_minPadding),
                    child: ElevatedButton(
                      child: Text(
                        "Close",
                        style: buttonStyle,
                      ),
                      onPressed: () {
                        SystemNavigator.pop();
                      },
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
