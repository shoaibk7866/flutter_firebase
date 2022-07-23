import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirestoreHome extends StatefulWidget {
  const FirestoreHome({Key? key}) : super(key: key);

  @override
  _FirestoreHomeState createState() => _FirestoreHomeState();
}

class _FirestoreHomeState extends State<FirestoreHome> {
  //Get all data of documents that exist in one collection for change listener we used includeMetadataChanges: true
  late Stream<QuerySnapshot> collectionStream;
  late Stream<DocumentSnapshot> _stream;

  @override
  void initState() {
     collectionStream = FirebaseFirestore.instance.collection('Users').snapshots();
    _stream = FirebaseFirestore.instance.collection("Users").doc(FirebaseAuth.instance.currentUser!.uid).snapshots();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Firestore Home"),
      ),
        body: _body()
    );
  }

  Widget _body() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                  height: 50,
                  width: 150,
                  decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: TextButton(onPressed: () {
                    _readDocumentData();
                  }, child: Text('Read Document',style: TextStyle(color: Colors.white),))),
              Container(
                  height: 50,
                  width: 150,
                  decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: TextButton(onPressed: () {
                    _readOneField();
                  }, child: Text('Read Field',style: TextStyle(color: Colors.white),))),
            ],
          ),
          const SizedBox(height: 5,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                  height: 50,
                  width: 150,
                  decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: TextButton(onPressed: () {
                    _readAllDocuments();
                  }, child: Text('Read All Data',style: TextStyle(color: Colors.white)))),
              Container(
                  height: 50,
                  width: 150,
                  decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: TextButton(onPressed: () {
                    _updateSimpleData();
                  }, child: Text('Update Data',style: TextStyle(color: Colors.white)))),
            ],
          ),
          const SizedBox(height: 5,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                  height: 50,
                  width: 150,
                  decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: TextButton(onPressed: () {
                    _updateAddress();
                  }, child: Text('Update Address',style: TextStyle(color: Colors.white),))),
              Container(
                  height: 50,
                  width: 150,
                  decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: TextButton(onPressed: () {
                    _deleteDoc();
                  }, child: Text('Delete Data',style: TextStyle(color: Colors.white)))),
            ],
          ),
          const SizedBox(height: 5,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                  height: 50,
                  width: 150,
                  decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: TextButton(onPressed: () {
                    _deleteField();
                  }, child: Text('Delete Field',style: TextStyle(color: Colors.white)))),
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
            ],
          ),
          const SizedBox(height: 5,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
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
            ],
          ),
          const SizedBox(height: 5,),
          Container(
              height: 50,
              width: 220,
              decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(10)
              ),
              child: TextButton(onPressed: () {
                _updateFieldAllDocument();
              }, child: Text('Update Field In All Document',style: TextStyle(color: Colors.white)))),
          const SizedBox(height: 5,),
          Container(
              height: 50,
              width: 220,
              decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(10)
              ),
              child: TextButton(onPressed: () {
                _writeInAllDocument();
              }, child: Text('Write New Field In All Document',style: TextStyle(color: Colors.white)))),
          const SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  children: [
                    const Text('Stream Read Document',style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
                  ],
                )),
          ),
          StreamBuilder<DocumentSnapshot>(
            stream: _stream,
            builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot){
              if(snapshot.hasError){
               print('error hai');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text("Loading");
              }
              final data = snapshot.data?.data() as Map<String,dynamic>;
              Users user = Users.fromJson(data);

              return Text('name=${user.name} city=${user.address!.city}',style: TextStyle(fontSize: 17),);
            },
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  children: [
                    const Text('Stream Read Collection',style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
                  ],
                )),
          ),
          const SizedBox(height: 10,),
          _readAllData(),
         ],
      ),
    );
  }

  //region Write Methods
  _writeOneData(Users users)async{
    final docUser = FirebaseFirestore.instance.collection("Users").doc(FirebaseAuth.instance.currentUser!.uid);
    final json = users.toJson();
    await docUser.set(json);
  }

  _writeNewNode()async{
    final docUser = FirebaseFirestore.instance.collection("Users2").doc("my_id");
    final map = {
      "name":"Shoaib",
      "address": {
        "city": "Lahore",
        "country":"Pakistan"
      }
    };
    await docUser.set(map);
  }

  _writeListOfObjects()async{
    final docUser = FirebaseFirestore.instance.collection("Users").doc("my_id");
    final map = {
      "name":[
        {
          "Object1": "1"
        },
        {
          "Object2": "2"
        },
        {
          "Object3": "3"
        },
      ]
    };
    await docUser.set(map);
  }
  //endregion

  //region Read Method
  Widget _readAllData(){
    return StreamBuilder(
      stream: collectionStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }
        List<Users> user = [];
        print(snapshot.data!.docs.length);
        snapshot.data!.docs.forEach((element) {
          user.add(Users(
            id: element.get("id"),
            age: element.get("age"),
            name: element.get("name"),
            birthday: element.get("birthday"),
            address: Address.fromJson(element.get("address"))
          ));
        });
        for(int i=0; i<user.length; i++){
          print('User name=${user[i].name} User city=${user[i].address!.city}');
        }

        return Container(
          padding: EdgeInsets.only(left: 20,right: 20),
          child: ListView.builder(
              itemCount: user.length,
              shrinkWrap: true,
              itemBuilder: (contaxt, index){
                return Container(
                  margin: EdgeInsets.only(bottom: 10),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black)
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('User Name: ${user[index].name}'),
                    Text('User Country: ${user[index].address!.country}'),
                  ],
                  ),
                );
          }),
        );
      },
    );
  }

  _readDocumentData(){
    final docRef = FirebaseFirestore.instance.collection("Users").doc(FirebaseAuth.instance.currentUser!.uid);
    docRef.get().then(
          (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        print(data.toString());
      },
      onError: (e) => print("Error getting document: $e"),
    );
  }

  _readOneField(){
    final docRef = FirebaseFirestore.instance.collection("Users").doc(FirebaseAuth.instance.currentUser!.uid);
    docRef.get().then(
          (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        Users _objectData = Users.fromJson(data);
        print('name=${_objectData.name}');
        print('country=${_objectData.address!.country}');
      },
      onError: (e) => print("Error getting document: $e"),
    );
  }

  _readAllDocuments()async{
    await FirebaseFirestore.instance.collection("Users").get().then((event) {
      for (var doc in event.docs) {
        print("${doc.id} => ${doc.data()}");
      }
    });
  }

  //endregion

  //region Update Method
  _updateSimpleData() {
    FirebaseFirestore.instance.collection("Users").doc(FirebaseAuth.instance.currentUser!.uid)
        .update({"name": "Khalid"});
  }

  _updateAddress(){
    FirebaseFirestore.instance.collection("Users").doc(FirebaseAuth.instance.currentUser!.uid)
        .update({"Address":{
          "city": "Pakistan"
    }});
  }

  _updateFieldAllDocument()async{
    var collection = FirebaseFirestore.instance.collection('Users');
    var querySnapshots = await collection.get();
    for (var doc in querySnapshots.docs) {
      await doc.reference.update({
        'name': 'Muhammad Shoaib',
      });
    }
  }

  _writeInAllDocument()async{
    var collection = FirebaseFirestore.instance.collection('Users');
    var querySnapshots = await collection.get();
    for (var doc in querySnapshots.docs) {
      await doc.reference.update({
        'region': 'Islam'
      });
    }
  }

  //endregion

  //region Delete Methods
  _deleteDoc(){
    FirebaseFirestore.instance.collection("Users").doc("my_id1").delete().then(
          (doc) => print("Document deleted"),
      onError: (e) => print("Error updating document $e"),
    );
  }

  _deleteField(){
    final updates = <String, dynamic>{
      "name": FieldValue.delete(),
    };

    FirebaseFirestore.instance.collection("Users").doc("my_id1").update(updates);
  }

  _deleteObjectField(){
    //Not Working
    FirebaseFirestore.instance.collection("Users").doc("my_id1")
        .update({"Address":{
      "city": FieldValue.delete()
    }});
  }
  //endregion

}

class Users {
  Users({
    required this.age,
    required this.birthday,
    required this.id,
    required this.name,
     this.address,
  });

  int age;
  String birthday;
  String id;
  String name;
  Address? address;

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
    "address": address!.toJson(),
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