import 'dart:async';
import 'package:ch15/services/authentication_api.dart';

class AuthenticationBloc {
  final AuthenticationApi authenticationApi;

  final StreamController<String> _authenticationController =
      StreamController<String>();
  Sink<String> get addUser => _authenticationController.sink;
  Stream<String> get user => _authenticationController.stream;

  final StreamController<bool> _logoutController = StreamController<bool>();
  Sink<bool> get logoutUser => _logoutController.sink;
  Stream<bool> get listLogoutUser => _logoutController.stream;

  AuthenticationBloc(this.authenticationApi) {
    onAuthChanged();
  }

  // We will not manually call the dispose()
  // because it needs to be accessible throughout the lifetime of the app
  void dispose() {
    _authenticationController.close();
    _logoutController.close();
  }

  void onAuthChanged() {
    authenticationApi.getFirebaseAuth().authStateChanges().listen((user) {
      if (user != null) {
        final String uid = user.uid;
        print('User signed in. UID: $uid');
        addUser.add(uid);
      } else {
        print('User signed out.');
        addUser.add(''); // Use an empty string as a default value
      }
    });

    _logoutController.stream.listen((logout) {
      if (logout == true) {
        _signOut();
      }
    });
  }

  void _signOut() {
    authenticationApi.signOut();
  }
}
