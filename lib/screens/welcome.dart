import "package:flutter/material.dart";
import 'package:tahwisa/style/my_colors.dart';
import 'auth/widgets/auth_button.dart';
import 'package:video_player/video_player.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/vid.mp4')
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
        _controller.play();
        _controller.setLooping(true);
      });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: _controller.value.initialized
                ? SizedBox.expand(
                    //   aspectRatio: 16 / 9,
                    child: FittedBox(
                        fit: BoxFit.cover,
                        child: SizedBox(
                            height: height,
                            width: width,
                            child: VideoPlayer(_controller))),
                  )
                : Container(),
          ),
          SizedBox.expand(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(flex: 3, child: SizedBox()),
                AuthButton(
                  title: "Sign in",
                  onTap: () {},
                ),
                SizedBox(height: height * 0.1),
                AuthButton(
                  title: "Sign up",
                  onTap: () {},
                  withBackgroundColor: true,
                ),
                Expanded(flex: 1, child: SizedBox()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
