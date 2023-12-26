import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ViewData extends StatefulWidget {
  const ViewData({super.key});

  @override
  State<ViewData> createState() => _ViewDataState();
}

class _ViewDataState extends State<ViewData> {
  List userdata = [];

  Future<void> deleterow(String contact) async {
    try {
      String uri = "https://atrakarnaaapi.000webhostapp.com/delete_row.php";
      var res = await http.post(Uri.parse(uri), body: {"contact": contact});
      var response = jsonDecode(res.body);
      if (response["Success"] == "true") {
        print("record deleted");
        getdata();
      } else {
        print("failed try again");
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> getdata() async {
    String uri = "https://atrakarnaaapi.000webhostapp.com/get_data.php";
    try {
      var res = await http.get(Uri.parse(uri));
      setState(() {
        userdata = jsonDecode(res.body);
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  void initState() {
    setState(() {
      getdata();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Karna Users",
          style: TextStyle(
              color: Colors.white, fontSize: 22, fontWeight: FontWeight.w600),
        ),
        shadowColor: Colors.black87,
        backgroundColor: Colors.indigo.shade400,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 25, right: 35),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Numbers of User :",
                  style: TextStyle(
                    fontSize: 22,
                  ),
                ),
                CircleAvatar(
                  backgroundColor: Colors.indigo.shade400,
                  child: Text(
                    "${userdata.length}",
                    style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          Center(
            child: Container(
              margin: const EdgeInsets.all(10),
              height: 500,
              width: 500,
              child: ListView.builder(
                itemCount: userdata.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    color: Colors.grey.shade100,
                    elevation: 5,
                    margin: const EdgeInsets.all(10),
                    child: ListTile(
                      title: Text(
                        " Name  : ${userdata[index]["u_name"]}",
                        style: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            " Age        : ${userdata[index]["u_age"]} ",
                            style: const TextStyle(color: Colors.black),
                          ),
                          Text(
                            " Gender   : ${userdata[index]["u_gender"]}",
                            style: const TextStyle(color: Colors.black),
                          ),
                          Text(
                            " Contact  : ${userdata[index]["u_number"]}",
                            style: const TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                      trailing: IconButton(
                          onPressed: () {
                            deleterow(userdata[index]["u_number"]);
                          },
                          icon: const Icon(Icons.delete_rounded)),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          backgroundColor: Colors.indigo.shade400,
          onPressed: () {
            setState(() {
              getdata();
            });
          },
          child: const Icon(
            Icons.refresh_rounded,
            size: 30,
            color: Colors.white,
          )),
      bottomNavigationBar: BottomAppBar(
        color: Colors.grey.shade200,
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(icon: const Icon(Icons.home), onPressed: () {}),
            IconButton(
                icon: const Icon(Icons.auto_graph_rounded), onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
