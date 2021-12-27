import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_cubit/service/login_cubit.dart';
import 'package:flutter_bloc_cubit/service/login_state.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: BlocBuilder<GoogleSignInCubit, LoginState>(
        builder: (context, loginState) {
          if (loginState is SignUpState) {
            return SingleChildScrollView(
              child: SizedBox(
                height: height * 0.95,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Spacer(),
                        FlutterLogo(
                          size: 120,
                        ),
                        Spacer(),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Hey There,",
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Welcome Back",
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                          ),
                        ),
                        SizedBox(height: height * 0.02),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Login with your account to continue",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                          ),
                        ),
                        Spacer(),
                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, right: 8.0, bottom: 2.0),
                            child: TextFormField(
                              onSaved: (String? value) {},
                              validator: (String? value) {
                                value!.isEmpty || !value.contains("@")
                                    ? "enter a valid eamil"
                                    : null;
                              },
                              decoration: const InputDecoration(
                                icon:
                                    Icon(Icons.person, color: Colors.blueGrey),
                                hintText: "Email",
                                hintStyle: TextStyle(color: Colors.blueGrey),
                                labelText: "Sign in with Email Account",
                                labelStyle: TextStyle(color: Colors.blueGrey),
                              ),
                            ),
                          ),
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, right: 8.0, bottom: 2.0),
                            child: TextFormField(
                              decoration: const InputDecoration(
                                icon:
                                    Icon(Icons.vpn_key, color: Colors.blueGrey),
                                hintText: "Password",
                                hintStyle: TextStyle(color: Colors.blueGrey),
                                labelText: "Password",
                                labelStyle: TextStyle(color: Colors.blueGrey),
                              ),
                            ),
                          ),
                        ),
                        Spacer(),
                        ElevatedButton(
                            onPressed: () {}, child: Text("Sign In")),
                        SizedBox(
                          height: height * 0.07,
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(
                                FontAwesomeIcons.mailBulk,
                                color: Colors.blueGrey.shade600,
                                size: height * 0.04,
                              ),
                              Text(
                                "Sign Up with Email",
                                style: TextStyle(
                                  color: Colors.blueGrey.shade600,
                                  fontSize: 20,
                                ),
                              )
                            ],
                          ),
                          style: ElevatedButton.styleFrom(
                            onPrimary: Colors.blueGrey,
                            animationDuration: Duration(milliseconds: 1000),
                            primary: Colors.white,
                            shadowColor: Colors.blueAccent,
                            elevation: 9,
                            minimumSize: Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                          ),
                        ),
                        SizedBox(
                          height: height * 0.02,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            context.read<GoogleSignInCubit>().googleSignIn;
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(
                                FontAwesomeIcons.google,
                                color: Colors.blueGrey.shade600,
                                size: height * 0.04,
                              ),
                              Text(
                                "Sign Up with Google",
                                style: TextStyle(
                                  color: Colors.blueGrey.shade600,
                                  fontSize: 20,
                                ),
                              )
                            ],
                          ),
                          style: ElevatedButton.styleFrom(
                            onPrimary: Colors.blueGrey,
                            animationDuration: Duration(milliseconds: 1000),
                            primary: Colors.white,
                            shadowColor: Colors.blueAccent,
                            elevation: 9,
                            minimumSize: Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                          ),
                        ),
                        SizedBox(height: height * 0.03),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Already have an account?",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                            Text(
                              "Log in",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: height * 0.02,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          } else {
            return Center(
                child: Column(
              children: [
                Text("Kullanıcı Giriş Yaptı."),
                CircularProgressIndicator(),
              ],
            ));
          }
        },
      ),
    );
  }
}
