import 'package:flutter/material.dart';
import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flutterdemo/upload_img.dart';
import 'dart:ui';

const appScheme = 'flutterdemo';

/// -----------------------------------
///           Profile Widget
/// -----------------------------------

class ProfileIcon extends StatelessWidget {
  final Future<void> Function() logoutAction;
  final UserProfile? user;

  const ProfileIcon({required this.logoutAction, required this.user, Key? key}) : super(key: key);

  void _showPopupMenu(BuildContext context) {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;

    showMenu<String>(
      context: context,
      position: RelativeRect.fromRect(
        Offset(overlay.size.width - 80, 80) & Size(100, 100), // Positioning below the icon
        Offset.zero & overlay.size,
      ),
      items: [
        PopupMenuItem<String>(
          value: 'username',
          child: Text('Name: ${user?.name ?? 'User'}'), // Displaying the name here
        ),
        const PopupMenuItem<String>(
          value: 'logout',
          child: Text('Logout'),
        ),
      ],
    ).then((value) async {
      if (value == 'logout') {
        await logoutAction();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showPopupMenu(context),
      child: CircleAvatar(
        radius: 20,
        backgroundImage: NetworkImage(user?.pictureUrl.toString() ?? ''),
        backgroundColor: Colors.grey,
        child: user?.pictureUrl == null ? const Text('S', style: TextStyle(color: Colors.white)) : null,
      ),
    );
  }
}

/// -----------------------------------
///            Login Widget
/// -----------------------------------

class Login extends StatelessWidget {
  final Future<void> Function() loginAction;
  final String loginError;

  const Login({required this.loginAction, required this.loginError, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ElevatedButton(
          onPressed: () async {
            await loginAction();
          },
          child: const Text('Login'),
        ),
        if (loginError.isNotEmpty)
          Text(
            loginError,
            style: const TextStyle(color: Color(0x8B6D57FA)),
            textAlign: TextAlign.center,
          ),
      ],
    );
  }
}

/// -----------------------------------
///             MyAppPage
/// -----------------------------------

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _MyAppPageState createState() => _MyAppPageState();
}

/// -----------------------------------
///            MyAppPage State
/// -----------------------------------

class _MyAppPageState extends State<LoginPage> {
  Credentials? _credentials;
  late Auth0 auth0;

  bool isBusy = false;
  late String errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'DIY',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF33244D),
        centerTitle: true,
        actions: [
          if (_credentials != null)
            ProfileIcon(logoutAction: logoutAction, user: _credentials?.user), // Profile icon in app bar
        ],
      ),
      body: Stack(
        children: [
          // Solid color background with blur effect
          Positioned.fill(
            child: Container(
              color: Color(0xF2B293F3).withOpacity(0.5),
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                color: Colors.black.withOpacity(0.1),
              ),
            ),
          ),
          // Main content
          Center(
            child: isBusy
                ? const CircularProgressIndicator()
                : _credentials != null
                ? Container() // Just leave it empty as the profile icon is in the AppBar
                : Login(loginAction: loginAction, loginError: errorMessage),
          ),
        ],
      ),
    );
  }

  Future<void> loginAction() async {
    setState(() {
      isBusy = true;
      errorMessage = '';
    });

    try {
      final Credentials credentials = await auth0.webAuthentication(scheme: appScheme).login();

      setState(() {
        isBusy = false;
        _credentials = credentials;
      });

      // After successful login, navigate to the Upload Image page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => UploadImagePage(
            user: _credentials?.user, // Pass the user profile here
            logoutAction: logoutAction, // Pass the logoutAction function directly
          ),
        ),
      );
    } on Exception catch (e, s) {
      debugPrint('login error: $e - stack: $s');

      setState(() {
        isBusy = false;
        errorMessage = e.toString();
      });
    }
  }

  Future<void> logoutAction() async {
    await auth0.webAuthentication(scheme: appScheme).logout();

    setState(() {
      _credentials = null;
    });
  }

  @override
  void initState() {
    super.initState();

    auth0 = Auth0('dev-2ket6d32wtxj6upw.us.auth0.com', 'mtNwzMXsU5oN08zYjzNrJNBn2h11PU3i');
    errorMessage = '';
  }
}
