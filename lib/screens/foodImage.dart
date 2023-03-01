// import 'dart:html';
import 'dart:developer';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:foodapp/constants/global.dart';
import 'package:foodapp/screens/message.dart';
import 'package:google_fonts/google_fonts.dart';

class FoodScreen extends StatefulWidget {
  const FoodScreen({super.key});

  @override
  State<FoodScreen> createState() => _FoodScreenState();
}

class _FoodScreenState extends State<FoodScreen> {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  late CameraController _cameraController;

  bool loading = false;
  bool uploaded = false;
  bool camInit = false;
  String img = '';

  // NotificationServices notifServices = NotificationServices();

  @override
  void initState() {
    super.initState();
    startCam();
    // notifServices.initializeNotification();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  startCam() async {
    cameras = await availableCameras();
    _cameraController = CameraController(cameras[0], ResolutionPreset.medium,
        enableAudio: false);
    await _cameraController.initialize().then((value) {
      if (!mounted) {
        return;
      }
      setState(() {
        camInit = true;
      });
    }).catchError((e) {
      log(e);
    });
  }

  takePic() async {
    _cameraController.takePicture().then((XFile? file) {
      if (mounted) {
        if (file != null) {
          XFile? picture;
          log('file saved to ${file.path}');
          setState(() {
            loading = true;
            picture = file;
          });

          Reference reference = _storage.ref().child("uploadedImages");
          Reference referenceToUpload =
              reference.child('${DateTime.now().millisecondsSinceEpoch}');

          UploadTask uploadTask =
              referenceToUpload.putFile(File(picture!.path));
          String url = '';
          log('upload task');

          uploadTask.whenComplete(() async {
            url = await referenceToUpload.getDownloadURL();
            log('url taken $url');
            setState(() {
              img = url;
            });
          });
          setState(() {
            loading = false;
            uploaded = true;
          });
          log('uploaded');
        }
      }
    });
  }

  navScreen() {
    // notifServices.sendNotification();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => const MessageScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                margin: EdgeInsets.all(height(context) * 0.04),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 3,
                        color: Colors.black,
                        spreadRadius: 1,
                        offset: Offset(0.0, 1))
                  ],
                ),
                child: CircleAvatar(
                  backgroundColor: primary,
                  radius: 25,
                  child: IconButton(
                    iconSize: 35,
                    color: Colors.white,
                    icon: const Icon(
                      Icons.arrow_back_rounded,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: width(context) * 0.3),
              child: Image.asset('assets/images/animal.png'),
            ),
            Container(
              height: height(context) * 0.625,
              decoration: const BoxDecoration(
                  color: Color.fromRGBO(244, 244, 244, 1),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    height: height(context) * 0.35,
                    width: width(context),
                    margin: EdgeInsets.only(bottom: height(context) * 0.015),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(child: Image.asset('assets/images/fork.png')),
                        Stack(alignment: Alignment.center, children: [
                          SizedBox(
                            height: height(context) * 0.25,
                            width: height(context) * 0.25,
                            child: ClipRRect(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(200000),
                              ),
                              child: uploaded && img != ''
                                  ? Image.network(
                                      img,
                                      scale: 1,
                                      fit: BoxFit.fill,
                                    )
                                  : camInit
                                      ? AspectRatio(
                                          aspectRatio: 1,
                                          child:
                                              CameraPreview(_cameraController),
                                        )
                                      : const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                            ),
                          ),
                          SizedBox(
                              height: height(context) * 0.3,
                              child: Image.asset('assets/images/frame.png')),
                        ]),
                        Image.asset('assets/images/spoon.png'),
                      ],
                    ),
                  ),
                  Text(
                    'Click your meal',
                    style:
                        GoogleFonts.andika(fontSize: 30, color: Colors.black),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      margin: EdgeInsets.only(
                          bottom: height(context) * 0.05,
                          top: height(context) * 0.02),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 3,
                              color: Colors.black,
                              spreadRadius: 1,
                              offset: Offset(0.0, 1))
                        ],
                      ),
                      child: CircleAvatar(
                        backgroundColor: primary,
                        radius: 35,
                        child: loading
                            ? const Center(child: CircularProgressIndicator())
                            : IconButton(
                                iconSize: 35,
                                color: Colors.white,
                                icon: uploaded
                                    ? const Icon(
                                        Icons.check,
                                      )
                                    : const Icon(
                                        Icons.camera_alt_rounded,
                                      ),
                                onPressed: uploaded ? navScreen : takePic,
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
