import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/const.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AuthController {
  //! Function to add image to storage

  _uploadImageToStorage(Uint8List image) async {
    Reference ref = firebaseStorage
        .ref()
        .child('profilePics')
        .child(firebaseAuth.currentUser!.uid);

    UploadTask uploadTask = ref.putData(image);

    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  //! FUNCTION TO ENABLE USER TO PICK IMAGE

  pickImage(ImageSource source) async {
    final ImagePicker _imagePicker = ImagePicker();
    XFile? _file = await _imagePicker.pickImage(source: source);
    if (_file != null) {
      return await _file.readAsBytes();
    } else {
      print('No Image Selected!!!');
    }
  }

  // !FUNCTION TO SIGNUP USERS
  signUpUser(String full_name, String username, String email, String password,
      Uint8List? image) async {
    String res = 'error uhvacen';
    try {
      if (full_name.isNotEmpty &&
          username.isNotEmpty &&
          email.isNotEmpty &&
          password.isNotEmpty &&
          image != null) {
        UserCredential cred = await firebaseAuth.createUserWithEmailAndPassword(
            email: email, password: password);

        String downloadUrl = await _uploadImageToStorage(image);

        await firebaseStore.collection('users').doc(cred.user!.uid).set({
          'fullName': full_name,
          'username': username,
          'email': email,
          'image': downloadUrl
        });
        print(cred.user!.email);
        res = 'success';
      } else {
        res = 'Fields cannot be empty!!!!';
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  //! FUNCTION TO LOGIN USERS

  loginUsers(String email, String password) async {
    String res = 'somme error again xd ';
    try {
      if (email.isEmpty && password.isNotEmpty) {
        await firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password);
        res = 'success';
        print('you are now logged in');
      } else {
        res = 'please fields must be not be empty';
      }
    } catch (e) {
      res = e.toString();
    }
  }
}

showSnackBar(String content, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(content)));
}
