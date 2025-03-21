import 'dart:core';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:minesweeper/drawings/drawer.dart';
import 'package:minesweeper/game.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

Key gameKey = UniqueKey();

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MineSweeper',
      showSemanticsDebugger: false,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "MineSweeper",

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: "/",
      routes: {
        '/': (context) => HomeScreen(),
        '/game':
            (context) => Game(
              key: gameKey,
              ModalRoute.of(context)!.settings.arguments as GameSettings,
            ),
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const modes = [
    GameSettings(width: 9, height: 9, minesCount: 10, gameMode: 'Easy'),
    GameSettings(width: 16, height: 16, minesCount: 40, gameMode: 'Normal'),
    GameSettings(width: 16, height: 30, minesCount: 99, gameMode: 'Hard'),
  ];
  GameSettings currentMode = modes[1];

  // int width = modes[1].width,
  //     height = modes[1].height,
  //     minesCount = modes[1].minesCount;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "${currentMode.width}X${currentMode.height}",
            textAlign: TextAlign.center,
          ),
          Row(
            children: [
              Text("Width:"),
              Expanded(
                child: Slider(
                  value: currentMode.width.toDouble(),
                  min: 9,
                  max: 30,
                  onChanged: (val) {
                    setState(() {
                      currentMode = GameSettings(
                        width: val.floor(),
                        height: currentMode.height,
                        minesCount: currentMode.minesCount,
                        gameMode: "Custom",
                      );
                    });
                  },
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text("Height:"),
              Expanded(
                child: Slider(
                  value: currentMode.height.toDouble(),
                  min: 9,
                  max: 30,
                  onChanged: (val) {
                    setState(() {
                      currentMode = GameSettings(
                        width: currentMode.width,
                        height: val.floor(),
                        minesCount: currentMode.minesCount,
                        gameMode: "Custom",
                      );
                    });
                  },
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text("Bombs:"),
              Expanded(
                child: Slider(
                  value: currentMode.minesCount.toDouble(),
                  min: 9,
                  max: 120,
                  onChanged: (val) {
                    setState(() {
                      currentMode = GameSettings(
                        width: currentMode.width,
                        height: currentMode.height,
                        minesCount: val.floor(),
                        gameMode: "Custom",
                      );
                    });
                  },
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              MaterialButton(
                onPressed: () {
                  setState(() {
                    currentMode = modes[0];
                  });
                },
                child: Text("Easy"),
              ),
              MaterialButton(
                onPressed: () {
                  setState(() {
                    currentMode = modes[1];
                  });
                },
                child: Text("Medium"),
              ),
              MaterialButton(
                onPressed: () {
                  setState(() {
                    currentMode = modes[2];
                  });
                },
                child: Text("Hard"),
              ),
            ],
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/game', arguments: currentMode);
            },
            child: Text("START GAME"),
          ),
        ],
      ),
    );
  }
}
