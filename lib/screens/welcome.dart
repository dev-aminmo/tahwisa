import "package:flutter/material.dart";
import 'package:tahwisa/style/my_colors.dart';
import 'auth/widgets/auth_button.dart';
import 'package:video_player/video_player.dart';

class WelcomeScreen extends StatefulWidget {
  final userRepository;

  WelcomeScreen({@required this.userRepository});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
        'https://res.cloudinary.com/dtvc2pr8i/video/upload/eo_21,so_0/v1614644723/vid_aq0vw7.mp4')
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
    _controller.setLooping(true);
    _controller.setVolume(0.0);
    _controller.play();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          Center(
              child: SizedBox.expand(
            //   aspectRatio: 16 / 9,
            child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  height: height,
                  width: width,
                  child: _controller.value.initialized
                      ? VideoPlayer(_controller)
                      : Image.asset('assets/images/video_place_holder.jpg'),
                )),
          )),
          SizedBox.expand(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(flex: 3, child: SizedBox()),
                AuthButton(
                  title: "Sign in",
                  onTap: () {
                    Navigator.of(context).pushNamed("/login",
                        arguments: [widget.userRepository]);
                  },
                ),
                SizedBox(height: height * 0.1),
                AuthButton(
                  title: "Sign up",
                  onTap: () {
                    Navigator.of(context).pushNamed("/sign_up");
                  },
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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
