import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notes/component/toast.dart';
import 'package:notes/data/services/account_service.dart';

import '../../component/alert.dart';

class LogIn extends StatefulWidget {
  const LogIn({Key? key}) : super(key: key);

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  String? email, password;
  GlobalKey<FormState> formState = GlobalKey<FormState>();

  logIn() async {
    var formData = formState.currentState;
    if (formData!.validate()) {
      formData.save();
      try {
        showLoading(context);
        await AccountService().logIn(email!, password!).then((userCredential) {
          Navigator.of(context).pushReplacementNamed("/");
        });
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          Navigator.of(context).pop();
          showToast("No user found for that email");
        } else if (e.code == 'wrong-password') {
          Navigator.of(context).pop();
          showToast("Wrong password provided for that user");
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: Image.asset("images/logo.png")),
          Container(
            padding: const EdgeInsets.all(20),
            child: Form(
                key: formState,
                child: Column(
                  children: [
                    TextFormField(
                      onSaved: (val) {
                        email = val;
                      },
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return "Email can't to be empty";
                        }
                        else if (val.length < 5) {
                          return "Email is too short";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.person),
                          hintText: "Email",
                          border: OutlineInputBorder(
                              borderSide: BorderSide(width: 1)
                          )
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      onSaved: (val) {
                        password = val;
                      },
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return "Password can't be empty";
                        } else if (val.length < 6) {
                          return "Password is too short";
                        }
                        return null;
                      },
                      obscureText: true,
                      decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.person),
                          hintText: "Password",
                          border: OutlineInputBorder(
                              borderSide: BorderSide(width: 1)
                          )
                      ),
                    ),
                    Container(
                        margin: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            const Text("If you haven't account"),
                            InkWell(
                              onTap: () {
                                Navigator.of(context)
                                    .pushReplacementNamed("/sign_up");
                              },
                              child: const Text(
                                "Click Here",
                                style: TextStyle(color: Colors.blue),
                              ),
                            )
                          ],
                        )),
                    ElevatedButton(
                      onPressed: () async {
                        await logIn();
                      },
                      child: Text(
                        "Sign in",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    )
                  ],
                )),
          )
        ],
      ),
    );
  }
}
