import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late String jsonData;
  late DatabaseReference _databaseRef;
  int count = 0;
  UploadTask? task;
  File? file;


  @override
  void initState() {
    _databaseRef = FirebaseDatabase.instance.ref();
    jsonData = '';

    //region about .listen
    //By using .listen whenever value will be update it will automatically update on every place,
    //endregion
    _databaseRef.child('Users').child(FirebaseAuth.instance.currentUser!.uid).child("address").child("counter").onValue.listen((event) {
      setState(() {
        count = int.parse(event.snapshot.value.toString());
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Home Screen"),
        ),
        body: _body());
  }

  Widget _body() {
    final fileName = file != null ? basename(file!.path) : 'No File Selected';
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Counter: $count'),
            const SizedBox(height: 10,),
            Container(
                height: 50,
                width: 150,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(10)
                ),
                child: TextButton(onPressed: () {
                  _increaseCounter();
                  }, child: Text('Update Count',style: TextStyle(color: Colors.white),))),
            const SizedBox(height: 10,),
            Container(
                height: 50,
                width: 150,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(10)
                ),
                child: TextButton(onPressed: () {
                  _readOnlyData();}, child: Text('Read Data',style: TextStyle(color: Colors.white),))),
            const SizedBox(height: 10,),
            Container(
                height: 50,
                width: 150,
                decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(10)
                ),
                child: TextButton(onPressed: () {
                  _readAllData();
                }, child: Text('Read All Data',style: TextStyle(color: Colors.white)))),
            const SizedBox(height: 10,),
            Container(
                height: 50,
                width: 150,
                decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(10)
                ),
                child: TextButton(onPressed: () {
                  _updateData();
                }, child: Text('Update Data',style: TextStyle(color: Colors.white)))),
            const SizedBox(height: 10,),
            Container(
                height: 50,
                width: 150,
                decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(10)
                ),
                child: TextButton(onPressed: () {
                  _deleteData();
                }, child: Text('Delete Data',style: TextStyle(color: Colors.white)))),
            const SizedBox(height: 10,),
            Container(
                height: 50,
                width: 150,
                decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(10)
                ),
                child: TextButton(onPressed: () {
                  final users = Users(age: 20, birthday: "birthday", id: FirebaseAuth.instance.currentUser!.uid, name: "Shoaib", address: Address(city: "Lahore",country: "Pakistan") );
                  _writeOneData(users);
                }, child: Text('Write Data',style: TextStyle(color: Colors.white)))),
            const SizedBox(height: 10,),
            Container(
                height: 50,
                width: 150,
                decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(10)
                ),
                child: TextButton(onPressed: () {
                  _writeNewNode();
                }, child: Text('Write New Node',style: TextStyle(color: Colors.white)))),
            const SizedBox(height: 10,),
            Container(
                height: 50,
                width: 150,
                decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(10)
                ),
                child: TextButton(onPressed: () {
                  _writeListOfObjects();
                }, child: Text('Write List of Objects',style: TextStyle(color: Colors.white)))),
            const SizedBox(height: 10,),
            ButtonWidget(
              text: 'Select File',
              icon: Icons.attach_file,
              onClicked: selectFile,
            ),
            Text(
              fileName,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 48),
            ButtonWidget(
              text: 'Upload File',
              icon: Icons.cloud_upload_outlined,
              onClicked: uploadFile,
            ),
            SizedBox(height: 20),
            task != null ? buildUploadStatus(task!) : Container(),
            const SizedBox(height: 10,),
            Text('Data: $jsonData')
          ],
        ),
      ),
    );
  }

  _writeOneData(Users users)async{
    //region Realtime Database
    _databaseRef.child("Users").child(FirebaseAuth.instance.currentUser!.uid).child("address").set({
      "city": "Lahore"
    });
    //endregion
  }

  _writeNewNode(){
    //region Realtime Data
    _databaseRef.child("Profile").set({
      "FirstName": "Shoaib",
      "LastName": "Khalid"
    }
    );
    //endregion
  }

  _writeListOfObjects()async{
    //region Realtime Database
    _databaseRef.child("ListOfObject").set([
      {
        "FirstName": "Shoaib",
        "LastName": "Khalid"
      },
      {
        "FirstName": "Shoaib",
        "LastName": "Khalid"
      },
    ]);
    //endregion
  }

  _readAllData(){
    //region About Read Data
  /* For Read Node data
  *     _databaseRef.child("Users").child("${FirebaseAuth.instance.currentUser?.uid}").child("address").child("country").once()
  */
    //once() method use for get all data of one node or object or complete db.
    //for read only child node use .child instead of once()
    //endregion

    _databaseRef.once().then((value) {
      print('Data : ${value.snapshot.value.toString()}');
      setState(() {
        jsonData = value.snapshot.value.toString();
      });
    });
  }

   _readDataFirestore(){
    FirebaseFirestore.instance.collection("Users").snapshots().map((snapshot) => snapshot.docs.map((e) =>  Users.fromJson(e.data()))).toList() as List<Users>;
  }

  _readOnlyData(){
    _databaseRef.child("Users").child(FirebaseAuth.instance.currentUser!.uid).child('address').child("country").once().then((value){
      setState(() {
        jsonData = value.snapshot.value.toString();
      });
    });

  }

  _updateData(){
   _databaseRef.child('Users').child(FirebaseAuth.instance.currentUser!.uid).child("address").update(
       {
        "country": "USA"
       }
       );
  }

  _increaseCounter(){
    _databaseRef.child('Users').child(FirebaseAuth.instance.currentUser!.uid).child("address").update(
        {
          "counter": count++
        }
    );
  }

  _deleteData(){
    _databaseRef.child('Users').child(FirebaseAuth.instance.currentUser!.uid).child("address").child("city").remove();
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result == null) return;
    final path = result.files.single.path!;

    setState(() => file = File(path));
  }

  Future uploadFile() async {
    if (file == null) return;

    final fileName = basename(file!.path);
    final destination = '${FirebaseAuth.instance.currentUser!.uid}/images/$fileName';

    task = FirebaseApi.uploadFile(destination, file!);
    setState(() {});

    if (task == null) return;

    final snapshot = await task!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    if(urlDownload.isNotEmpty){
      _databaseRef.child("Users").child(FirebaseAuth.instance.currentUser!.uid).child("userProfile").set(urlDownload);
    }

    print('Download-Link: $urlDownload');
  }

  Widget buildUploadStatus(UploadTask task) => StreamBuilder<TaskSnapshot>(
    stream: task.snapshotEvents,
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        final snap = snapshot.data!;
        final progress = snap.bytesTransferred / snap.totalBytes;
        final percentage = (progress * 100).toStringAsFixed(2);

        return Text(
          '$percentage %',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        );
      } else {
        return Container();
      }
    },
  );

}

// Use below class for add data if needed
// class Users {
//   Users({
//     required this.age,
//     required this.birthday,
//     required this.id,
//     required this.name,
//   });
//
//   int age;
//   String birthday;
//   String id;
//   String name;
//
//   factory Users.fromJson(Map<String, dynamic> json) => Users(
//     age: json["age"],
//     birthday: json["birthday"],
//     id: json["id"],
//     name: json["name"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "age": age,
//     "birthday": birthday,
//     "id": id,
//     "name": name,
//   };
// }
class Users {
  Users({
    required this.age,
    required this.birthday,
    required this.id,
    required this.name,
    required this.address,
  });

  int age;
  String birthday;
  String id;
  String name;
  Address address;

  factory Users.fromJson(Map<String, dynamic> json) => Users(
    age: json["age"],
    birthday: json["birthday"],
    id: json["id"],
    name: json["name"],
    address: Address.fromJson(json["address"]),
  );

  Map<String, dynamic> toJson() => {
    "age": age,
    "birthday": birthday,
    "id": id,
    "name": name,
    "address": address.toJson(),
  };
}

class Address {
  Address({
    required this.city,
    required this.country,
  });

  String city;
  String country;

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    city: json["city"],
    country: json["country"],
  );

  Map<String, dynamic> toJson() => {
    "city": city,
    "country": country,
  };
}


class ButtonWidget extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onClicked;

  const ButtonWidget({
    Key? key,
    required this.icon,
    required this.text,
    required this.onClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => ElevatedButton(
    style: ElevatedButton.styleFrom(
      primary: Color.fromRGBO(29, 194, 95, 1),
      minimumSize: Size.fromHeight(50),
    ),
    child: buildContent(),
    onPressed: onClicked,
  );

  Widget buildContent() => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, size: 28),
      SizedBox(width: 16),
      Text(
        text,
        style: TextStyle(fontSize: 22, color: Colors.white),
      ),
    ],
  );
}

class FirebaseApi {
  static UploadTask? uploadFile(String destination, File file) {
    try {
      final ref = FirebaseStorage.instance.ref(destination);

      return ref.putFile(file);
    } on FirebaseException catch (e) {
      return null;
    }
  }

  static UploadTask? uploadBytes(String destination, Uint8List data) {
    try {
      final ref = FirebaseStorage.instance.ref(destination);

      return ref.putData(data);
    } on FirebaseException catch (e) {
      return null;
    }
  }
}