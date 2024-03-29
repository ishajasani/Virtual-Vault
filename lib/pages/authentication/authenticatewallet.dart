import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:virtualvault/config/walletprovider.dart';
import 'package:virtualvault/pages/home.dart';
import 'package:virtualvault/widgets/custom_buttons.dart';
import 'package:virtualvault/widgets/custom_textfields.dart';

class AuthenticateWallet extends StatefulWidget {
  const AuthenticateWallet({super.key});

  @override
  State<AuthenticateWallet> createState() => _AuthenticateWalletState();
}

class _AuthenticateWalletState extends State<AuthenticateWallet> {
  TextEditingController keyController = TextEditingController();
  handleLogin() async {
    bool isValid = await WalletProvider().initializeFromKey(keyController.text);
    if (isValid) {
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const Myhome()));
    } else {
      if (kDebugMode) {
        print("Invalid Key");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 4,
                    ),
                    Text("Enter your wallet credentials.",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: MediaQuery.of(context).size.width / 7,
                            fontWeight: FontWeight.bold)),
                    Row(
                      children: [
                        Text("Don't have a wallet?",
                            style: TextStyle(
                              color: Colors.black.withOpacity(.5),
                              fontSize: 20,
                            )),
                        const SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          onTap: () =>
                              Navigator.pushNamed(context, 'createwallet'),
                          child: Text("Create one",
                              style: TextStyle(
                                color: Colors.black.withOpacity(.5),
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                decoration: TextDecoration.underline,
                              )),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    PrivateKeyField(
                      controller: keyController,
                      hintText:
                          "39bc2eb50999a396fa6ab7ff615bef86fb4cfe9bbd5d6c42bb0668c297a2eaa6",
                      labelText: "Private key",
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    DefaultButton(text: "Verify", onPress: handleLogin),
                    const SizedBox(
                      height: 20,
                    )
                  ],
                ),
              ),
            )));
  }
}
