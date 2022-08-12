import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            const SizedBox(
              height: 150,
            ),
            Card(
                elevation: 5.00,
                // color: Colors.white,
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  SizedBox(
                    height: 150,
                    width: 60,
                    child: RotatedBox(
                      quarterTurns: -1,
                      child: LinearPercentIndicator(
                          percent: 0.6,
                          lineHeight: 60,
                          backgroundColor:
                              const Color.fromARGB(255, 224, 247, 253),
                          linearGradient: const LinearGradient(
                            colors: <Color>[
                              Color.fromARGB(255, 13, 77, 98),
                              Color.fromARGB(255, 20, 141, 155),
                              Color.fromARGB(255, 64, 175, 187),
                              Color.fromARGB(255, 117, 203, 212),
                            ],
                          )),
                    ),
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  Column(children: [
                    Row(children: const [
                      Text(
                        "000",
                        style: TextStyle(
                            fontSize: 30,
                            color: Color.fromARGB(255, 83, 207, 220)),
                      ),
                      Text(
                        "/000",
                        style: TextStyle(fontSize: 30, color: Colors.black),
                      ),
                      Text(
                        "ml",
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      ),
                    ]),
                    const Text(
                      'You have completed 30% of Daily Target',
                      maxLines: 2,
                      style: TextStyle(fontSize: 10, color: Colors.black),
                    ),
                    ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.water),
                        label: const Text(
                          'Add 250ml',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        )),
                  ]),
                ])),
          ],
        ),
      ),
    );
  }
}
