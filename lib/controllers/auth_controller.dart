import 'package:ecommerce_app/const.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthController {
  signUpUser(
      String full_name, String username, String email, String password) async {
    String res = 'error uhvacen';
    try {
      if (full_name.isNotEmpty &&
          username.isNotEmpty &&
          email.isNotEmpty &&
          password.isNotEmpty) {
        UserCredential cred = await firebaseAuth.createUserWithEmailAndPassword(
            email: email, password: password);
        print(cred.user!.email);
        res = 'Succes';
      } else {
        res = 'Fields cannot be empty!!!!';
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }
}
