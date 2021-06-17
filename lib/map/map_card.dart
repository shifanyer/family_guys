import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dot.dart';

class MapCard extends StatelessWidget {
  final double cardWidth;
  final double cardHeight;

  const MapCard({Key? key, required this.cardWidth, required this.cardHeight}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var dotSize = 25.0;
    return Container(
      width: cardWidth,
      height: cardHeight,
      child: Card(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Colors.black12,
                Colors.white70,
              ],
            ),
          ),
          child: Stack(
            children: [
              Column(
                children: [
                  Container(
                    width: cardWidth,
                    height: cardHeight * 0.6,
                    child: Image(
                      image: NetworkImage('https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg'),
                      // fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    width: cardWidth,
                    // height: cardHeight * 0.2,
                    child: Padding(
                      padding: EdgeInsets.only(left: cardWidth * 0.1, top: cardHeight * 0.05, right: cardWidth * 0.1),
                      child: RichText(
                        overflow: TextOverflow.ellipsis,
                        strutStyle: StrutStyle(fontSize: 16.0),
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          text: 'Иванов Иван ИвановичAAAAAAAAAAAAAAA',
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: cardWidth,
                    height: cardHeight * 0.1,
                    child: Padding(
                      padding: EdgeInsets.only(left: cardWidth * 0.1, bottom: cardHeight * 0.05, right: cardWidth * 0.1),
                      child: RichText(
                        overflow: TextOverflow.ellipsis,
                        strutStyle: StrutStyle(fontSize: 12.0),
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w100,
                            color: Colors.blueGrey,
                          ),
                          text: '11.12.2001 - 11.12.2121',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              //children dot
              Center(
                child: Padding(
                  padding: EdgeInsets.only(top: cardHeight - dotSize),
                  child: Dot(
                    dotColor: Colors.blueAccent,
                    dotBorderColor: Colors.redAccent,
                    dotSize: 25.0,
                  ),
                ),
              ),
              // spouse dot
              Center(
                child: Padding(
                  padding: EdgeInsets.only(left: cardWidth - dotSize),
                  child: Dot(
                    dotColor: Colors.teal,
                    dotBorderColor: Colors.lightGreenAccent,
                    dotSize: 25.0,
                  ),
                ),
              ),
              // friends dot
              Center(
                child: Padding(
                  padding: EdgeInsets.only(right: cardWidth - dotSize),
                  child: Dot(
                    dotColor: Colors.pinkAccent,
                    dotBorderColor: Colors.cyanAccent,
                    dotSize: 25.0,
                  ),
                ),
              ),
              // parents dot
              Center(
                child: Padding(
                  padding: EdgeInsets.only(bottom: cardHeight - dotSize),
                  child: Dot(
                    dotColor: Colors.orangeAccent,
                    dotBorderColor: Colors.purple,
                    dotSize: 25.0,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
