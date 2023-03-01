import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:foodapp/constants/global.dart';
import 'package:foodapp/screens/foodImage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late PermissionStatus cameraStatus;
  @override
  void initState() {
    getCamPermission();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: SafeArea(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.only(bottom: height(context) * 0.2),
              width: width(context) * 0.7,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(50)),
                color: primary,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
                  onPressed: () {
                    cameraStatus == PermissionStatus.granted
                        ? Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const FoodScreen()))
                        : getCamPermission();
                  },
                  child: Text(
                    'Share Your Meal',
                    style:
                        GoogleFonts.andika(fontSize: 25, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void getCameras() async {
    cameras = await availableCameras();
    // log(cameras);
    setState(() {});
  }

  void getCamPermission() async {
    cameraStatus = await Permission.camera.request();
    if (cameraStatus == PermissionStatus.granted) {
      getCameras();
    }
    if (cameraStatus == PermissionStatus.denied) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please accept camera permission')));
      getCamPermission();
    }
    if (cameraStatus == PermissionStatus.permanentlyDenied) {
      openAppSettings();
    }
  }
}
