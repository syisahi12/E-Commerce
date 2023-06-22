import 'package:final_project/screens/admin_screen.dart';
import 'package:final_project/screens/cashier_screen.dart';
import 'package:final_project/screens/main_screen.dart';
import 'package:final_project/screens/signup_screen.dart';
import 'package:final_project/utils/color_utils.dart';
import 'package:final_project/widgets/reusable_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../utils/firebase_utils.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();

  @override
  void dispose() {
    _emailTextController.dispose();
    _passwordTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String _errorMessage = '';
    bool _isLoading = false;
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          hexStringToColor("39A848"),
          hexStringToColor("39A848"),
          hexStringToColor("39A848")
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                20, MediaQuery.of(context).size.height * 0.2, 20, 0),
            child: Column(
              children: [
                logoWidget("assets/images/logo.png"),
                const SizedBox(
                  height: 30,
                ),
                signinTextField("Enter Email", Icons.alternate_email_outlined,
                    false, _emailTextController),
                const SizedBox(
                  height: 20.0,
                ),
                signinTextField("Enter Password", Icons.lock_outline, true,
                    _passwordTextController),
                const SizedBox(
                  height: 20.0,
                ),
                signInUpButton(context, true, () async {
                  setState(() {
                    _isLoading = true;
                    _errorMessage = '';
                  });
                  try {
                    UserCredential userCredential =
                        await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: _emailTextController.text.trim(),
                      password: _passwordTextController.text.trim(),
                    );

                    String email = userCredential.user!.email!;
                    UserRole userRole = await getUserRole(email);

                    if (userRole == UserRole.admin) {
                      if (context.mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (BuildContext context) {
                            return const AdminScreen();
                          }),
                        );
                      }
                    } else if (userRole == UserRole.kasir) {
                      if (context.mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CashierScreen()),
                        );
                      }
                    } else if (userRole == UserRole.users) {
                      if (context.mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MainScreen()),
                        );
                      }
                    }
                  } catch (error) {
                    setState(() {
                      _errorMessage =
                          'Login failed. Please check your email and password.';
                    });
                    // Mengambil pesan kesalahan dari Firebase
                    String firebaseErrorMessage = error.toString();

                    // Menampilkan pesan kesalahan dalam Snackbar
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(firebaseErrorMessage),
                      ),
                    );
                  }
                  setState(() {
                    _isLoading = false;
                  });
                }),
                const SizedBox(
                  height: 20.0,
                ),
                adminButton(context, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AdminScreen()),
                  );
                }),
                const SizedBox(
                  height: 20.0,
                ),
                signUpOption(context)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Row signUpOption(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Text("Don't have account? ",
          style: TextStyle(color: Colors.white70)),
      GestureDetector(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const SignUpScreen()));
        },
        child: const Text(
          "SignUp",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      )
    ],
  );
}

Container adminButton(BuildContext context, Function onTap) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 50,
    margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
    child: ElevatedButton(
      onPressed: () {
        onTap();
      },
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.pressed)) {
              return Colors.black26;
            }
            return Colors.white;
          }),
          shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)))),
      child: const Text(
        'ADMIN',
        style: TextStyle(
            color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 16),
      ),
    ),
  );
}
