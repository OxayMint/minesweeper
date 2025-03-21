import 'dart:async';
import 'dart:math';
import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:minesweeper/digital_screen.dart';
import 'package:minesweeper/drawings/drawer.dart';

class Game extends StatefulWidget {
  GameSettings gameSettings;

  Game(this.gameSettings, {super.key});

  @override
  State<Game> createState() => _GameState();
}

enum GameSate { Initialized, Started, GameOver, Win }

class _GameState extends State<Game> {
  double borderWidth = 8;
  double zoom = 0;
  Offset offset = Offset.zero;
  late List<CellState> cellStates;
  late Map<int, bool> mines;
  late Map<int, int> neighborBombs;
  GameSate currentState = GameSate.Initialized;
  late List<Widget> cells;
  late Timer timer;
  int time = 0;
  @override
  void initState() {
    super.initState();
    mines = {};
    neighborBombs = {};
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      tickTimer();
    });
    clearGame();
  }

  Random rng = Random(DateTime.now().millisecondsSinceEpoch);
  // .nextInt(cellStates.length)

  void placeMines(int safeCellIndex) {
    int randomIndex;
    while (mines.values.where((m) => m).length <
        widget.gameSettings.minesCount) {
      randomIndex = rng.nextInt(cellStates.length);
      if (safeCellIndex == randomIndex) {
        continue;
      }
      mines[randomIndex] = true;
    }
  }

  void clearGame() {
    mines.clear();
    neighborBombs.clear();
    cellStates = List.generate(
      widget.gameSettings.height * widget.gameSettings.width,
      (idx) {
        mines[idx] = false;
        neighborBombs[idx] = 0;
        return CellState.Unknnown;
      },
    );
    currentState = GameSate.Initialized;
    setState(() {});
  }

  void restartApp() {
    clearGame();
  }

  // final Border borderDeep = Border(
  //   top: BorderSide(width: 8, color: Color(0xfffcfcfc)),
  //   left: BorderSide(width: 8, color: Color(0xfffcfcfc)),
  //   right: BorderSide(width: 8, color: Color(0xff757575)),
  //   bottom: BorderSide(width: 8, color: Color(0xff757575)),
  // );
  // final Border borderPopped = Border(
  //   top: BorderSide(width: 8, color: Color(0xfffcfcfc)),
  //   left: BorderSide(width: 8, color: Color(0xfffcfcfc)),
  //   right: BorderSide(width: 8, color: Color(0xff757575)),
  //   bottom: BorderSide(width: 8, color: Color(0xff757575)),
  // );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffC0C0C0),

      appBar: AppBar(
        toolbarHeight: 40,
        backgroundColor: Color(0xffC0C0C0),

        leading: InkWell(
          onTap: Navigator.of(context).pop,
          child: Icon(Icons.home),
        ),
        centerTitle: true,
        title: Column(
          children: [
            RichText(
              text: TextSpan(
                text: 'Mine',
                style: TextStyle(
                  fontFamily: 'MineSweeper',
                  fontSize: 15,
                  color: Colors.black,
                ),
                children: [
                  TextSpan(
                    text: 'sweeper',
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              ),
            ),
            Text(widget.gameSettings.gameMode, style: TextStyle(fontSize: 11)),
          ],
        ),
      ),
      body: Container(
        margin: EdgeInsets.all(2),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(width: 4, color: Color(0xfffcfcfc)),
            left: BorderSide(width: 4, color: Color(0xfffcfcfc)),
            right: BorderSide(width: 4, color: Color(0xff757575)),
            bottom: BorderSide(width: 4, color: Color(0xff757575)),
          ),
        ),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(5),
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(width: 4, color: Color(0xfffcfcfc)),
                  bottom: BorderSide(width: 4, color: Color(0xfffcfcfc)),
                  top: BorderSide(width: 4, color: Color(0xff757575)),
                  left: BorderSide(width: 4, color: Color(0xff757575)),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  DigitalScreen(
                    text:
                        "${widget.gameSettings.minesCount - cellStates.where((c) => c == CellState.Flagged).length}",
                    digitsCount: 3,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        restartApp();
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(width: 4, color: Color(0xfffcfcfc)),
                            left: BorderSide(
                              width: 4,
                              color: Color(0xfffcfcfc),
                            ),
                            right: BorderSide(
                              width: 4,
                              color: Color(0xff757575),
                            ),
                            bottom: BorderSide(
                              width: 4,
                              color: Color(0xff757575),
                            ),
                          ),
                        ),
                        padding: EdgeInsets.all(4),
                        child: CustomPaint(
                          key: ValueKey(currentState),
                          painter: PersonalDrawer.smile(switch (currentState) {
                            GameSate.GameOver => SmileState.dead,
                            GameSate.Win => SmileState.nervous,
                            _ => SmileState.happy,
                          }),
                        ),
                      ),
                    ),
                  ),
                  DigitalScreen(
                    text: "",
                    digitsCount: 3,
                    timerMode: true,
                    timerStarted: currentState == GameSate.Started,
                  ),
                ],
              ),
            ),
            if (currentState == GameSate.Win)
              Padding(padding: EdgeInsets.all(8), child: Text("WIN")),
            Expanded(
              child: Container(
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(width: 4, color: Color(0xfffcfcfc)),
                    bottom: BorderSide(width: 4, color: Color(0xfffcfcfc)),
                    top: BorderSide(width: 4, color: Color(0xff757575)),
                    left: BorderSide(width: 4, color: Color(0xff757575)),
                  ),
                ),
                // margin: const EdgeInsets.all(18.0),
                child:
                // InteractiveViewer.builder(
                LayoutBuilder(
                  builder: (context, constraints) {
                    return InteractiveViewer(
                      constrained: false,
                      boundaryMargin: EdgeInsets.zero,
                      minScale: 1.0,
                      maxScale: 3,
                      // builder: (context, viewport) =>
                      child: SizedBox(
                        width: constraints.maxWidth,
                        height: constraints.maxHeight,
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: SizedBox(
                            width: widget.gameSettings.width * 50,
                            height: widget.gameSettings.height * 50,
                            child: GridView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              itemCount:
                                  widget.gameSettings.width *
                                  widget.gameSettings.height,

                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: widget.gameSettings.width,
                                    childAspectRatio: 1,
                                  ),

                              itemBuilder:
                                  (context, index) => GestureDetector(
                                    onLongPressStart: (details) async {
                                      print('vibrate');
                                      await Haptics.vibrate(
                                        HapticsType.selection,
                                      );
                                      setState(() {
                                        flagCell(index);

                                        if (widget.gameSettings.minesCount ==
                                            cellStates
                                                .where(
                                                  (c) =>
                                                      c == CellState.Flagged ||
                                                      c == CellState.Unknnown,
                                                )
                                                .length) {
                                          currentState = GameSate.Win;
                                        }
                                      });
                                    },
                                    onTap: () {
                                      if (currentState == GameSate.GameOver ||
                                          currentState == GameSate.Win) {
                                        return;
                                      }
                                      Haptics.vibrate(HapticsType.warning);
                                      setState(() {
                                        if (currentState ==
                                            GameSate.Initialized) {
                                          placeMines(index);
                                          currentState = GameSate.Started;
                                          // placeMines((y - 1) * widget.gameSettings.width + x);
                                        }
                                        if (currentState == GameSate.Started) {
                                          tapCell(index);
                                        }
                                        if (widget.gameSettings.minesCount ==
                                            cellStates
                                                .where(
                                                  (c) =>
                                                      c == CellState.Flagged ||
                                                      c == CellState.Unknnown,
                                                )
                                                .length) {
                                          currentState = GameSate.Win;
                                        }
                                      });
                                    },
                                    child: Cell(
                                      cellStates[index],
                                      neighborBombs[index]!,
                                      mines[index]!,
                                      currentState == GameSate.GameOver,
                                    ),
                                  ),
                            ),
                          ),
                        ),
                      ),
                      // child: Column(
                      //   children: List.generate(
                      //     widget.gameSettings.height,
                      //     (y) => Row(
                      //       children: List.generate(widget.gameSettings.width, (x) {
                      //         final index = y * widget.gameSettings.width + x;
                      //         return GestureDetector(
                      //           onLongPressStart: (details) {
                      //             setState(() {
                      //               flagCell(index);
                      //               if (widget.gameSettings.minesCount ==
                      //                   cellStates
                      //                       .where(
                      //                         (c) =>
                      //                             c == CellState.Flagged ||
                      //                             c == CellState.Unknnown,
                      //                       )
                      //                       .length) {
                      //                 currentState = GameSate.Win;
                      //               }
                      //             });
                      //           },
                      //           onTap: () {
                      //             if (currentState == GameSate.GameOver ||
                      //                 currentState == GameSate.Win) {
                      //               return;
                      //             }
                      //             Haptics.vibrate(HapticsType.warning);
                      //             setState(() {
                      //               if (currentState == GameSate.Initialized) {
                      //                 placeMines(index);
                      //                 currentState = GameSate.Started;
                      //                 // placeMines((y - 1) * widget.gameSettings.width + x);
                      //               }
                      //               if (currentState == GameSate.Started) {
                      //                 tapCell(index);
                      //               }
                      //               if (widget.gameSettings.minesCount ==
                      //                   cellStates
                      //                       .where(
                      //                         (c) =>
                      //                             c == CellState.Flagged ||
                      //                             c == CellState.Unknnown,
                      //                       )
                      //                       .length) {
                      //                 currentState = GameSate.Win;
                      //               }
                      //             });
                      //           },
                      //           child: Cell(
                      //             cellStates[index],
                      //             neighborBombs[index]!,
                      //             mines[index]!,
                      //             currentState == GameSate.GameOver,
                      //           ),
                      //         );
                      //       }),
                      //     ),
                      //   ),
                      // ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void tapCell(index, {bool force = true}) {
    switch (cellStates[index]) {
      case CellState.Unknnown:
        bool isBombed = mines[index]!;
        cellStates[index] = isBombed ? CellState.Bomb : CellState.Empty;
        if (!isBombed) {
          int bombs = 0;
          var neighbors = getCellNeighbors(index);
          for (var n in neighbors) {
            if (mines[n] ?? false) {
              bombs++;
            }
          }
          neighborBombs[index] = bombs;
          if (bombs == 0) {
            for (var n in neighbors.where(
              (n) => cellStates[n] == CellState.Unknnown,
            )) {
              tapCell(n);
            }
          }
        } else {
          currentState = GameSate.GameOver;
          Haptics.vibrate(HapticsType.error);
        }
        break;

      case CellState.Flagged:
        if (force) {
          cellStates[index] = CellState.Unknnown;
        }
        break;
      case CellState.Empty:
        var neighbors = getCellNeighbors(index);

        if (neighborBombs[index] ==
            neighbors.where((i) => cellStates[i] == CellState.Flagged).length) {
          for (var n in neighbors.where(
            (n) => cellStates[n] == CellState.Unknnown,
          )) {
            tapCell(n);
          }
        }
      default:
        break;
    }
  }

  int indexFromCoordinates(int x, int y) {
    return y * widget.gameSettings.width + x;
  }

  (int, int) coordinateFromIndex(int index) {
    return (
      index % widget.gameSettings.width,
      (index / widget.gameSettings.width).floor(),
    );
  }

  List<int> getCellNeighbors(int cellIndex) {
    var (x, y) = coordinateFromIndex(cellIndex);
    var left = max(x - 1, 0);
    var right = min(x + 1, widget.gameSettings.width - 1);
    var top = max(y - 1, 0);
    var bottom = min(y + 1, widget.gameSettings.height - 1);
    return {
      indexFromCoordinates(left, y),
      indexFromCoordinates(right, y),
      indexFromCoordinates(x, top),
      indexFromCoordinates(x, bottom),
      indexFromCoordinates(left, top),
      indexFromCoordinates(right, top),
      indexFromCoordinates(left, bottom),
      indexFromCoordinates(right, bottom),
    }.toList();
  }

  void flagCell(int index) async {
    if (cellStates[index] == CellState.Unknnown) {
      cellStates[index] = CellState.Flagged;
    }
  }

  void tickTimer() {
    time++;
  }
}

class Cell extends StatelessWidget {
  final CellState state;
  final int neighborBombs;
  final bool isBombed;
  final bool reveal;
  Cell(this.state, this.neighborBombs, this.isBombed, this.reveal, {super.key});

  final digitColorsMap = <int, Color>{
    1: Color(0xff0000FF),
    2: Color(0xff008000),
    3: Color(0xffFF0000),
    4: Color(0xff000080),
    5: Color(0xff800000),
    6: Color(0xff008080),
    7: Color(0xff000000),
    8: Color(0xff808080),
  };
  @override
  Widget build(BuildContext context) {
    bool isOpen = state == CellState.Empty || state == CellState.Bomb;
    // if (isBombed) {
    //   return Text("B");
    // }
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Color(0xffb9b9b9),
        border:
            isOpen
                ? Border.all(color: Color(0xff757575), width: 2)
                : Border(
                  top: BorderSide(width: 8, color: Color(0xfffcfcfc)),
                  left: BorderSide(width: 8, color: Color(0xfffcfcfc)),
                  right: BorderSide(width: 8, color: Color(0xff757575)),
                  bottom: BorderSide(width: 8, color: Color(0xff757575)),
                ),
      ),
      child: Center(
        child:
            //  state == CellState.Clear && isBombed ? Text("B") :
            getBodyItem(),
      ),
    );
  }

  getBodyItem() {
    switch (state) {
      case CellState.Unknnown:
        return reveal && isBombed
            ? CustomPaint(
              painter: PersonalDrawer(DrawerRequest.bomb, isExploded: false),
            )
            : SizedBox.shrink();
      case CellState.Flagged:
        return CustomPaint(painter: PersonalDrawer(DrawerRequest.flag));
      case CellState.Bomb:
        return CustomPaint(
          painter: PersonalDrawer(DrawerRequest.bomb, isExploded: true),
        );
      case CellState.Empty:
        return Text(
          neighborBombs <= 0 ? "" : neighborBombs.toString(),
          style: TextStyle(color: digitColorsMap[neighborBombs], fontSize: 20),
        );
    }
  }
}

enum CellState { Unknnown, Flagged, Empty, Bomb }

class GameSettings {
  final int width;
  final int height;
  final int minesCount;
  final String gameMode;
  const GameSettings({
    required this.width,
    required this.height,
    required this.minesCount,
    required this.gameMode,
  }) : assert(
         minesCount > 0 && minesCount < width * height * 0.3,
         'Mines ratio should be between 0 and 30% of total cell count',
       );
}

extension DoubleExtension on double {
  double get reciprocal => 1.0 / this;
}
