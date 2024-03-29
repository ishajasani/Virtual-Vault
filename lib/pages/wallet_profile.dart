import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:virtualvault/config/walletprovider.dart';
import 'package:web3dart/web3dart.dart';

class WalletProfile extends StatefulWidget {
  const WalletProfile({super.key});

  @override
  State<WalletProfile> createState() => _WalletProfileState();
}

class _WalletProfileState extends State<WalletProfile> {
  @override
  void initState() {
    getUserData();
    super.initState();
  }

  double accountBalance = 0;
  WalletProvider walletProvider = WalletProvider();

  getUserData() async {
    await walletProvider.initializeWallet();
    EtherAmount etherAmount =
        await Web3Client("HTTP://192.168.188.141:7545", Client()).getBalance(
            EthereumAddress.fromHex(walletProvider.ethereumAddress!.hex));
    accountBalance = etherAmount.getInEther.toDouble();

    if (kDebugMode) {
      print("Balance: $accountBalance");
      print(walletProvider.ethereumAddress);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () {
                getUserData();
              },
              icon: const Icon(Icons.refresh_outlined))
        ],
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 8,
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "Wallet Address",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 30),
                ),
                TextButton(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(
                        text: walletProvider.ethereumAddress.toString()));
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Copied to clipboard'),
                    ));
                  },
                  child: Text(
                    walletProvider.ethereumAddress.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black.withOpacity(.5), fontSize: 18),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Center(
                  child: Text(
                    "Your Ether balance",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                        height: MediaQuery.of(context).size.width / 11,
                        child: Image.asset('images/matic.png')),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      "$accountBalance Eth",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).size.width / 10),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: 100,
                    height: 40,
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(20)),
                    child: const Center(
                      child: Text(
                        "Add",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
