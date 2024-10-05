

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:varsity_app/api/local_service.dart';
import 'package:varsity_app/views/root.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  LoginPageState createState() {
    return LoginPageState();
  }
}

class LoginPageState extends State<LoginPage> {
  TextEditingController loginController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: null, //AppBar(),
        body: Container(
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
                // image: DecorationImage(
                //   image: AssetImage("assets/images/plain.gif"),
                //   fit: BoxFit.cover)
                ),
            child: SingleChildScrollView(
                child: Column(
                    children: [
                      SizedBox(height: 30.h),
                      Text('Enter your mobile number', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20.sp)),
                      SizedBox(height: 5.h),
                      Container(
                          width: 100.w,
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child:
                      // Row(
                      //     children: [
                      //     Text('+65', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20.sp)),
                      TextField(
                          keyboardType: TextInputType.number,
                          controller: loginController,
                          maxLines: 1,
                          maxLength: 8,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.black54,
                              hoverColor: Colors.white,
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
                              hintText: 'Mobile number'))),

              SizedBox(height: 2.h),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
                      onPressed: () async {
                            if (loginController.text.length == 8) {
                              try {
                                print(loginController.text);
                                String? userId = await LocalService().createUser(loginController.text);
                                if (userId != null) await Navigator.push(context, MaterialPageRoute(builder: (context) => RootScreen()));
                                else throw "user_id null, please try again";
                                // AuthenticationProvider.of(context).phoneSignIn(loginController.text, _onCodeSent, context);
                              } catch (e) {
                                print(e);
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Error'),
                                      content: Text('Unable to register/login.\n$e'),
                                      actions: [
                                        TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('OK'))]);});
                                loginController.clear();
                              }
                            }
                            else {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Error'),
                                    content: Text('Please enter a valid phone number'),
                                    actions: [
                                      TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('OK'),)]);
                                });
                              loginController.clear();
                              // showSimpleDialog(title: 'Error', message: 'Please enter a valid phone number!', context: context);
                              }
                          },
                      child: Text('Log in/Register', style: TextStyle(fontSize: 12.sp)))),
              SizedBox(height: 2),
            ]))));
  }
}
