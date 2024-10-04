import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:varsity_app/api/local_service.dart';
import 'package:varsity_app/views/login.dart';
import 'package:varsity_app/views/root.dart';

class SplashScreen extends StatefulWidget {

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin{
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: Duration(seconds: 3),);
    WidgetsFlutterBinding.ensureInitialized();

      Future.delayed(Duration(seconds: 3)).then((value) async {
        if (await LocalService().getExistingUser() != null)
          await Navigator.push(context, MaterialPageRoute(builder: (context) => RootScreen()));
        else
          await Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage())); //RootScreen(tab: 1)
      });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // double opacityLevel = 1.0;
  // void _changeOpacity() {
  //   setState(() => opacityLevel = opacityLevel == 0 ? 1.0 : 0.0);
  // }

  @override
  Widget build(BuildContext context) {
    _controller.forward();
    return Container(
        color: Theme.of(context).primaryColor,
        child: Center(
            child: Hero(
              tag: "Logo",
              //FadeTransition makes your image Fade
              child: FadeTransition(
                //Use your animation here
                opacity: Tween(begin: 1.0, end: 0.0,).animate(_controller),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      //Here you load you image
                      backgroundImage: AssetImage("assets/images/logo.png"), //put logo here
                      radius: 11.w,
                    ),
                    SizedBox(width: 1.w),
                    Text('Paper Trades',
                        style: TextStyle(fontSize: 28.sp, color: Colors.white,decoration: TextDecoration.none))
                  ],
                )

              ))));
  }
}