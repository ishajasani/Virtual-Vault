// import 'dart:html';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:virtualvault/config/contract_linking.dart';
import 'package:virtualvault/config/ipfs_service.dart';
import 'package:virtualvault/config/walletservice.dart';
import 'package:virtualvault/pages/imageviwer.dart';
import 'package:web3dart/web3dart.dart';
//import 'package:http/http.dart' as http;

class Myhome extends StatefulWidget {
  const Myhome({super.key});

  @override
  State<Myhome> createState() => _MyhomeState();
}

class _MyhomeState extends State<Myhome> {
  bool isLoading = false;
  bool isSelected = false;
  List cids = [];
  Credentials? credential;
  ContractLinking contractLinking = ContractLinking();
  WalletService walletService = WalletService();
  getCidsFromUser() async {
    await getData();
    cids = await contractLinking.getUserData(credential!.address);
    print(cids);
    setState(() {});
  }

  getData() async {
    String privKey = await walletService.getPrivateKey();
    credential = EthPrivateKey.fromHex(privKey);
  }

  String path = "";
  uploadFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      File file = File(result.files.single.path!);
      path = file.path;
      if (kDebugMode) {
        print(file.path);
      }
      setState(() {
        isSelected = true;
      });
    } else {
      // User canceled the picker
    }
  }

  @override
  void initState() {
    super.initState();
    getCidsFromUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const NavigationDrawer(),
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () async {
                  await getCidsFromUser();
                },
                icon: const Icon(Icons.refresh))
          ],
          title: const Text(
            'Home',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          backgroundColor: const Color(0xff1F4CA4),
        ),
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: ListView.builder(
                    itemCount: cids.length,
                    itemBuilder: ((context, index) => ListTile(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      DocViewer(imageCid: cids[index]))),
                          title: Text(index.toString()),
                          subtitle: Text(cids[index]),
                        ))),
              ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FloatingActionButton.extended(
                heroTag: 'btn1',
                icon: const Icon(Icons.add),
                onPressed: () async {
                  if (isSelected) {
                    setState(() {
                      isLoading = true;
                    });
                    IpfsService ipfsService = IpfsService();
                    String cid = await ipfsService.uploadImage(path);

                    contractLinking.registerUser(cid);
                    getCidsFromUser();
                    setState(() {
                      path == "";
                      isLoading = false;
                    });
                  }
                },
                label: const Text('Upload')),
            const SizedBox(width: 10),
            FloatingActionButton.extended(
                heroTag: "btn2",
                icon: const Icon(Icons.file_copy_outlined),
                onPressed: uploadFiles,
                label: const Text('Pick File')),
          ],
        ));
  }
}

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({super.key});

  @override
  Widget build(BuildContext context) => Drawer(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              buildHeader(context),
              buildMenuItems(context),
            ],
          ),
        ),
      );
  Widget buildHeader(BuildContext context) => Container(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      );

  Widget buildMenuItems(BuildContext context) => Container(
      padding: const EdgeInsets.all(24),
      child: Wrap(
        runSpacing: 16,
        children: [
          ListTile(
            leading: const Icon(
              Icons.logout,
              size: 30,
            ),
            title: const Text(
              'Logout',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            onTap: () {
              Navigator.pushNamed(context, 'authenticatewallet');
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.person,
              size: 30,
            ),
            title: const Text(
              'Profile',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            onTap: () {
              Navigator.pushNamed(context, 'walletprofile');
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.contact_support_sharp,
              size: 30,
            ),
            title: const Text(
              'About us',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, 'about');
            },
          ),
        ],
      ));
}
