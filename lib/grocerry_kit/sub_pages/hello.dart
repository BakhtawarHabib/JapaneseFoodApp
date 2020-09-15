import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class Hello extends StatefulWidget {
  @override
  _HelloState createState() => _HelloState();
}

class _HelloState extends State<Hello> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(

      appBar:AppBar(
        centerTitle: true,
        brightness: Brightness.dark,
        elevation: 0,backgroundColor: Theme.of(context).buttonColor,
        automaticallyImplyLeading: true,
        title: Text(
          "Hello!",
          textAlign: TextAlign.end,
          style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w500),
        ),

      ),
      body: Center(
        child: Container(
          color: Colors.white,
          height: height *0.6,
          width: width,
          child: CarouselSlider(
            options: CarouselOptions(
              height: height*0.6,
              initialPage: 0,

              reverse: false,
              autoPlay: true,
              enlargeCenterPage: true,
            ),
            items: ['images/hello1.jpg','images/hello2.jpg','images/hello3.jpg'].map((i) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(i), fit: BoxFit.cover)),
                  );
                },
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
