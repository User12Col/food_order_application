import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_order_app/model/user.dart' as model;
import 'package:food_order_app/validate/validate.dart';

class UserRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> signinWithEmailAndPassword(
      String email, String password) async {
    String response = 'Some error';
    if (email.isNotEmpty && password.isNotEmpty) {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      response = 'Login Success';
    } else {
      response = 'Pls enter all field';
    }
    return response;
  }

  Future<model.User> getUserDetails() async{
    User currUser = _firebaseAuth.currentUser!;

    DocumentSnapshot snap = await _firestore.collection('users').doc(currUser.uid).get();

    return model.User.fromSnap(snap);
  }

  Future<String> createUserWithEmailAndPassword(
      String email,
      String password,
      String cfpassword,
      String fullName,
      String phoneNumber,
      String address) async {
    String response = 'Some error';
    if (email.isNotEmpty && password.isNotEmpty && cfpassword.isNotEmpty) {
      if (Validate.isMatchPassword(password, cfpassword)) {

        UserCredential userCredential = await _firebaseAuth
            .createUserWithEmailAndPassword(email: email, password: password);
        model.User user = model.User(
            id: userCredential.user!.uid,
            fullName: fullName,
            email: email,
            phoneNumber: phoneNumber,
            password: password,
            address: address,
            order: [],
            cart: []);

        await _firestore
            .collection('users')
            .doc(userCredential.user!.uid)
            .set(user.toJson());

        response = 'Success';
      } else {
        response = 'Your password doesnt match';
      }
    } else {
      response = 'Pls enter all field';
    }
    return response;
  }

  Future<void> updateAddress(String address) async{
    try{
      await _firestore.collection('users').doc(_firebaseAuth.currentUser!.uid).update({
        'address': address,
      });
    } catch(e){
      print(e);
    }

  }

  Future<String> updateUserInformation(String fullName, String phone, String email) async {
    String response = 'fail';
    try{
      await _firestore.collection('users').doc(_firebaseAuth.currentUser!.uid).update({
        'email': email,
        'fullName': fullName,
        'phoneNumber': phone,
      });
      response = 'success';
    }catch(e){
      print(e);
    }
    return response;
  }

  Future<String> updatePassword(String newPassword) async {
    String response = 'fail';
    try{
      await _firestore.collection('users').doc(_firebaseAuth.currentUser!.uid).update({
        'password': newPassword,
      });
      response = 'success';
    }catch(e){
      print(e);
    }
    return response;
  }

  Future<bool> isPassword(String password) async {
    var userSnap =  await _firestore.collection('users').doc(_firebaseAuth.currentUser!.uid).get();
    String userPass = await userSnap.data()!['password'];
    if(userPass == password){
      return true;
    }
    return false;
  }

  Future<bool> isSignIn() async {
    return await _firebaseAuth.currentUser != null;
  }

  Future<void> signOut() async {
    _firebaseAuth.signOut();
  }
}
