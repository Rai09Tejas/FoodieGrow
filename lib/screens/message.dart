import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:foodapp/constants/global.dart';
import 'package:foodapp/screens/home.dart';
import 'package:google_fonts/google_fonts.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({super.key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  Timer? timer;
  int end = 10, start = 0;
  bool timeEnd = false;

  startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      start++;
      log(start.toString());
      setState(() {});
      if (start == end) {
        timer.cancel();
        setState(() {
          timeEnd = true;
        });
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    timer!.cancel();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    startTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: SafeArea(
            child: SizedBox(
          height: height(context),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: height(context) * 0.3),
                child: Text(
                  'GOOD JOB',
                  style: GoogleFonts.lilitaOne(
                      fontSize: 48,
                      color: primary,
                      fontWeight: FontWeight.w400),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: timeEnd
                    ? Container(
                        margin: EdgeInsets.only(bottom: height(context) * 0.05),
                        width: width(context) * 0.5,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                          color: primary,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const HomeScreen()));
                            },
                            child: Text(
                              'Go To Home',
                              style: GoogleFonts.andika(
                                  fontSize: 25, color: Colors.white),
                            ),
                          ),
                        ),
                      )
                    : Text('${(end - start)}...',
                        style: GoogleFonts.andika(
                            fontSize: 25,
                            fontWeight: FontWeight.w300,
                            color: primary)),
              )
            ],
          ),
        )),
      ),
    );
  }
}
