import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notes/component/toast.dart';
import 'package:notes/data/services/account_service.dart';

import '../../component/alert.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  late String? userName, password, email;
  GlobalKey<FormState> formState = GlobalKey<FormState>();

  signUp() async {
    var formData = formState.currentState;
    if (formData!.validate()) {
      formData.save();

      try {
        showLoading(context);
        await AccountService().signUp(userName!, email!, password!).then((userCredential) {
          Navigator.of(context).pushReplacementNamed("/");
        });
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          Navigator.of(context).pop();
          showToast("Password is to weak");
        } else if (e.code == 'email-already-in-use') {
          Navigator.of(context).pop();
          showToast("The account already exists for that email");
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          const SizedBox(height: 100),
          Center(child: Image.asset("images/logo.png")),
          Container(
            padding: const EdgeInsets.all(20),
            child: Form(
                key: formState,
                child: Column(
                  children: [
                    TextFormField(
                      onSaved: (val) {
                        userName = val;
                      },
                      validator: (val) {
                        if (val!.length > 100) {
                          return "username can't to be larger than 100 letter";
                        }
                        if (val.length < 2) {
                          return "username can't to be less than 2 letter";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.person),
                          hintText: "User Name",
                          border: OutlineInputBorder(
                              borderSide: BorderSide(width: 1)
                          )
                      ),
                    ),
                    const SizedBox(height: 20),
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
                          hintText: "email",
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
                            const Text("If you have Account "),
                            InkWell(
                              onTap: () {
                                Navigator.of(context).pushNamed("login");
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
                        await signUp();
                      },
                      child: Text(
                        "Sign Up",
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
