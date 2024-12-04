import 'package:flutter/material.dart';
import 'package:login_app/components/custom_button.dart';
import 'package:login_app/components/custom_textfeild.dart';
import 'package:login_app/components/square_tile.dart';
import 'package:login_app/main.dart';
import 'package:login_app/pages/forgotpasswordPage.dart';
import 'package:login_app/pages/homePage.dart';
import 'package:login_app/pages/registerPage.dart';
import 'package:login_app/services/authentication_service.dart';
import 'package:login_app/services/handle_firebase_exception.dart';
import 'package:login_app/utils/load_spinner.dart';
import 'package:login_app/utils/snackbar_service.dart';
import 'package:login_app/utils/validator.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';


class Loginpage extends StatefulWidget {
  static const String id = 'loginP';
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  final _formKey = GlobalKey<FormState>();
  String _us = '';
  String _ps = '';

  void signIn() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      DisplaySpinner.show(context);
      final status =
          await AuthenticationService.login(username: _us, password: _ps);
      if (status == AuthStatus.successful) {
        DisplaySpinner.hide();
        if (!mounted) {
          return;
        }
        SnackbarService.DisplaySnackbar(
            context, "Sign in success", SnackbarStatus.success);
        Navigator.pushNamedAndRemoveUntil(
            context, Homepage.id, (route) => false);
      } else {
        final err = HandleFirebaseException.generateErrMsg(status);
        DisplaySpinner.hide();
        if (!mounted) return;
        {
          SnackbarService.DisplaySnackbar(context, err, SnackbarStatus.error);
        }
      }
      _formKey.currentState!.reset();
    }
  }

  void signinWithGoogleOAuth() async {
    DisplaySpinner.show(context);
    final status = await AuthenticationService.signinWithGoogle();
    if (status == AuthStatus.successful) {
      DisplaySpinner.hide();
      if (!mounted) return;
      SnackbarService.DisplaySnackbar(
          context, "Sign in success with google", SnackbarStatus.success);
      Navigator.pushNamedAndRemoveUntil(context, Homepage.id, (route) => false);
    } else {
      final err = HandleFirebaseException.generateErrMsg(status);
      DisplaySpinner.hide();
      if (!mounted) {
        SnackbarService.DisplaySnackbar(context, err, SnackbarStatus.error);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 30),
              const Icon(
                Icons.lock,
                size: 100,
              ),
              Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 50,
                      ),
                      // Padding(padding: EdgeInsets.all(10)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Column(
                          children: [
                            CustomTextField(
                                label: "Username",
                                obscureText: false,
                                hintText: "Enter your username",
                                onSaves: (newValue) {
                                  _us = newValue!;
                                },
                                validator: (value) =>
                                    Validator.validateEmail(value ?? "")),
                            const SizedBox(
                              height: 40,
                            ),
                            CustomTextField(
                                label: "Password",
                                obscureText: true,
                                hintText: "Enter your password",
                                onSaves: (newValue) {
                                  _ps = newValue!;
                                },
                                validator: (value) =>
                                    Validator.validatePassword(value ?? "")),
                            const SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                    onTap: () => Navigator.pushNamed(
                                        context, Forgotpasswordpage.id),
                                    child: const Text("ForgotPassword"),
                                  ),
                                  // const SizedBox(height: 40,),
                                  // CustomButton(onTap: signIn, txt: 'Sing in')
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            CustomButton(onTap: signIn, txt: 'Sing in'),
                            const SizedBox(
                              height: 25,
                            ),
                            Row(
                              children: [
                                Expanded(
                                    child: Divider(
                                  color: Colors.grey[400],
                                  thickness: 0.8,
                                )),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Text("or continue with"),
                                ),
                                Expanded(
                                    child: Divider(
                                  color: Colors.grey[400],
                                  thickness: 0.8,
                                )),
                              ],
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SquareTile(
                                    imagePath: "assets/images/google.png",
                                    onTap: signinWithGoogleOAuth),
                                const SizedBox(
                                  height: 20,
                                ),
                                SquareTile(
                                    imagePath: "assets/images/facebook.png",
                                    onTap: () {
                                      _fackbooklogin();
                                    }),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Not a member",
                                  style: TextStyle(color: Colors.grey[700]),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                GestureDetector(
                                  onTap: () => Navigator.pushNamed(
                                      context, Registerpage.id),
                                  child: const Text(
                                    " Register now ",
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      // ElevatedButton(
                      //   style: MyApp.btnSty,
                      //   onPressed: () {
                      //     if (_formKey.currentState!.validate()) {
                      //       _formKey.currentState!.save();
                      //       showDialog(
                      //           context: context,
                      //           builder: (context) {
                      //             return AlertDialog(
                      //               content: Text(_us),
                      //             );
                      //           });
                      //       _formKey.currentState!.reset();
                      //     }
                      //   },
                      //   child: const Text('Sign In'),
                      // )
                    ],
                  ))
            ],
          ),
        ),
      )),
    );
  }
  _fackbooklogin() async {
    final fb = FacebookLogin();

// Log in
final res = await fb.logIn(permissions: [
  FacebookPermission.publicProfile,
  FacebookPermission.email,
]);
//import 'package:flutter_login_facebook/flutter_login_facebook.dart';

// Check result status
switch (res.status) {
  case FacebookLoginStatus.success:
    // Logged in
    
    // Send access token to server for validation and auth
    final FacebookAccessToken? accessToken = res.accessToken;
    final profile = await fb.getUserProfile();
    final email = await fb.getUserEmail();
    final imageUrl = await fb.getProfileImageUrl(width: 100);

    print('Access token: ${accessToken?.token}');

    // Get profile data
    print('Hello, ${profile!.name}! You ID: ${profile.userId}');

    // Get user profile image url
    print('Your profile image: $imageUrl');

    // Get email (since we request email permission)
    // But user can decline permission
    if (email != null)
      print('And your email is $email');

    break;
  case FacebookLoginStatus.cancel:
    // User cancel log in
    break;
  case FacebookLoginStatus.error:
    // Log in failed
    print('Error while log in: ${res.error}');
    break;
}
  }
}

