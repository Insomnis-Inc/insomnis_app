import 'package:flutter/material.dart';

class ClientQaz extends StatefulWidget {
  const ClientQaz({Key? key}) : super(key: key);

  @override
  _ClientQazState createState() => _ClientQazState();
}

class _ClientQazState extends State<ClientQaz> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double v16 = width / 20;
    return Scaffold(
      body: Container(
        width: width,
        height: height,
        child: ListView(
          children: [
            //
          ],
        ),
      ),
    );
  }
}
