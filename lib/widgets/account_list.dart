import 'package:flutter/material.dart';
import 'package:flutter_bloc_cubit/models/accounts.dart';

Future<void> showAccountDialog(BuildContext context, textController) {
  return showGeneralDialog(
    barrierLabel: "Label",
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: Duration(milliseconds: 400),
    context: context,
    pageBuilder: (context, anim1, anim2) {
      return Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: 300,
          child: SizedBox.expand(
              child: Padding(
            padding: const EdgeInsets.all(11.0),
            child: ListView.builder(
                itemCount: accounts.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    child: Card(
                      child: ListTile(
                        leading: Icon(accounts[index]["account_icon"]),
                        title: Text("${accounts[index]["account_name"]}"),
                        onTap: () {
                          textController.text = accounts[index]["account_name"];
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  );
                }),
          )),
          margin: EdgeInsets.only(bottom: 120, left: 12, right: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(40),
          ),
        ),
      );
    },
  );
}
