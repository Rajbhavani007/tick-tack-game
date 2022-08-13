import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'Tick Tack'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final confettiController = ConfettiController();
  var tiles = List.filled(9, 0);
  bool click = false;


  @override
  void initState() {
    confettiController.play();
    super.initState();
  }

  @override
  void dispose() {
    confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: GridView.count(
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
                crossAxisCount: 3,
                children: [
                  for (var i = 0; i < 9; i++)
                    InkWell(
                      onTap: () {
                        setState(() {
                          tiles[i] = 1;
                          click = true;
                          runAi();
                          confettiController.play();
                        });
                      },
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        decoration: BoxDecoration(
                            color: click ? Colors.amber : Colors.grey),
                        child: Center(
                          child: Text(
                            tiles[i] == 0
                                ? " "
                                : tiles[i] == 1
                                    ? "X"
                                    : "O",
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * .07,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  isWinning(1, tiles)
                      ? " YOU WIN THE GAME"
                      : isWinning(2, tiles)
                          ? "YOU LOST THE GAME !! "
                          : "Your Move",
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold),
                ),
                isWinning(1, tiles)
                    ? ConfettiWidget(
                        confettiController: confettiController,
                        blastDirection: -pi / 2,
                        shouldLoop: true,
                        // blastDirectionality: BlastDirectionality.explosive,
                        // emissionFrequency: 1,
                        // // minBlastForce: 10,
                        // maxBlastForce: 50,
                        numberOfParticles: 30,
                      )
                    : Container(),
                const SizedBox(
                  height: 15,
                ),
                OutlinedButton(
                    onPressed: () {
                      setState(() {
                        tiles = List.filled(9, 0);
                        click = false;
                        confettiController.stop();
                        
                      });
                    },
                    child: const Text("Restart")),
              ],
            ),
          ],
        ),
      ),

      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void runAi() async {
    await Future.delayed(const Duration(milliseconds: 200));

    int? Winning;
    int? blocking;
    int? normal;

    for (var i = 0; i < 9; i++) {
      var val = tiles[i];

      if (val > 0) {
        continue;
      }

      var future = [...tiles]..[i] = 2;

      if (isWinning(2, future)) {
        Winning = i;
      }
      future[i] = 1;

      if (isWinning(1, future)) {
        blocking = i;
      }

      normal = i;
    }
    var move = Winning ?? blocking ?? normal;
    if (move != null) {
      setState(() {
        tiles[move] = 2;
      });
    }
  }

  bool isWinning(int who, List<int> future) {
    return (tiles[0] == who && tiles[1] == who && tiles[2] == who) ||
        (tiles[3] == who && tiles[4] == who && tiles[5] == who) ||
        (tiles[6] == who && tiles[7] == who && tiles[8] == who) ||
        (tiles[0] == who && tiles[4] == who && tiles[8] == who) ||
        (tiles[2] == who && tiles[4] == who && tiles[6] == who) ||
        (tiles[0] == who && tiles[3] == who && tiles[6] == who) ||
        (tiles[1] == who && tiles[4] == who && tiles[7] == who) ||
        (tiles[2] == who && tiles[5] == who && tiles[8] == who);
  }
}
